import 'package:ask/questions/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class QuestionPage extends StatefulWidget {
  QuestionPage({super.key, required this.post, required this.documentId});

  final String documentId;
  Post post;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Post get post => widget.post;

  bool isDeleted = false;

  @override
  Widget build(BuildContext context) {
    if (isDeleted) {
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          final snapshot =
              await firestore.collection('posts').doc(widget.documentId).get();
          if (!snapshot.exists) {
            setState(() {
              isDeleted = true;
            });
            return;
          }

          setState(() {
            widget.post = Post.fromJson(snapshot.data()!);
          });
        },
        child: RawScrollbar(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  post.category.makeBox(context),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Transform.scale(
                          scale: 0.6,
                          child: Icon(Icons.person,
                              color: Theme.of(context).colorScheme.secondary)),
                      Text(
                        post.anonymous ? "익명" : post.writer,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Transform.scale(
                          scale: 0.6,
                          child: Icon(Icons.access_time,
                              color: Theme.of(context).colorScheme.secondary)),
                      Text(
                        post.displayTime(),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    post.title,
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    post.body,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

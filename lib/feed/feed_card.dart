import 'package:ask/questions/post.dart';
import 'package:ask/questions/question_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedCard extends StatefulWidget {
  const FeedCard({super.key, required this.data, required this.documentId});

  final String documentId;
  final Map<String, dynamic> data;

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  late Post post;

  @override
  Widget build(BuildContext context) {
    post = Post.fromJson(widget.data);

    final cardBorderRadius = BorderRadius.circular(12);

    return Card(
        shape: RoundedRectangleBorder(borderRadius: cardBorderRadius),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => QuestionPage(
                        documentId: widget.documentId, post: post)));
          },
          borderRadius: cardBorderRadius,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        post.category.makeBox(context),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          post.displayTime(),
                          style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ],
                    ),
                    const Spacer()
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  post.title,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  post.body,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ));
  }
}

import 'package:ask/questions/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommentView extends StatefulWidget {
  const CommentView({super.key, required this.documentId, required this.post});

  final String documentId;
  final Post post;

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final firestore = FirebaseFirestore.instance;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> comments = [];

  Future<void> fetchComments() async {
    QuerySnapshot querySnapshots = await firestore
        .collection('comments')
        .where('document', isEqualTo: widget.documentId)
        .get();

    comments = querySnapshots.docs
        as List<QueryDocumentSnapshot<Map<String, dynamic>>>;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: comments.length,
      itemBuilder: (context, index) {
        return _CommentWidget(
          commentId: comments[index].reference.id,
          commentText: comments[index].data()['text']!,
          sender: comments[index].data()['sender']!,
        );
      },
    );
  }
}

class _CommentWidget extends StatelessWidget {
  const _CommentWidget(
      {required this.commentId,
      required this.commentText,
      required this.sender});

  final String sender;
  final String commentId;
  final String commentText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            children: [
              Transform.scale(
                  scale: 0.6,
                  child: Icon(Icons.person,
                      color: Theme.of(context).colorScheme.secondary)),
              Text(
                sender,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(commentText),
        ),
      ])),
    );
  }
}

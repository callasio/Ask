import 'package:ask/comments/comment.dart';
import 'package:ask/questions/post.dart';
import 'package:ask/vote/vote_view.dart';
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
        .orderBy('timestamp')
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
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _CommentWidget(
            commentId: comments[index].reference.id,
            comment: Comment.fromJson(comments[index].data()));
      },
    );
  }
}

class _CommentWidget extends StatelessWidget {
  const _CommentWidget({required this.commentId, required this.comment});

  final String commentId;
  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              children: [
                Transform.scale(
                    scale: 0.6,
                    child: Icon(Icons.person,
                        color: Theme.of(context).colorScheme.secondary)),
                Text(
                  comment.anonymous ? "익명" : comment.writer,
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
                  comment.displayTime(),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(comment.text),
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              const Spacer(),
              VoteView(
                  objectDocId: commentId,
                  votable: comment,
                  collectionName: 'comments'),
              const SizedBox(
                width: 10,
              )
            ],
          ),
          const SizedBox(
            height: 10,
          )
        ]));
  }
}

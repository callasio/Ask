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
    QuerySnapshot querySnapshot = await firestore
        .collection('comments')
        .where('user', isEqualTo: userId)
        .where('document', isEqualTo: widget.documentId)
        .get();

    setState(() {
      comments = querySnapshot.docs
          as List<QueryDocumentSnapshot<Map<String, dynamic>>>;
    });
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
            commentText: comments[index].data()['text']!);
      },
    );
  }
}

class _CommentWidget extends StatelessWidget {
  const _CommentWidget(
      {super.key, required this.commentId, required this.commentText});

  final String commentId;
  final String commentText;

  @override
  Widget build(BuildContext context) {
    return Text(commentText);
  }
}

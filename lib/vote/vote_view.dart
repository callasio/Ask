import 'package:ask/questions/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VoteView extends StatefulWidget {
  const VoteView({super.key, required this.documentId, required this.post});

  final String documentId;
  final Post post;

  @override
  State<VoteView> createState() => _VoteViewState();
}

class _VoteViewState extends State<VoteView> {
  final firestore = FirebaseFirestore.instance;
  final User user = FirebaseAuth.instance.currentUser!;

  int userVote = 0;
  int? _documentVote;
  int get documentVote =>
      _documentVote == null ? widget.post.vote : (_documentVote! + userVote);

  void setUserVote(int to) {
    setState(() {
      userVote = to;
      updateUserVoteServer().then((_) {
        updateDocumentVoteServer();
      });
    });
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getUserVoteDocs() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection('votes')
        .where('user', isEqualTo: user.uid)
        .where('document', isEqualTo: widget.documentId)
        .get();

    return querySnapshot.docs;
  }

  Future<void> checkUserVoteServer() async {
    final docs = await getUserVoteDocs();

    if (docs.isEmpty) {
      return;
    }

    if (docs.length > 1) {
      throw UnimplementedError("can't vote twice");
    }

    userVote = docs.first.data()['vote'];
  }

  Future<void> updateUserVoteServer() async {
    final docs = await getUserVoteDocs();

    if (docs.isEmpty) {
      await firestore.collection('votes').add(
          {'user': user.uid, 'document': widget.documentId, 'vote': userVote});
      return;
    }

    if (docs.length > 1) {
      throw UnimplementedError("can't vote twice");
    }

    await docs.first.reference.update({'vote': userVote});
  }

  Future<void> updateDocumentVoteServer() async {
    final querySnapshot = await firestore
        .collection('votes')
        .where('document', isEqualTo: widget.documentId)
        .get();

    int totalVote = 0;
    final docs = querySnapshot.docs;

    for (final doc in docs) {
      totalVote += doc.data()['vote'] as int;
    }

    await firestore
        .collection('posts')
        .doc(widget.documentId)
        .update({'vote': totalVote});
  }

  @override
  void initState() {
    super.initState();

    checkUserVoteServer().then((_) => setState(() {
          _documentVote = widget.post.vote - userVote;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Theme.of(context).dividerColor)),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  if (userVote <= 0) {
                    setUserVote(1);
                  } else {
                    setUserVote(0);
                  }
                },
                icon: userVote <= 0
                    ? const Icon(Icons.thumb_up_alt_outlined)
                    : const Icon(Icons.thumb_up_alt)),
            Text(documentVote.toString()),
            IconButton(
                onPressed: () {
                  if (userVote >= 0) {
                    setUserVote(-1);
                  } else {
                    setUserVote(0);
                  }
                },
                icon: userVote >= 0
                    ? const Icon(Icons.thumb_down_alt_outlined)
                    : const Icon(Icons.thumb_down_alt))
          ],
        ),
      ),
    );
  }
}

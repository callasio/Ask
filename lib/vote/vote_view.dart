import 'package:ask/main.dart';
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
  int? _otherUsersVote;
  int get documentVote => _otherUsersVote == null
      ? widget.post.vote
      : (_otherUsersVote! + userVote);

  void setUserVote(int to) {
    setState(() {
      userVote = to;
      widget.post.vote = documentVote;
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
          _otherUsersVote = widget.post.vote - userVote;
        }));
  }

  @override
  Widget build(BuildContext context) {
    const thumbSize = 15.0;
    const paddingThumbNumber = SizedBox(
      width: 10,
    );
    return FittedBox(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border:
                Border.all(color: Theme.of(context).dividerColor, width: 0.5)),
        child: Row(
          children: [
            InkWell(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(100),
                  bottomLeft: Radius.circular(100)),
              onTap: () {
                if (userVote <= 0) {
                  setUserVote(1);
                } else {
                  setUserVote(0);
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, top: 4.0, bottom: 4.0),
                child: Row(
                  children: [
                    Icon(
                      userVote <= 0 ? Icons.thumb_up_outlined : Icons.thumb_up,
                      color: userVote <= 0 ? null : MyApp.primaryColor,
                      size: thumbSize,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              documentVote.toString(),
              style: TextStyle(
                  fontWeight: userVote == 0 ? null : FontWeight.w700,
                  color: userVote == 0
                      ? null
                      : userVote > 0
                          ? MyApp.primaryColor
                          : MyApp.badColor),
            ),
            const SizedBox(
              width: 4,
            ),
            InkWell(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(100),
                  bottomRight: Radius.circular(100)),
              onTap: () {
                if (userVote >= 0) {
                  setUserVote(-1);
                } else {
                  setUserVote(0);
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.only(right: 8.0, top: 4.0, bottom: 4.0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 6,
                    ),
                    Icon(
                      userVote >= 0
                          ? Icons.thumb_down_outlined
                          : Icons.thumb_down,
                      color: userVote >= 0 ? null : MyApp.badColor,
                      size: thumbSize,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

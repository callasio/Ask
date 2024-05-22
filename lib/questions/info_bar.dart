import 'package:ask/questions/post.dart';
import 'package:ask/vote/vote_view.dart';
import 'package:flutter/material.dart';

class InfoBar extends StatelessWidget {
  final String documentId;
  final Post post;

  const InfoBar({super.key, required this.documentId, required this.post});

  @override
  Widget build(BuildContext context) {
    return VoteView(
      objectDocId: documentId,
      votable: post,
      collectionName: 'posts',
    );
  }
}

import 'package:ask/comments/comment_number.dart';
import 'package:ask/questions/post.dart';
import 'package:ask/vote/vote_view.dart';
import 'package:flutter/material.dart';

mixin MixinInfoBarParent {
  Function() get onTap;
}

class InfoBar extends StatelessWidget {
  final MixinInfoBarParent parent;
  final String documentId;
  final Post post;

  const InfoBar(
      {super.key,
      required this.documentId,
      required this.post,
      required this.parent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VoteView(
          objectDocId: documentId,
          votable: post,
          collectionName: 'posts',
        ),
        const SizedBox(
          width: 10,
        ),
        CommentNumber(post: post, parent: parent)
      ],
    );
  }
}

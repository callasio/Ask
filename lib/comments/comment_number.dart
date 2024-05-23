import 'package:ask/feed/info_bar.dart';
import 'package:flutter/material.dart';

import '../questions/post.dart';

class CommentNumber extends StatelessWidget {
  const CommentNumber({super.key, required this.parent, required this.post});

  final Post post;
  final MixinInfoBarParent parent;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Theme.of(context).dividerColor, width: 0.5),
        ),
        child: Row(
          children: [
            InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              onTap: parent.onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Icon(
                        Icons.mode_comment_outlined,
                        size: 15.0,
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      "${post.comment} comments",
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

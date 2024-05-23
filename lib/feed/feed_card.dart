import 'package:ask/feed/info_bar.dart';
import 'package:ask/questions/post.dart';
import 'package:ask/questions/question_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedCard extends StatefulWidget {
  FeedCard({super.key, required this.post, required this.documentId});

  final String documentId;
  final Post post;

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> with MixinInfoBarParent {
  late Post post;

  @override
  Function() get onTap => () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) =>
                    QuestionPage(documentId: widget.documentId, post: post)));
      };

  @override
  Widget build(BuildContext context) {
    post = widget.post;

    return Column(
      children: [
        InkWell(
          onTap: () => onTap(),
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
                const SizedBox(
                  height: 8,
                ),
                InfoBar(
                  documentId: widget.documentId,
                  post: post,
                  parent: this,
                )
              ],
            ),
          ),
        ),
        const Divider(
          height: 0,
          indent: 0,
          thickness: 1,
        )
      ],
    );
  }
}

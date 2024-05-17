import 'package:ask/questions/post.dart';
import 'package:flutter/material.dart';

class FeedCard extends StatefulWidget {
  const FeedCard({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  late Post post;

  @override
  Widget build(BuildContext context) {
    post = Post.fromJson(widget.data);
    var localTime = post.datetime.toLocal();

    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {}, child: Text(post.category.toString())),
              Text(
                  '${localTime.year}-${localTime.month}-${localTime.day} ${localTime.hour}:${localTime.minute}'),
              const Spacer(),
            ],
          ),
          Text(post.title),
          Text(post.body),
        ],
      ),
    ));
  }
}

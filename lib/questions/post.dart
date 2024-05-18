import 'package:ask/questions/categories.dart';
import 'package:timeago/timeago.dart' as timeago;

class Post {
  final String writer;
  final bool anonymous;
  final Category category;
  final DateTime datetime;
  final String title;
  final String body;
  final int vote;

  Post(
      {required this.writer,
      required this.anonymous,
      required this.category,
      required this.datetime,
      required this.title,
      required this.body,
      required this.vote});

  Map<String, dynamic> toJson() {
    return {
      "writer": writer,
      "category": category.toJson(),
      "anonymous": anonymous,
      "timestamp": datetime.toIso8601String(),
      "title": title,
      "body": body,
      "vote": vote,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        writer: json['writer'] as String,
        anonymous: json['anonymous'] as bool,
        category: Category.fromJson(json['category']),
        datetime: DateTime.parse(json['timestamp'] as String),
        title: json['title'] as String,
        body: json['body'] as String,
        vote: json['vote'] as int);
  }

  String displayTime() {
    return timeago.format(datetime.toLocal());
  }
}

import 'package:ask/questions/categories.dart';

class Post {
  final String writer;
  final bool anonymous;
  final Category category;
  final DateTime datetime;
  final String title;
  final String body;

  Post(
      {required this.writer,
      required this.anonymous,
      required this.category,
      required this.datetime,
      required this.title,
      required this.body});

  Map<String, dynamic> toJson() {
    return {
      "writer": writer,
      "category": category.toJson(),
      "anonymous": anonymous,
      "timestamp": datetime.toIso8601String(),
      "title": title,
      "body": body
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        writer: json['writer'] as String,
        anonymous: json['anonymous'] as bool,
        category: Category.fromJson(json['category']),
        datetime: DateTime.parse(json['timestamp'] as String),
        title: json['title'] as String,
        body: json['body'] as String);
  }
}

import 'package:ask/questions/categories.dart';
import 'package:ask/utils/timestamp.dart';
import 'package:ask/vote/votable.dart';

class Post with MixinVotable, MixinTimeStamp {
  final String writer;
  final String user;
  final bool anonymous;
  final Category category;
  final String title;
  final String body;
  @override
  DateTime datetime;
  @override
  int vote;

  Post(
      {required this.writer,
      required this.user,
      required this.anonymous,
      required this.category,
      required this.datetime,
      required this.title,
      required this.body,
      required this.vote});

  @override
  Map<String, dynamic> toJson() {
    return {
      "writer": writer,
      "user": user,
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
        user: json['user'] as String,
        anonymous: json['anonymous'] as bool,
        category: Category.fromJson(json['category']),
        datetime: DateTime.parse(json['timestamp'] as String),
        title: json['title'] as String,
        body: json['body'] as String,
        vote: json['vote'] as int);
  }
}

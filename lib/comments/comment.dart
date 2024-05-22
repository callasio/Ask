import 'package:ask/utils/timestamp.dart';
import 'package:ask/vote/votable.dart';

class Comment with MixinVotable, MixinTimeStamp {
  Comment(
      {required this.writer,
      required this.user,
      required this.anonymous,
      required this.datetime,
      required this.text,
      required this.vote,
      required this.document});

  final String writer;
  final String user;
  final bool anonymous;
  final String text;
  final String document;
  @override
  DateTime datetime;
  @override
  int vote;

  @override
  Map<String, dynamic> toJson() {
    return {
      "writer": writer,
      "anonymous": anonymous,
      'user': user,
      "timestamp": datetime.toIso8601String(),
      "text": text,
      "vote": vote,
      "document": document,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        writer: json['writer'] as String,
        user: json['user'] as String,
        anonymous: json['anonymous'] as bool,
        datetime: DateTime.parse(json['timestamp'] as String),
        text: json['text'] as String,
        vote: json['vote'] as int,
        document: json['document'] as String);
  }
}

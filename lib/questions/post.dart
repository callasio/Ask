class Post {
  final String writer;
  final bool anonymous;
  final String category;
  final String timestamp;
  final String title;
  final String body;

  Post(
      {required this.writer,
      required this.anonymous,
      required this.category,
      required this.timestamp,
      required this.title,
      required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        writer: json['writer'] as String,
        anonymous: json['anonymouse'] as bool,
        category: json['category'] as String,
        timestamp: json['timestamp'] as String,
        title: json['title'] as String,
        body: json['body'] as String);
  }
}

import 'package:ask/vote/votable.dart';

class Comment extends Votable {
  Comment({required this.vote});

  @override
  int vote;
}

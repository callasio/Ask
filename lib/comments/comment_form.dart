import 'package:ask/comments/comment.dart';
import 'package:ask/questions/post.dart';
import 'package:ask/utils/server_time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentForm extends StatelessWidget {
  final String documentId;
  final Post post;

  const CommentForm({super.key, required this.documentId, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) =>
                          CommentWriter(documentId: documentId, post: post)));
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                color: Theme.of(context).colorScheme.onSecondary,
                child: const Center(
                    child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("답변을 작성하세요"),
                )),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CommentWriter extends StatefulWidget {
  const CommentWriter(
      {super.key, required this.documentId, required this.post});

  final String documentId;
  final Post post;

  @override
  State<CommentWriter> createState() => _CommentWriterState();
}

class _CommentWriterState extends State<CommentWriter> {
  final TextEditingController textEditingController = TextEditingController();

  final String userId = FirebaseAuth.instance.currentUser!.uid;

  String get text => textEditingController.text;
  final firestore = FirebaseFirestore.instance;

  bool _canPost = false;
  bool _anonymous = false;
  bool _isLoading = false;
  void textUpdated(String _) {
    bool canPost = (text != '');

    if (canPost != _canPost) {
      setState(() {
        _canPost = canPost;
      });
    }
  }

  Future<void> updateCommentNumberServer() async {
    final querySnapshot = await firestore
        .collection('comments')
        .where('document', isEqualTo: widget.documentId)
        .get();

    final docs = querySnapshot.docs;
    int commentCnt = docs.length;
    debugPrint("comments: $commentCnt");
    await firestore
        .collection('posts')
        .doc(widget.documentId)
        .update({'comment': commentCnt});
  }

  Future<void> postComment() async {
    final username = FirebaseAuth.instance.currentUser!.email!;

    DateTime datetime = await ServerTime.getDateTime();

    var comment = Comment(
        writer: username,
        user: FirebaseAuth.instance.currentUser!.uid,
        anonymous: _anonymous,
        datetime: datetime,
        text: textEditingController.text,
        vote: 0,
        document: widget.documentId);

    setState(() {
      _isLoading = true;
    });

    await firestore.collection('comments').add(comment.toJson());
    await updateCommentNumberServer();

    textEditingController.text = '';

    setState(() {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(45.0),
            child: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onSecondary),
                    onPressed: _canPost
                        ? () {
                            postComment();
                          }
                        : null,
                    child: const Text(
                      '게시',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: TextFormField(
                      controller: textEditingController,
                      textInputAction: TextInputAction.newline,
                      maxLines: null,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: '여기에 답변을 작성하세요',
                          hintStyle: TextStyle(fontSize: 14.0)),
                      style: const TextStyle(fontSize: 14.0),
                      onChanged: textUpdated,
                    ),
                  ),
                ),
                SizedBox(
                  height: 36,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 24.0,
                        child: Transform.scale(
                          scale: 0.75,
                          child: Checkbox(
                            splashRadius: 0.0,
                            side: BorderSide(
                                color: Theme.of(context).disabledColor,
                                width: 1.5),
                            value: _anonymous,
                            onChanged: (value) => {
                              setState(() {
                                _anonymous = value!;
                              })
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '익명',
                        style: TextStyle(
                          color: _anonymous
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).disabledColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        if (_isLoading == true)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }
}

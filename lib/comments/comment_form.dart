import 'package:ask/questions/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommentForm extends StatefulWidget {
  const CommentForm(
      {super.key,
      required this.documentId,
      required this.post,
      required this.onSended});

  final String documentId;
  final Post post;
  final Function() onSended;

  @override
  State<CommentForm> createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  final TextEditingController _textEditingController = TextEditingController();

  final String userId = FirebaseAuth.instance.currentUser!.uid;

  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Expanded(
              child: TextFormField(
            controller: _textEditingController,
            onChanged: (_) {
              debugPrint("text: ${_textEditingController.text}");
              setState(() {});
            },
            decoration: const InputDecoration(hintText: '친절함을 베풀어보세요.'),
          )),
          IconButton(
              onPressed: _textEditingController.text == ''
                  ? null
                  : () {
                      firestore.collection('comments').add({
                        'user': userId,
                        'document': widget.documentId,
                        'text': _textEditingController.text
                      }).then((value) {
                        FocusScope.of(context).unfocus();
                        _textEditingController.text = '';
                      });
                    },
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}

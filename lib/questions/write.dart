import 'package:ask/questions/categories.dart';
import 'package:ask/questions/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WritePage extends StatefulWidget {
  const WritePage({super.key});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  bool _isPosted = false;

  bool _canPost = false;
  bool _anonymous = false;
  Category? _category;

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyTextController = TextEditingController();

  String get _title => titleController.text;
  String get _bodyText => bodyTextController.text;

  void textUpdated(String _) {
    bool canPost = (_title != '' && _bodyText != '' && _category != null);

    if (canPost != _canPost) {
      setState(() {
        _canPost = canPost;
      });
    }
  }

  Future<DateTime> getDateTime() async {
    DateTime dateTime;
    var document = await _firestore
        .collection('timestamps')
        .add({'createdAt': FieldValue.serverTimestamp()});

    var snapshot = await document.get();
    dateTime = (snapshot.data()!['createdAt'] as Timestamp).toDate();

    debugPrint(dateTime.toString());
    return dateTime;
  }

  Future<void> postQuestion() async {
    setState(() {
      _isLoading = true;
    });

    var username = FirebaseAuth.instance.currentUser!.email!;

    DateTime dateTime = await getDateTime();

    var post = Post(
        writer: username,
        anonymous: _anonymous,
        category: _category!,
        datetime: dateTime,
        title: _title,
        body: _bodyText);

    debugPrint(post.toString());

    await _firestore.collection('posts').add(post.toJson());

    setState(() {
      _isPosted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isPosted) {
      Navigator.pop(context);
    }

    return Stack(children: [
      Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(45.0),
          child: AppBar(
            scrolledUnderElevation: 0,
            leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: Navigator.of(context).pop),
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
                          postQuestion();
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
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: '제목',
                            hintStyle: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.w800)),
                        style: const TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.w800),
                        onChanged: textUpdated,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20.0)),
                                ),
                                context: context,
                                builder: (context) => ChooseCategory(
                                      onCategorySelected: (category) {
                                        setState(() {
                                          _category = category;
                                          textUpdated("");
                                        });
                                      },
                                    ));
                          },
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 40.0)),
                          child: Text(
                            _category == null
                                ? "카테고리를 선택하세요"
                                : "\"$_category\"에 질문",
                            style: const TextStyle(fontSize: 14.0),
                          )),
                      const Divider(),
                      TextFormField(
                        controller: bodyTextController,
                        textInputAction: TextInputAction.newline,
                        maxLines: null,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: '여기에 내용을 입력하세요.',
                            hintStyle: TextStyle(fontSize: 16.0)),
                        style: const TextStyle(fontSize: 16.0),
                        onChanged: textUpdated,
                      ),
                    ],
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
    ]);
  }
}

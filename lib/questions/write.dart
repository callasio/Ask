import 'package:ask/questions/categories.dart';
import 'package:flutter/material.dart';

class WritePage extends StatefulWidget {
  const WritePage({super.key});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  bool _canPost = false;
  bool _anonymous = false;
  Category? _category = null;

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyTextController = TextEditingController();

  void textUpdated(String _) {
    String title = titleController.text;
    String bodyText = bodyTextController.text;

    bool canPost = title != '' && bodyText != '';

    if (canPost != _canPost) {
      setState(() {
        _canPost = canPost;
      });
    }
  }

  void postQuestion() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                onPressed: _canPost ? postQuestion : null,
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
                              fontSize: 18.0, fontWeight: FontWeight.w800)),
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w800),
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
                                    onCategorySelected: (Category category) {
                                      _category = category;
                                    },
                                  ));
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 40.0)),
                        child: const Text(
                          '카테고리를 선택하세요.',
                          style: TextStyle(fontSize: 12.0),
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
                          hintStyle: TextStyle(fontSize: 14.0)),
                      style: const TextStyle(fontSize: 14.0),
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
                    child: Checkbox(
                      splashRadius: 0.0,
                      value: _anonymous,
                      onChanged: (value) => {
                        setState(() {
                          _anonymous = value!;
                        })
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '익명',
                    style: TextStyle(
                      color: _anonymous
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).toggleButtonsTheme.borderColor,
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
    );
  }
}

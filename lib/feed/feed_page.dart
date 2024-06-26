import 'package:ask/feed/feed_card.dart';
import 'package:ask/profile/in_drawer.dart';
import 'package:ask/questions/categories.dart';
import 'package:ask/questions/post.dart';
import 'package:ask/questions/write.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key, this.categoryFilter});

  final Category? categoryFilter;

  @override
  State<FeedPage> createState() => _FeedPageState();
}

enum _LoadingState { done, loading }

class _FeedPageState extends State<FeedPage> {
  Key _refreshKey = UniqueKey();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String get username => FirebaseAuth.instance.currentUser!.email!;

  _LoadingState _loadingState = _LoadingState.loading;
  late QuerySnapshot<Map<String, dynamic>> _snapshot;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get _posts =>
      _snapshot.docs;

  bool get isRoot => widget.categoryFilter == null;

  Future<void> loadPosts() async {
    if (isRoot) {
      _snapshot = await _firestore
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .get();
    } else {
      _snapshot = await widget.categoryFilter!
          .query(_firestore.collection('posts'))
          .orderBy('timestamp', descending: true)
          .get();
    }
    _refreshKey = UniqueKey();
    setState(() {
      _loadingState = _LoadingState.done;
    });
  }

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _refreshKey,
      appBar: AppBar(
        leading: isRoot
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: Navigator.of(context).pop,
              ),
        scrolledUnderElevation: 0,
        title: widget.categoryFilter != null
            ? Text('"${widget.categoryFilter.toString()}"의 질문')
            : const Text('Ask'),
        backgroundColor: widget.categoryFilter?.getColor(context).withAlpha(50),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => ChooseCategory(
                        categoryMessageSuffix: ' 질문 보기',
                        onCategorySelected: (category) {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => FeedPage(
                                    categoryFilter: category,
                                  )));
                        }));
              },
              icon: const Icon(Icons.search)),
          const SizedBox(
            width: 6,
          )
        ],
      ),
      drawer: isRoot ? const ProfileDrawer() : null,
      body: RefreshIndicator(onRefresh: loadPosts, child: mainView()),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        heroTag: 'write-page',
        onPressed: () {
          Navigator.of(context).push(
              CupertinoPageRoute(builder: (context) => const WritePage()));
        },
        label: const Text(
          '질문하기',
        ),
        icon: const Icon(
          Icons.edit_outlined,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
    );
  }

  Widget mainView() {
    if (_loadingState == _LoadingState.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_posts.isEmpty) {
      return const Center(
        child: Text('Wow, such empty'),
      );
    }

    return ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return FeedCard(
              documentId: post.id, post: Post.fromJson(post.data()));
        });
  }
}

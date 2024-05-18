import 'package:ask/feed/feed_card.dart';
import 'package:ask/questions/post.dart';
import 'package:ask/questions/write.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

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

  Future<void> loadPosts() async {
    _snapshot = await _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .get();
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
        scrolledUnderElevation: 0,
        title: const Text('Ask'),
      ),
      drawer: const Drawer(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      body: RefreshIndicator(onRefresh: loadPosts, child: mainView()),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'write-page',
            onPressed: () {
              Navigator.of(context).push(
                  CupertinoPageRoute(builder: (context) => const WritePage()));
            },
            tooltip: '질문 작성하기',
            child: const Icon(Icons.post_add),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: "logout",
            onPressed: FirebaseAuth.instance.signOut,
            tooltip: '로그아웃',
            child: const Icon(Icons.logout),
          ),
        ],
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

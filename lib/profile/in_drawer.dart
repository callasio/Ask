import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: FloatingActionButton(
          heroTag: "logout",
          onPressed: FirebaseAuth.instance.signOut,
          tooltip: '로그아웃',
          child: const Icon(Icons.logout),
        ),
      ),
    );
  }
}

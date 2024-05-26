import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("환영합니다, ${FirebaseAuth.instance.currentUser!.email}"),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton.extended(
            heroTag: "logout",
            onPressed: FirebaseAuth.instance.signOut,
            tooltip: '로그아웃',
            icon: const Icon(Icons.logout),
            label: const Text("로그아웃"),
          ),
        ],
      ),
    );
  }
}

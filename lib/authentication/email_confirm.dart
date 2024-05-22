import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailConfirm extends StatefulWidget {
  const EmailConfirm({super.key});

  @override
  State<EmailConfirm> createState() => _EmailConfirmState();
}

class _EmailConfirmState extends State<EmailConfirm> {
  User get _user => FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('메일 ${_user.email}에서 인증 절차를 확인하세요.'),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                _user.sendEmailVerification();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('인증 메일을 다시 보냈습니다. 수신함을 확인하세요.')),
                );
              },
              child: const Text('인증 메일 다시 발송하기')),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        heroTag: "logout",
        onPressed: FirebaseAuth.instance.signOut,
        tooltip: '로그아웃',
        child: const Icon(Icons.logout),
      ),
    );
  }
}

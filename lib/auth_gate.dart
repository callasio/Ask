import 'package:ask/authentication/email_confirm.dart';
import 'package:ask/feed/feed_page.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';

import 'authentication/sign_in.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SignInPage();
          }

          return FirebaseAuth.instance.currentUser!.emailVerified
              ? const FeedPage()
              : const EmailConfirm();
        });
  }
}

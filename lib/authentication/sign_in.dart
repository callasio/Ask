import 'package:ask/authentication/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'form.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailFormController = TextEditingController();
  final passwordFormController = TextEditingController();

  bool _invalidCredentials = false;

  void _signInWithEmailAndPassword(String emailId, String password) async {
    if (emailId == '' || password == '') {
      setState(() {
        _invalidCredentials = true;
      });
      return;
    }
    try {
      await _auth.signInWithEmailAndPassword(
          email: "$emailId@kaist.ac.kr", password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        setState(() {
          _invalidCredentials = true;
        });
      } else {
        rethrow;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const SizedBox(
                height: 135,
              ),
              Padding(
                padding: const EdgeInsets.all(60.0),
                child: Image.asset(
                  'assets/images/icon.png',
                  width: 270,
                ),
              ),
              const SizedBox(
                height: 44,
              ),
              EmailForm(controller: emailFormController),
              const SizedBox(height: 16.05),
              PasswordForm(
                controller: passwordFormController,
                isConfirm: false,
              ),
              const SizedBox(
                height: 6,
              ),
              if (_invalidCredentials)
                const Text(
                  "Email or Password are wrong.",
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(
                height: 14,
              ),
              FilledButton(
                onPressed: () {
                  _signInWithEmailAndPassword(
                      emailFormController.text, passwordFormController.text);
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                    minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 67.0)),
                    fixedSize: MaterialStateProperty.all(
                        const Size(double.infinity, 67.0))),
                child: const Text('Sign In',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const SignUpPage()));
                },
                child: Text(
                  "New to Ask? Click here to sign up",
                  style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

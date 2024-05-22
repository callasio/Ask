import 'package:ask/authentication/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'form.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailFormController = TextEditingController();
  final passwordFormController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  bool _isPasswordIncorrect = false;

  void _signUpWithEmailAndPassword(String emailId, String password) async {
    if (password != passwordConfirmController.text) {
      _isPasswordIncorrect = true;
      setState(() {});
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
          email: "$emailId@kaist.ac.kr", password: password);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred')),
      );
      return;
    }

    Navigator.pop(context);
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
              const SizedBox(height: 16.05),
              PasswordForm(
                controller: passwordConfirmController,
                isConfirm: true,
              ),
              const SizedBox(
                height: 6,
              ),
              if (_isPasswordIncorrect)
                const Text(
                  "Check your password again.",
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(
                height: 14,
              ),
              FilledButton(
                onPressed: () {
                  _signUpWithEmailAndPassword(
                      emailFormController.text, passwordFormController.text);
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                    minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 67.0)),
                    fixedSize: MaterialStateProperty.all(
                        const Size(double.infinity, 67.0))),
                child: const Text('Sign Up',
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
                          builder: (context) => const SignInPage()));
                },
                child: Text(
                  "Already have account? Sign in!",
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

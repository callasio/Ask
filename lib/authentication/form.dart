import 'package:flutter/material.dart';

class _FormStyles {
  static const borderRadius = BorderRadius.all(Radius.circular(10.0));

  static const InputBorder enabledBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: Color(0XFFC0C0C0), width: 3.0));

  static const InputBorder focusedBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: Color(0XFF3498DB), width: 3.0));
}

class EmailForm extends StatelessWidget {
  final TextEditingController controller;

  const EmailForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: TextFormField(
            restorationId: 'email_field',
            textInputAction: TextInputAction.next,
            textAlign: TextAlign.center,
            controller: controller,
            style: const TextStyle(fontSize: 18),
            decoration: const InputDecoration(
                enabledBorder: _FormStyles.enabledBorder,
                focusedBorder: _FormStyles.focusedBorder,
                hintText: 'Email',
                hintStyle: TextStyle(fontSize: 18, color: Color(0XFFC0C0C0))),
            maxLines: 1,
          ),
        ),
        const Expanded(flex: 1, child: Icon(Icons.alternate_email)),
        const Expanded(
            flex: 5,
            child: Text(
              'kaist.ac.kr',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ))
      ],
    );
  }
}

class PasswordForm extends StatefulWidget {
  final TextEditingController controller;

  const PasswordForm({super.key, required this.controller});

  @override
  State<StatefulWidget> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      restorationId: 'password_field',
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.center,
      controller: widget.controller,
      style: const TextStyle(fontSize: 18),
      obscureText: _isHidden,
      decoration: InputDecoration(
        enabledBorder: _FormStyles.enabledBorder,
        focusedBorder: _FormStyles.focusedBorder,
        hintText: 'Password',
        hintStyle: const TextStyle(fontSize: 18, color: Color(0XFFC0C0C0)),
        suffixIcon: GestureDetector(
          onTap: _togglePasswordView,
          child: Icon(_isHidden
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}

import 'package:chatapp/features/auth/view/login_page.dart';
import 'package:chatapp/features/auth/view/sign_up_page.dart';
import 'package:flutter/material.dart';

class LoginOrSignup extends StatefulWidget {
  const LoginOrSignup({super.key});

  @override
  State<LoginOrSignup> createState() => _LoginOrSignupState();
}

class _LoginOrSignupState extends State<LoginOrSignup> {
  bool isLoginPage = false;

  void togglePage() {
    setState(() {
      isLoginPage = !isLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoginPage) {
      return SignUpPage(
        onPressed: () {
          togglePage();
        },
      );
    } else {
      return LoginPage(
        onPressed: () {
          togglePage();
        },
      );
    }
  }
}

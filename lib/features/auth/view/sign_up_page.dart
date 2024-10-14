import 'package:chatapp/core/widgets/input_feild.dart';
import 'package:chatapp/features/auth/view_model/auth_provider.dart';
import 'package:chatapp/features/chat/view_model/chat_service.dart';
import 'package:chatapp/features/chat/widgets/snacbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback onPressed;
  const SignUpPage({
    super.key,
    required this.onPressed,
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formkey = GlobalKey<FormState>();
  AuthProvider? authProvider;
  ChatProvider? chatProvider;
  @override
  void initState() {
    super.initState();

    authProvider = Provider.of<AuthProvider>(context, listen: false);
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
  }

  TextEditingController numberController = TextEditingController();
  TextEditingController passwordrController = TextEditingController();

  void signUp() async {
    final res = await authProvider?.signU(
        numberController.text, passwordrController.text);

    numberController.clear();
    passwordrController.clear();
    if (res != null) {
      showSnac(res);
    }
  }

  void showSnac(String res) {
    showSnackbar(res);
  }

  @override
  void dispose() {
    numberController.dispose();
    passwordrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 300),
                  Center(
                    child: Text(
                      'Enter phone number',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 20),
                  InputFeild(
                      hintText: 'Enter phone number',
                      controller: numberController),
                  const SizedBox(height: 20),
                  InputFeild(
                      hintText: 'Enter password',
                      controller: passwordrController),
                  const SizedBox(height: 20),
                  TextButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          signUp();
                        }
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(fontSize: 20),
                      )),

                  // Listen for changes in the AuthService
                  // Consumer<AuthProvider>(
                  //   builder: (context, authService, child) {
                  //     if (authService.isVerified) {
                  //       // Navigate to AllChatPage when verified
                  //       WidgetsBinding.instance.addPostFrameCallback((_) {
                  //         Navigator.pushReplacement(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => const MainPage(),
                  //           ),
                  //         );
                  //       });
                  //     }
                  //     return Container(); // Empty container just for listening
                  //   },
                  // ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have account?'),
                      TextButton(
                        onPressed: widget.onPressed,
                        child: const Text('Login'),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

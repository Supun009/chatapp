import 'package:chatapp/core/widgets/input_feild.dart';
import 'package:chatapp/core/widgets/loader.dart';
import 'package:chatapp/features/auth/view_model/auth_provider.dart';
import 'package:chatapp/features/chat/view_model/chat_service.dart';
import 'package:chatapp/features/chat/widgets/snacbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onPressed;
  const LoginPage({
    super.key,
    required this.onPressed,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  void login() async {
    final res = await authProvider?.verifyNumber(
        numberController.text, passwordrController.text);
    chatProvider?.userConnect(numberController.text);
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
        body: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (authProvider.isLoading) {
              return const Loader();
            }
            return SingleChildScrollView(
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
                              login();
                            }
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 20),
                          )),

                      // Listen for changes in the AuthService

                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Dont have account?'),
                          TextButton(
                            onPressed: widget.onPressed,
                            child: const Text('Sign up'),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

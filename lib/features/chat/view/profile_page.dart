import 'package:chatapp/features/auth/view_model/auth_provider.dart';
import 'package:chatapp/features/chat/view_model/chat_service.dart';
import 'package:chatapp/theme/apppallet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthProvider? authProvider;
  ChatProvider? chathProvider;

  String? phoneNumber;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    chathProvider = Provider.of<ChatProvider>(context, listen: false);
    phoneNumber = authProvider?.phoneNumber;
  }

  void logOut() {
    authProvider?.removeUser();
    chathProvider?.userDisconnect();
    chathProvider?.clearChats();
    chathProvider?.clearUserList();
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (context) => LoginPage(
    //       onPressed: () {},
    //     ),
    //   ),
    // );
  }

  void logOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure to logout?'),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("logout"),
              onPressed: () {
                Navigator.of(context).pop();
                logOut();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: AppPallete.greyColor,
                  borderRadius: BorderRadius.circular(10)),
              height: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey.shade400),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    phoneNumber != null
                        ? Text(
                            phoneNumber!,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Text(''),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                logOutDialog(context);
              },
              child: const Row(
                children: [
                  Text(
                    'Log out',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

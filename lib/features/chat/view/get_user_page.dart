import 'package:chatapp/core/local_repo/db_helper.dart';
import 'package:chatapp/core/widgets/input_feild.dart';
import 'package:chatapp/features/chat/view/user_chat_page.dart.dart';
import 'package:chatapp/features/chat/view_model/chat_service.dart';
import 'package:chatapp/features/chat/widgets/snacbar.dart';
import 'package:chatapp/features/chat/widgets/user_tile.dart';
import 'package:chatapp/theme/apppallet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetUserPage extends StatefulWidget {
  const GetUserPage({super.key});

  @override
  State<GetUserPage> createState() => _GetUserPageState();
}

class _GetUserPageState extends State<GetUserPage> {
  final dbHelper = DatabaseHelper();
  final formkey = GlobalKey<FormState>();
  final TextEditingController userContoller = TextEditingController();

  String? uid;

  @override
  void initState() {
    super.initState();
    context.read<ChatProvider>().clearUid();
  }

  @override
  void dispose() {
    userContoller.dispose();
    super.dispose();
  }

  void chatWithUser() {
    if (uid != null && uid != 'error') {
      saveuserLocal();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserChatPage(user: uid!),
          ));
    }
  }

  void saveuserLocal() async {
    context.read<ChatProvider>().saveUser(uid!);
  }

  void showSnac(String res) {
    showSnackbar(res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Find user'),
          centerTitle: true,
        ),
        body: Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<ChatProvider>(
                    builder: (context, chatProvider, child) {
                      uid = chatProvider.uid;
                      if (uid == null) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: chatProvider.usersList.length,
                            itemBuilder: (context, index) {
                              return UserTile(
                                  onLongPress: () {},
                                  userid:
                                      chatProvider.usersList[index].phoneNumber,
                                  color: Colors.grey.shade700,
                                  isRead: true,
                                  onTap: chatWithUser);
                            },
                          ),
                        );
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: UserTile(
                              onLongPress: () {},
                              userid: uid!,
                              color: AppPallete.greyColor,
                              isRead: true,
                              onTap: chatWithUser,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: InputFeild(
                              hintText: 'Enter phone number',
                              controller: userContoller)),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        onPressed: () {
                          // Only send the message if it's not empty
                          if (formkey.currentState!.validate()) {
                            Provider.of<ChatProvider>(context, listen: false)
                                .getUser(userContoller.text);
                            userContoller.clear();
                          }
                        },
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}

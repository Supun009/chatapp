import 'package:chatapp/core/model/user.dart';
import 'package:chatapp/features/chat/view/get_user_page.dart';
import 'package:chatapp/features/chat/view/user_chat_page.dart.dart';
import 'package:chatapp/features/chat/view_model/chat_service.dart';
import 'package:chatapp/features/chat/widgets/user_tile.dart';
import 'package:chatapp/theme/apppallet.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AllChatPage extends StatefulWidget {
  const AllChatPage({super.key});

  @override
  State<AllChatPage> createState() => _AllChatPageState();
}

class _AllChatPageState extends State<AllChatPage> {
  List<String> selectedUsers = [];
  bool longPressEnabled = false;
  bool newMesage = false;

  void deleteSelectedChats() {
    List<String> usersToDelete = List.from(selectedUsers);
    Provider.of<ChatProvider>(context, listen: false)
        .clearMultipleChatAndUsers(usersToDelete);
    selectedUsers.clear();
    longPressEnabled = false;
  }

  void toggleSelection(String phoneNumber) {
    setState(() {
      if (selectedUsers.contains(phoneNumber)) {
        if (selectedUsers.length == 1) {
          selectedUsers.remove(phoneNumber);
          longPressEnabled = false;
          return;
        }
        selectedUsers.remove(phoneNumber); // Deselect if already selected
      } else {
        selectedUsers.add(phoneNumber); // Select if not selected
      }
    });
  }

  void selectAllchats() {
    setState(() {
      if (selectedUsers.isEmpty) {
        List<User> userList =
            Provider.of<ChatProvider>(context, listen: false).usersList;
        for (var user in userList) {
          selectedUsers.add(user.phoneNumber);
          longPressEnabled = true;
        }
      } else {
        selectedUsers.clear();
        longPressEnabled = false;
      }
    });
  }

  void deleteDialog(BuildContext context) {
    if (selectedUsers.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete selected chats?'),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("Delete"),
                onPressed: () {
                  setState(() {
                    deleteSelectedChats();
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.check),
          onPressed: selectAllchats,
        ),
        actions: [
          // IconButton(
          //     onPressed: () => Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => const SettingsPage(),
          //         )),
          //     icon: const Icon(Icons.settings))
          IconButton(
              onPressed: selectedUsers.isEmpty
                  ? null
                  : () {
                      deleteDialog(context);
                    },
              icon: const Icon(Icons.delete))
        ],
        title: const Text('Chats'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey.shade500,
          onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GetUserPage()),
              ),
          child: const Icon(Icons.message)),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Consumer<ChatProvider>(
          builder: (context, viewModel, child) {
            final List<User> users = viewModel.usersList;
            // final List<Message> messageList = viewModel.chatList;

            return Column(
              children: [
                users.isEmpty
                    ? const SizedBox.shrink() // Show nothing if users is null
                    : Expanded(
                        child: ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];

                            // return Slidable(
                            // endActionPane: ActionPane(
                            //     motion: const StretchMotion(),
                            //     children: [
                            //       SlidableAction(
                            //         onPressed: (context) =>
                            //             deleteChat(context, user.phoneNumber),
                            //         icon: Icons.delete,
                            //         backgroundColor: Colors.grey.shade600,
                            //         borderRadius: BorderRadius.circular(10),
                            //       )
                            //     ]),
                            // child:

                            return UserTile(
                              onLongPress: () {
                                if (!longPressEnabled) {
                                  toggleSelection(user.phoneNumber);
                                  setState(() {
                                    longPressEnabled = true;
                                  });
                                }
                              },
                              userid: user.phoneNumber,
                              isRead: user.isRead,
                              color: selectedUsers.contains(user.phoneNumber)
                                  ? Colors.blue.shade400
                                  : AppPallete.greyColor,
                              onTap: () {
                                if (!longPressEnabled) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserChatPage(
                                              user: user.phoneNumber,
                                            )),
                                  );
                                } else {
                                  toggleSelection(user.phoneNumber);
                                }
                              },
                            );
                          },
                        ),
                      )
              ],
            );
          },
        ),
      ),
    );
  }
}

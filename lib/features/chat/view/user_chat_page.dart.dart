import 'package:chatapp/core/local_repo/shared_pref.dart';
import 'package:chatapp/features/chat/view_model/chat_service.dart';
import 'package:chatapp/features/chat/widgets/chat_bubbl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserChatPage extends StatefulWidget {
  final String user;

  const UserChatPage({
    super.key,
    required this.user,
  });

  @override
  State<UserChatPage> createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage> {
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  FocusNode messageFocusNode = FocusNode();
  final bool isChatpage = true;

  final GlobalKey _rowKey = GlobalKey();
  double inputFieldHeight = 0;
  ChatProvider? chatProvider;

  @override
  void initState() {
    super.initState();
    chatProvider = Provider.of<ChatProvider>(context, listen: false);

    chatProvider?.checkChatpage(widget.user);
    chatProvider?.updateIsReadMessage(widget.user);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
          _rowKey.currentContext?.findRenderObject() as RenderBox;
      setState(() {
        inputFieldHeight = renderBox.size.height;
      });
      scrollToBottom();
    });

    messageFocusNode.addListener(() {
      if (messageFocusNode.hasFocus) {
        if (isNearBottom()) {
          Future.delayed(const Duration(milliseconds: 300), () {
            onFocusNode();
          });
        }
      }
    });

    context.read<ChatProvider>().addListener(onNewMessage);
  }

  bool isNearBottom() {
    if (!scrollController.hasClients) return false;

    // Check if the current scroll position is near the bottom (allowing a small offset)
    double threshold = 100.0; // You can adjust this threshold as needed
    return scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - threshold;
  }

  void onFocusNode() {
    if (!isNearBottom()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + inputFieldHeight,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void scrollToBottom() {
    if (!isNearBottom()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(
            scrollController.position.maxScrollExtent + inputFieldHeight,
          );
        }
      });
    }
  }

  void onNewMessage() {
    if (isNearBottom()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + inputFieldHeight,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void sendMessage() {
    if (isNearBottom()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + inputFieldHeight,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    chatProvider?.checkChatpage(null);

    scrollController.dispose();
    messageController.dispose();
    messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserUid = context.read<SharedPrefService>().uid;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Chat with ${widget.user}')),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Expanded(
                child: Consumer<ChatProvider>(
                  builder: (context, chatProvider, child) {
                    // Filter chats for the specific user
                    final userChats = chatProvider.chatList
                        .where((chat) =>
                            (chat.sender == currentUserUid &&
                                chat.receiver == widget.user) ||
                            (chat.sender == widget.user &&
                                chat.receiver == currentUserUid))
                        .toList();

                    return ListView.builder(
                      controller: scrollController,
                      itemCount: userChats.length,
                      itemBuilder: (context, index) {
                        final chat = userChats[index];
                        final isSender = chat.sender ==
                            currentUserUid!; // Check if the message is sent by the user

                        return ChatBubbl(
                          isSender: isSender,
                          chat: chat,
                          isDeleverd: userChats[index].isDeleverd,
                          isRead: userChats[index].isRead,
                        );
                      },
                    );
                  },
                ),
              ),
              Row(
                key: _rowKey,
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: messageFocusNode,
                      controller: messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type your message',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    onPressed: () {
                      // Only send the message if it's not empty
                      if (messageController.text.isNotEmpty) {
                        Provider.of<ChatProvider>(context, listen: false)
                            .addChat(messageController.text, currentUserUid!,
                                widget.user);
                        sendMessage();
                        messageController.clear();
                      }
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

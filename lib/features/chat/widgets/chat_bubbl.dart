import 'package:chatapp/core/model/message.dart';
import 'package:flutter/material.dart';

class ChatBubbl extends StatelessWidget {
  final bool isSender;
  final Message chat;
  final int? isDeleverd;
  final int? isRead;
  const ChatBubbl({
    super.key,
    required this.isSender,
    required this.chat,
    required this.isDeleverd,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isSender
          ? const EdgeInsets.only(left: 30.0)
          : const EdgeInsets.only(right: 30.0),
      child: Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSender ? Colors.grey.shade600 : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment:
                isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                chat.message,
                style: TextStyle(
                  color: isSender ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      chat.getFormattedTime(),
                      style: TextStyle(
                        color: isSender ? Colors.white70 : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 10),
                    isSender
                        ? Row(
                            children: [
                              isDeleverd == 1
                                  ? Icon(
                                      Icons.check,
                                      size: 20.00,
                                      color: isRead == 1
                                          ? Colors.blue.shade900
                                          : Colors.grey.shade100,
                                    )
                                  : const Icon(Icons.timelapse, size: 15.00),
                              isRead == 1
                                  ? Icon(
                                      Icons.check,
                                      size: 20.00,
                                      color: Colors.blue.shade900,
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          )
                        : const SizedBox.shrink()
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}

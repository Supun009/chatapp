import 'dart:convert';
import 'package:chatapp/core/model/message.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatSocketService {
  io.Socket? socket;

  void initializeSocket() {
    socket = io.io('https://parttimejobs.web.lk', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket?.connect();
  }

  void userConnect(String uid) {
    socket?.emit('authenticate', uid);
  }

  void sendMessage(Message message) {
    socket?.emit('message', jsonEncode(message.toMap()));
  }

  void sendDeleverRepotAfterOffline(Message message) {
    socket?.emit('deleverd', jsonEncode(message.toMap()));
  }

  void readReport(Message chatMessage) {
    socket?.emit(
        'read',
        jsonEncode({
          'id': chatMessage.id,
          'isRead': chatMessage.isRead,
          'sender': chatMessage.sender,
          'receiver': chatMessage.receiver
        }));
  }

  void disconnect() {
    socket?.disconnect();
  }
}

import 'dart:convert';
import 'package:chatapp/core/connection/connection_checker.dart';
import 'package:chatapp/core/model/message.dart';
import 'package:chatapp/core/widgets/env.dart';
import 'package:http/http.dart' as http;

class ChatRepo {
  final connectionChecker = Connectionchecker();

  Future<List<Message>> notDeleverdChatList(String phoneNumber) async {
    try {
      final res = await http.post(Uri.parse('$baseUrl/chatlist'),
          body: jsonEncode({'uid': phoneNumber}),
          headers: {'Content-Type': 'application/json'});

      if (res.statusCode == 200) {
        final chatList = jsonDecode(res.body) as List;
        final List<Message> list = [];
        for (var message in chatList) {
          list.add(Message.fromMap(message));
        }
        return list;
      }
      throw Exception(
          'Failed to load chat list. Status Code: ${res.statusCode}');
    } catch (e) {
      return [];
    }
  }
}

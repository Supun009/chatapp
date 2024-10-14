import 'dart:async';
import 'dart:convert';
import 'package:chatapp/core/connection/connection_checker.dart';
import 'package:chatapp/core/local_repo/db_helper.dart';
import 'package:chatapp/core/local_repo/shared_pref.dart';
import 'package:chatapp/core/model/message.dart';
import 'package:chatapp/core/model/user.dart';
import 'package:chatapp/features/chat/chat_repo/chat_repo.dart';
import 'package:chatapp/features/chat/chat_repo/chat_socket.dart';
import 'package:chatapp/features/chat/chat_repo/get_user_repo.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class ChatProvider with ChangeNotifier {
  final connectionChecker = Connectionchecker();
  late StreamSubscription<bool> connectionSubscription;
  final void Function(String) showSnackbarCallback;
  final ChatSocketService _chatSocketService = ChatSocketService();
  var uuid = const Uuid();
  final ChatRepo _chatRepo = ChatRepo();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final GetUserRepo _getUserRepo = GetUserRepo();
  List<Message> _chatList = [];
  List<User> usersList = [];
  List<Message> unReaMessageList = [];

  List<Message> get chatList => _chatList;

  bool _isChatapage = false;
  String? _chatpageUSer;

  String? uid;

  final logger = Logger();

  // Add an encryption key and initialization vector (IV)
  final _encryptionKey =
      encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');
  // final _iv = encrypt.IV.fromLength(16);

  // Encryption function
  String encryptMessage(String message) {
    final iv = encrypt.IV.fromSecureRandom(16); // Generate a random IV
    final encrypter = encrypt.Encrypter(
        encrypt.AES(_encryptionKey, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(message, iv: iv);

    // Combine IV and encrypted message, separated by a colon
    return '${iv.base64}:${encrypted.base64}';
  }

  // Decryption function
  String decryptMessage(String encryptedMessageWithIv) {
    // Split the IV and encrypted message
    final parts = encryptedMessageWithIv.split(':');
    if (parts.length != 2) {
      throw ArgumentError('Invalid encrypted message format');
    }

    final iv = encrypt.IV.fromBase64(parts[0]);
    final encryptedMessage = parts[1];

    final encrypter = encrypt.Encrypter(
        encrypt.AES(_encryptionKey, mode: encrypt.AESMode.cbc));
    final decrypted = encrypter.decrypt64(encryptedMessage, iv: iv);
    return decrypted;
  }

  ChatProvider({required this.showSnackbarCallback}) {
    _chatSocketService.initializeSocket();

    _chatSocketService.socket?.on('message', (data) async {
      Map<String, dynamic> data1 = jsonDecode(data);

      final chatMessage = Message.fromMap(data1);

      String message = decryptMessage(chatMessage.message);

      // _chatSocketService.deleverReport(chatMessage);

      saveUser(chatMessage.sender);

      await _dbHelper.insertChatFromReceive(
          chatMessage.id, message, chatMessage.sender, chatMessage.receiver, 1);

      _chatList.add(chatMessage.copyWith(isDeleverd: 1, message: message));

      notifyListeners();
      if (_isChatapage && _chatpageUSer == chatMessage.sender) {
        updateIsReadMessage(chatMessage.sender);
      }
    });

    _chatSocketService.socket?.on(
      'deleverd',
      (data) async {
        Map<String, dynamic> data1 = jsonDecode(data);

        final chat = _chatList.firstWhere(
          (chat) => chat.id == data1['id'],
        );

        chat.isDeleverd = 1;

        await _dbHelper.markMessagesAsDeleverd(data1['receiver']);
        notifyListeners();
      },
    );

    _chatSocketService.socket?.on('read', (data) async {
      try {
        Map<String, dynamic> data1 = jsonDecode(data);

        final Message chat = _chatList.firstWhere(
          (chat) => chat.id == data1['id'] && chat.isRead == 0,
        );

        chat.isRead = 1;

        // await _dbHelper.markMessagesAsRead(data1['id']);
        notifyListeners();
        updateIsReadMessage(data1['receiver']);
      } catch (e) {
        logger.e(e.toString());
      }
    });

    loadChats();
    fetchUsersWithUnreadMessages();

    connectionSubscription =
        connectionChecker.onConnectionChange.listen((isConnected) {
      if (isConnected) {
        userConnect(null);
      } else {
        showSnackbarCallback('No internet connection');
      }
    });
  }

  void userConnect(String? phoneNumber) async {
    if (phoneNumber == null) {
      String? uid = SharedPrefService().uid;
      if (uid != null) {
        _chatSocketService.userConnect(uid);
        loadNotDeleverdChats(uid);
      }
    } else {
      _chatSocketService.initializeSocket();
      _chatSocketService.userConnect(phoneNumber);
      loadNotDeleverdChats(phoneNumber);
    }
  }

  void userDisconnect() {
    _chatSocketService.disconnect();
  }

  void checkChatpage(String? chatPageuser) {
    _chatpageUSer = chatPageuser;
    _isChatapage = !_isChatapage;
  }

  // Load chats from SQLite
  Future<void> loadChats() async {
    final List<Map<String, dynamic>> chats = await _dbHelper.getChats();
    if (chats.isNotEmpty) {
      _chatList = chats.map((chat) => Message.fromMap(chat)).toList();

      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  Future<void> fetchUsersWithUnreadMessages() async {
    // usersList.clear();
    // print('load user');
    List<Map<String, dynamic>> users = await _dbHelper.getUsers();
    List<User> list = [];
    for (var userMap in users) {
      User user = User.fromMap(userMap);

      list.add(user);
    }

    for (var user in list) {
      int unreadCount = await _dbHelper.getUnreadMessageCount(user.phoneNumber);
      if (unreadCount >= 1) {
        user.isRead = false;
      } else {
        user.isRead = true;
      }
      usersList.add(user);
    }
    notifyListeners();
  }

  Future<void> updateIsReadMessage(String phoneNumber) async {
    try {
      await _dbHelper.markMessagesReadRecipt(phoneNumber);
      await _dbHelper.markMessagesAsRead(phoneNumber);

      final user =
          usersList.firstWhere((user) => user.phoneNumber == phoneNumber);

      user.isRead = true;

      for (var chat in _chatList) {
        if (chat.sender == phoneNumber && chat.isRead == 0) {
          chat.isRead = 1;
          _chatSocketService.readReport(chat);
        }
      }

      notifyListeners();
    } catch (e) {
      throw ("User not found: $phoneNumber");
    }
  }

  Future<void> updateMessageReadRecipt(String phoneNumber) async {
    await _dbHelper.markMessagesReadRecipt(phoneNumber);

    try {
      final user =
          usersList.firstWhere((user) => user.phoneNumber == phoneNumber);

      user.isRead = true;

      for (var chat in _chatList) {
        if (chat.sender == phoneNumber && chat.isRead == 0) {
          chat.isRead = 1;
          _chatSocketService.readReport(chat);
        }
      }

      notifyListeners();
    } catch (e) {
      throw ("User not found: $phoneNumber");
    }
  }

  void loadNotDeleverdChats(String phoneNumber) async {
    if (!await connectionChecker.isConnected) {
      showSnackbarCallback('No internet connection');
      return;
    }
    List<Message> notDeliveredMessages =
        await _chatRepo.notDeleverdChatList(phoneNumber);

    if (notDeliveredMessages.isNotEmpty) {
      for (var chat in notDeliveredMessages) {
        String deCryptChat = decryptMessage(chat.message);

        chatList.add(chat.copyWith(message: deCryptChat));
        _chatSocketService.sendDeleverRepotAfterOffline(chat);
        notifyListeners();
        await _dbHelper.insertChatFromReceive(
            chat.id,
            deCryptChat, // Message content
            chat.sender, // Sender
            chat.receiver,
            1);
      }

      List<String> users = getUniqueUsers();

      for (var user in users) {
        saveUser(user);
      }
    }
  }

  // Add a new chat
  Future<void> addChat(String message, String sender, String reciver) async {
    String uniqueId = uuid.v4();
    final encryptedMessage = encryptMessage(message);
    try {
      final chatMessage = Message(
        id: uniqueId,
        message: encryptedMessage,
        sender: sender,
        receiver: reciver,
        timestamp: DateTime.now(),
        isRead: 0,
      );

      await _dbHelper.insertChatFromsend(
          uniqueId, message, chatMessage.sender, chatMessage.receiver, 0, 0);

      _chatList.add(chatMessage.copyWith(message: message));

      _chatSocketService.sendMessage(chatMessage);
      notifyListeners();
    } catch (e) {
      throw ('this is an error---${e.toString()}');
    }
  }

  // Get all unique users
  List<String> getUniqueUsers() {
    final users = _chatList.map((chat) => chat.sender).toSet().toList();
    return users;
  }

  // Clear all chats
  Future<void> clearAllChats() async {
    await _dbHelper.clearChats();
    _chatList.clear();
    clearUserList();
    notifyListeners();
  }

  Future<void> clearChats() async {
    await _dbHelper.clearChats();
    _chatList.clear();
    notifyListeners();
  }

  // Future<void> clearOneChats(String phoneNumber) async {
  //   await _dbHelper.deleteOneChat(phoneNumber);
  //   await _dbHelper.clearChatMessages(phoneNumber);
  //   usersList.removeWhere((user) => user.phoneNumber == phoneNumber);
  //   _chatList.removeWhere(
  //       (chat) => (chat.sender == phoneNumber || chat.receiver == phoneNumber));

  //   notifyListeners();
  // }

  Future<void> clearMultipleChatAndUsers(List<String> phoneNumbers) async {
    await _dbHelper.deleteChats(phoneNumbers);
    await _dbHelper.deleteUsers(phoneNumbers);
    for (var phoneNumber in phoneNumbers) {
      usersList.removeWhere((user) => user.phoneNumber == phoneNumber);
      _chatList.removeWhere((chat) =>
          (chat.sender == phoneNumber || chat.receiver == phoneNumber));
    }
    notifyListeners();
  }

  Future<void> clearUserList() async {
    await _dbHelper.clearUsers();
    usersList.clear();
    notifyListeners();
  }

//migrated from getsuerViewModel-------------------

  Future<void> getUser(String phoneNumber) async {
    uid = await _getUserRepo.getUser(phoneNumber);
    notifyListeners();
  }

  void saveUser(String phoneNumber) async {
    if (usersList.isNotEmpty) {
      bool uidExists = usersList.any((user) => user.phoneNumber == phoneNumber);
      if (!uidExists) {
        usersList.add(User(id: '', phoneNumber: phoneNumber, isRead: false));
        await _dbHelper.insertUser(phoneNumber);
        notifyListeners();
        return;
      } else if (_isChatapage) {
        final user =
            usersList.firstWhere((user) => user.phoneNumber == phoneNumber);
        user.isRead = true;
      } else {
        final user =
            usersList.firstWhere((user) => user.phoneNumber == phoneNumber);
        user.isRead = false;
      }
    } else {
      usersList.add(User(id: '', phoneNumber: phoneNumber, isRead: false));
      await _dbHelper.insertUser(phoneNumber);
      notifyListeners();
    }
  }

  void clearUid() {
    uid = null;
  }

  void loadChatUsers() async {
    List<Map<String, dynamic>> users = await _dbHelper.getUsers();
    for (var userMap in users) {
      User user = User.fromMap(userMap);
      usersList.add(user);
    }
    notifyListeners();
  }
}

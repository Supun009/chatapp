// import 'package:chatapp/core/local_repo/db_helper.dart';
// import 'package:chatapp/core/model/user.dart';
// import 'package:chatapp/features/chat/chat_repo/get_user_repo.dart';
// import 'package:flutter/material.dart';

// class GetUserViewModel extends ChangeNotifier {
//   final GetUserRepo _getUserRepo = GetUserRepo();
//   final dbHelper = DatabaseHelper();
//   List<User> usersList = [];

//   GetUserViewModel() {
//     loadChatUsers(); // Load users when the view model is initialized
//   }

//   String? uid;

//   Future<void> getUser(String phoneNumber) async {
//     uid = await _getUserRepo.getUser(phoneNumber);
//     print(uid);
//     notifyListeners();
//   }

//   void saveUser(String phoneNumber) async {
//     if (usersList.isNotEmpty) {
//       bool uidExists = usersList.any((user) => user.phoneNumber == phoneNumber);
//       if (!uidExists) {
//         usersList.add(User(id: '', phoneNumber: phoneNumber));
//         notifyListeners();
//         return;
//       }
//     } else {
//       usersList.add(User(id: '', phoneNumber: phoneNumber));
//       notifyListeners();
//     }

//     await dbHelper.insertUser(phoneNumber);
//     notifyListeners();
//   }

//   void clearUid() {
//     uid = null;
//   }

//   void loadChatUsers() async {
//     List<Map<String, dynamic>> users = await dbHelper.getUsers();
//     for (var userMap in users) {
//       User user = User.fromMap(userMap);
//       usersList.add(user);
//     }
//     print(users);
//     notifyListeners();
//   }
// }

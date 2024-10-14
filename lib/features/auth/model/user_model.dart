import 'package:chatapp/core/model/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.phoneNumber,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }
}

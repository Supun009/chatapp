class User {
  final String id;
  final String phoneNumber;
  bool isRead;

  User({
    required this.id,
    required this.phoneNumber,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'phoneNumber': phoneNumber,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }

  User copyWith({String? id, String? phoneNumber}) {
    return User(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}

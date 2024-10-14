import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'chat.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE chats (
        id TEXT PRIMARY KEY,
        message TEXT,
        sender TEXT,
        receiver TEXT,
        timestamp TEXT,
        isRead INTEGER DEFAULT 0,
        isDeleverd INTEGER
      )
    ''');

    // Create users table
    await db.execute('''
      CREATE TABLE users (
        phoneNumber TEXT PRIMARY KEY
      )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE users (
          uid TEXT PRIMARY KEY
        )
      ''');
    }
  }

  // Insert a chat message
  Future<void> insertChatFromsend(String id, String message, String sender,
      String receiver, int isRead, int isDeleverd) async {
    final db = await database;
    await db.insert(
      'chats',
      {
        'id': id,
        'message': message,
        'sender': sender,
        'receiver': receiver,
        'timestamp': DateTime.now().toIso8601String(),
        'isRead': isRead,
        'isDeleverd': isDeleverd
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Insert a chat message
  Future<void> insertChatFromReceive(String id, String message, String sender,
      String receiver, int isDeleverd) async {
    final db = await database;
    await db.insert(
      'chats',
      {
        'id': id,
        'message': message,
        'sender': sender,
        'receiver': receiver,
        'timestamp': DateTime.now().toIso8601String(),
        'isDeleverd': isDeleverd
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all chat messages
  Future<List<Map<String, dynamic>>> getChats() async {
    final db = await database;
    return await db.query('chats');
  }

  Future<int> getUnreadMessageCount(String userId) async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) FROM chats WHERE sender = ? AND isRead = 0', [userId]);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> markMessagesAsRead(String senderID) async {
    try {
      final db = await database;

      await db.update(
        'chats',
        {'isRead': 1},
        where: 'sender = ? AND isRead = 0',
        whereArgs: [senderID],
      );
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<void> markMessagesReadRecipt(String receiverID) async {
    try {
      final db = await database;

      await db.update(
        'chats',
        {'isRead': 1},
        where: 'receiver = ? AND isRead = 0',
        whereArgs: [receiverID],
      );
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<void> markMessagesAsDeleverd(String reveiverId) async {
    final db = await database;

    await db.update(
      'chats',
      {'isDeleverd': 1},
      where: 'receiver = ? AND isDeleverd = 0',
      whereArgs: [reveiverId],
    );
  }

  // Clear all chats
  Future<void> clearChats() async {
    final db = await database;
    await db.delete('chats');
  }

  // Future<void> deleteOneChat(String phoneNumber) async {
  //   final db = await database;
  //   await db.delete(
  //     'users',
  //     where: 'phoneNumber = ?',
  //     whereArgs: [phoneNumber],
  //   );
  // }

  Future<void> clearChatMessages(String phoneNumberr) async {
    final db = await database;
    await db.delete(
      'chats',
      where: 'sender = ? OR receiver = ?',
      whereArgs: [
        phoneNumberr,
        phoneNumberr,
      ], // This handles both directions
    );
  }

  // Method to delete multiple users by phone numbers
  Future<void> deleteUsers(List<String> phoneNumbers) async {
    final db = await database;
    final batch = db.batch();
    for (String phoneNumber in phoneNumbers) {
      batch.delete('users', where: 'phoneNumber = ?', whereArgs: [phoneNumber]);
    }
    await batch.commit(noResult: true);
  }

  // Method to delete chat messages for multiple users
  Future<void> deleteChats(List<String> phoneNumbers) async {
    final db = await database;
    final batch = db.batch();
    for (String phoneNumber in phoneNumbers) {
      batch.delete('chats',
          where: 'sender = ? OR receiver = ?',
          whereArgs: [phoneNumber, phoneNumber]);
    }
    await batch.commit(noResult: true);
  }

  // Insert a user
  Future<void> insertUser(String phoneNumber) async {
    final db = await database;
    await db.insert(
      'users',
      {
        'phoneNumber': phoneNumber,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all users
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  // Clear all users
  Future<void> clearUsers() async {
    final db = await database;
    await db.delete('users');
  }
}

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class Connectionchecker {
  // Create a private constructor
  Connectionchecker._internal();

  // Single instance of Connectionchecker
  static final Connectionchecker _instance = Connectionchecker._internal();

  // Factory constructor to return the same instance
  factory Connectionchecker() {
    return _instance;
  }

  // InternetConnection instance
  final InternetConnection internetConnection = InternetConnection();

  // Method to check internet connectivity
  Future<bool> get isConnected async =>
      await internetConnection.hasInternetAccess;

  // Stream to listen for connection changes
  Stream<bool> get onConnectionChange => internetConnection.onStatusChange.map(
        (status) => status == InternetStatus.connected,
      );
}

import 'package:chatapp/main.dart';
import 'package:flutter/material.dart';

void showSnackbar(String message) {
  // Use the ScaffoldMessenger to show a Snackbar
  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
      duration: const Duration(seconds: 3), // Duration the Snackbar is shown
      backgroundColor:
          Colors.grey.shade300, // Optional: Change background color
    ),
  );
}

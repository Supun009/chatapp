import 'package:flutter/material.dart';

class InputFeild extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  const InputFeild({
    super.key,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return '$hintText is missing ';
        }
        return null;
      },
    );
  }
}

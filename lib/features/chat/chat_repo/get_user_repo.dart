import 'dart:convert';
import 'package:chatapp/core/widgets/env.dart';
import 'package:http/http.dart' as http;

class GetUserRepo {
  Future<String> getUser(String phoneNumber) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/getuser'),
        body: jsonEncode({
          'phoneNumber': phoneNumber.toString(),
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final resBody = jsonDecode(res.body) as Map<String, dynamic>;

      if (res.statusCode == 200) {
        return resBody['phoneNumber'].toString();
      }
      return resBody['msg'];
    } catch (e) {
      return 'error';
    }
  }
}

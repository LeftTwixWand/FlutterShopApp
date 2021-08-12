import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class AuthorizationProvider with ChangeNotifier {
  String _token = '';
  DateTime _expiryDate = DateTime.now();
  String _userId = '';

  Future<void> signUp(String email, String password) async {
    final url = Uri.parse(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyCQ_2mJUvdnTCQXxBieZ5Lm-cPEJpS0wIs');

    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );

    print(json.decode(response.body));
  }
}

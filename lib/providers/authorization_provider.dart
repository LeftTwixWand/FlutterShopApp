import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class AuthorizationProvider with ChangeNotifier {
  String _token = '';
  DateTime _expiryDate = DateTime.now();
  String _userId = '';

  Future<void> _authorize(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyCQ_2mJUvdnTCQXxBieZ5Lm-cPEJpS0wIs');

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

    print(response.body);
  }

  Future<void> signUp(String email, String password) async =>
      _authorize(email, password, 'signupNewUser');

  Future<void> logIn(String email, String password) async =>
      _authorize(email, password, 'verifyPassword');
}

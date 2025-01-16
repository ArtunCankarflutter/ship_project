import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';


class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  void login(String email, String password) {
    if (email == 'user@gmail.com' && password == 'password') {
      _isAuthenticated = true;
      notifyListeners();
    }
    else if (email == 'darksiderv@gmail.com' && password == 'blue'){
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
  Future<void> login2(String email, String password) async {
  final url = Uri.parse("http://localhost/loginflutter.php");
  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"email": email, "password": password}),
    );

    final data = json.decode(response.body);
    if (data['status'] == "success") {
      _isAuthenticated = true;
      notifyListeners();
    } else {
      throw Exception(data['message']);
    }
  } catch (e) {
    log("Login error: $e");
  }
}

}


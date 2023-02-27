// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;

  bool get isAuth {
    return _token != null;
  }

  String? get token {
    return _token;
  }

  Future<void> register({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('url/api/user/register/');

    try {
      final resposne = await http.post(url, headers: {}, body: {
        'name': name,
        'email': email,
        'password': password,
      });

      final responseData = json.decode(resposne.body);
      print(resposne.statusCode);

      if (resposne.statusCode == 201) {
        _token = responseData['token'];
        notifyListeners();
        print(_token);

        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({'token': _token});
        prefs.setString('userData', userData);
      } else {
        print(responseData['error']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> login(
      {required BuildContext context,
      required String name,
      required String password}) async {
    final url = Uri.parse('url/auth-token/');

    try {
      final resposne = await http.post(url, body: {
        'name': name,
        'password': password,
      });

      final responseData = json.decode(resposne.body);
      if (resposne.statusCode == 200) {
        _token = responseData['token'];
        notifyListeners();
        print(_token);
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({'token': _token});
        prefs.setString('userData', userData);
      } else {
        print(responseData['error']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData') && token != null) {
      return false;
    }
    final extractedData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    _token = extractedData['token'];
    notifyListeners();
    return true;
  }

  Future<void> logout(BuildContext context) async {
    final url = Uri.parse('url/api/user/logout/');
    try {
      final response = await http.post(url, headers: {
        'Authorization': 'token $token',
      });
      if (response.statusCode == 200) {
        _token = null;
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        prefs.clear();
      } else {}
    } catch (e) {
      rethrow;
    }
  }
}

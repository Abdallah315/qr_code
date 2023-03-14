// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_qr_code/presentation/widgets/app_popup.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _accessToken;
  String? _refreshToken;
  final String _userType = 'student';

  bool get isAuth {
    return _accessToken != null;
  }

  String? get accessToken {
    return _accessToken;
  }

  String? get refreshToken {
    return _refreshToken;
  }

  String? get userType {
    return _userType;
  }

  Future<void> register(
      {required String name,
      required String email,
      required int studentId,
      required String userType,
      required String password,
      required String rePassword,
      required BuildContext context}) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/auth/users/');

    try {
      final resposne = await http.post(url,
          headers: {
            "Connection": "keep-alive",
            'Content-Type': 'application/json;charset=UTF-8',
            'Charset': 'utf-8'
          },
          body: jsonEncode({
            'first_name': name,
            'username': name,
            'email': email,
            'student_id': studentId,
            'user_type': userType,
            'password': password,
            're_password': rePassword,
          }));

      print('${resposne.statusCode} response body');
      final responseData = json.decode(resposne.body);

      if (resposne.statusCode == 201) {
        Fluttertoast.showToast(
            msg: "Activation accessToken has been sent to your email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        AppPopup.showMyDialog(context, responseData.toString());
        print('$responseData err');
      }
    } catch (e) {
      AppPopup.showMyDialog(context, e.toString());
      print('$e  e');
    }
  }

  Future<void> login({required String email, required String password}) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/auth/jwt/create/');

    try {
      final resposne = await http.post(url,
          headers: {
            "Connection": "keep-alive",
            'Content-Type': 'application/json;charset=UTF-8',
            'Charset': 'utf-8'
          },
          body: jsonEncode({
            'email': email,
            'password': password,
          }));

      final responseData = json.decode(resposne.body);
      if (resposne.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Login success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        // get userType;
        _accessToken = responseData['access'];
        _refreshToken = responseData['refresh'];
        notifyListeners();
        print(_accessToken);
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
            {'accessToken': _accessToken, 'refreshToken': _refreshToken});
        prefs.setString('userData', userData);
      } else {
        print(responseData);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData') && accessToken != null) {
      return false;
    }
    final extractedData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    _accessToken = extractedData['accessToken'];
    notifyListeners();
    return true;
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData') && accessToken != null) {
      return "";
    }
    final extractedData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    _accessToken = extractedData['accessToken'];
    notifyListeners();
    return extractedData['accessToken'];
  }

  Future<void> logout(BuildContext context) async {
    final url = Uri.parse('url/api/user/logout/');
    try {
      final response = await http.post(url, headers: {
        // 'Authorization': 'accessToken $accessToken',
        'connection': 'keep-alive'
      });
      if (response.statusCode == 200) {
        _accessToken = null;
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        prefs.clear();
      } else {}
    } catch (e) {
      rethrow;
    }
  }
}

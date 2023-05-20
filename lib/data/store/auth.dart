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
  String? _userType;

  bool get isAuth {
    return _accessToken != null;
  }

  // String? get accessToken {
  //   return _accessToken;
  // }

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
    final url = Uri.parse('http://134.122.64.234/api/v1/register/');

    try {
      final resposne = await http.post(url,
          headers: {
            "Connection": "keep-alive",
            'Content-Type': 'application/json',
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

      final responseData = json.decode(resposne.body);

      if (resposne.statusCode == 201) {
        Fluttertoast.showToast(
            msg: "Activation email has been sent",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        print('$responseData err');
        AppPopup.showMyDialog(context, json.decode(resposne.body)['detail']);
      }
    } catch (e) {
      AppPopup.showMyDialog(context, e.toString());
      print('$e  e');
    }
  }

  Future<void> login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    final url = Uri.parse('http://134.122.64.234/users/auth/jwt/token/');

    try {
      final resposne = await http.post(
        url,
        headers: {
          "Connection": "keep-alive",
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'email': email,
            'password': password,
          },
        ),
      );

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
        _userType = responseData['type'];

        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'accessToken': _accessToken,
          'refreshToken': _refreshToken,
          'userType': _userType
        });
        prefs.setString('userData', userData);
      } else {
        AppPopup.showMyDialog(context, json.decode(resposne.body)['detail']);
      }
    } catch (e) {
      AppPopup.showMyDialog(context, json.decode(e.toString())['detail']);
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData') && _accessToken != null) {
      return false;
    }
    final extractedData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    _accessToken = extractedData['accessToken'];
    _userType = extractedData['userType'];
    notifyListeners();
    return true;
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData') && _accessToken != null) {
      return "";
    }
    final extractedData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    _accessToken = extractedData['accessToken'];
    notifyListeners();
    return extractedData['accessToken'];
  }

  Future<bool> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    _refreshToken = extractedData['refreshToken'];
    try {
      final resposne = await http.post(
          Uri.parse('http://134.122.64.234/api/auth/jwt/refresh/'),
          headers: {
            "Connection": "keep-alive",
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'refresh': _refreshToken,
          }));

      final responseData = json.decode(resposne.body);
      print('${resposne.statusCode} refresh succeeded');
      if (resposne.statusCode == 200) {
        // get userType;
        _accessToken = responseData['access'];
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
            {'accessToken': _accessToken, 'refreshToken': _refreshToken});
        prefs.setString('tokenData', userData);
      } else {
        _accessToken = null;
        _refreshToken = null;
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        prefs.clear();
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
    return true;
  }

  Future<void> logout(BuildContext context) async {
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}

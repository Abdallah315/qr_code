import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../presentation/widgets/app_popup.dart';

class UserStore with ChangeNotifier {
  Map<String, dynamic> _user = {};

  Map<String, dynamic> get user {
    return _user;
  }

  Future<void> getUser(BuildContext context, String token) async {
    try {
      Response response = await get(
          Uri.parse(
            'http://134.122.64.234/api/v1/students-profiles/student_profile/student_profile/',
          ),
          headers: {
            "Connection": "keep-alive",
            'Content-Type': 'application/json;charset=UTF-8',
            'Charset': 'utf-8',
            'Authorization': 'JWT $token'
          });
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _user = responseData['Student'];
      } else {
        AppPopup.showMyDialog(context, json.decode(response.body)['detail']);
      }
    } catch (e) {
      print('$e from getting all lectures');
    }
  }
}

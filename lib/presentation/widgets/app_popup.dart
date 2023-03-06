import 'package:flutter/material.dart';

class AppPopup {

  static showMyDialog(BuildContext context, String? message) async {
    print('msg: $message');
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message ?? 'Something went wrong, Please try again later'),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}

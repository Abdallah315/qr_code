import 'package:flutter/material.dart';
import 'package:flutter_qr_code/utils/constants.dart';

class CreateQrCodeScreen extends StatefulWidget {
  static const routeName = '/create-qr';
  const CreateQrCodeScreen({super.key});

  @override
  State<CreateQrCodeScreen> createState() => _CreateQrCodeScreenState();
}

class _CreateQrCodeScreenState extends State<CreateQrCodeScreen> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff161E4C),
        title: const Text('Code To scan'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: getWidth(context),
        height: getHeight(context),
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          Image.network(
            'http://134.122.64.234${args['imagePath']}',
            width: getWidth(context) * .85,
            height: getHeight(context) * .6,
            headers: const {
              "Connection": "keep-alive",
              'Content-Type': 'application/json;charset=UTF-8',
              'Charset': 'utf-8',
              // 'Authorization': 'JWT $token'
            },
          ),
        ]),
      ),
    );
  }
}

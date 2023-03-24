import 'package:flutter/material.dart';
import 'package:flutter_qr_code/utils/constants.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withAlpha(150),
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: getWidth(context) * 0.8,
            maxHeight: getHeight(context) * 0.8,
            minWidth: getWidth(context) * 0.5,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(height: 10),
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../utils/colors.dart';
import '../../../utils/constants.dart';

class NotificationsScreen extends StatefulWidget {
  static const routeName = '/notification';
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: getWidth(context),
        height: getHeight(context),
        color: MyColors.myWhite,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: getHeight(context) * .06,
              ),
              Container(
                width: getWidth(context),
                height: getHeight(context) * 0.94,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(29),
                    topLeft: Radius.circular(29),
                  ),
                  color: MyColors.myDarkPurple,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: getHeight(context) * .05,
                      ),
                      Container(
                        width: getWidth(context) * .85,
                        height: getHeight(context) * .85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: MyColors.myWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

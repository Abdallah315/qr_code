import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_code/data/store/auth.dart';
import 'package:flutter_qr_code/data/store/user_store.dart';
import 'package:flutter_qr_code/presentation/screens/student/scan_qr_code_screen.dart';
import 'package:flutter_qr_code/presentation/screens/student/student_reports_screen.dart';
import 'package:flutter_qr_code/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../../utils/colors.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<Auth>(context, listen: false).refreshToken().whenComplete(() {
      initialStep();
    });
  }

  initialStep() async {
    final token = await Provider.of<Auth>(context, listen: false).getToken();
    Provider.of<UserStore>(context, listen: false)
        .getUser(context, token)
        .then((value) {
      FirebaseMessaging.instance.getToken().then((fcm) {
        Provider.of<UserStore>(context, listen: false).sendFcmToken(
            context,
            fcm!,
            Provider.of<UserStore>(context, listen: false).user['username'],
            token);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: getWidth(context),
        height: getHeight(context),
        color: MyColors.myWhite,
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: getHeight(context) * .06,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: InkWell(
                onTap: () {
                  Provider.of<Auth>(context, listen: false).logout(context);
                },
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/logout.png',
                      color: MyColors.myDarkPurple,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Logout',
                      style: TextStyle(
                          color: MyColors.myDarkPurple,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: getHeight(context) * .02,
            ),
            Container(
              width: getWidth(context),
              height: getHeight(context) * .9,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(29),
                  topLeft: Radius.circular(29),
                ),
                color: MyColors.myDarkPurple,
              ),
              child: SingleChildScrollView(
                child: Column(children: [
                  SizedBox(
                    height: getHeight(context) * .08,
                  ),
                  GestureDetector(
                      onTap: () =>
                          Navigator.of(context).pushNamed(ScanScreen.routeName),
                      child: Image.asset('assets/images/scanner.jpeg')),
                  SizedBox(
                    height: getHeight(context) * 0.09,
                  ),
                  GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushNamed(StudentReportsScreen.routeName),
                      child: Image.asset('assets/images/reports.jpeg')),
                ]),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

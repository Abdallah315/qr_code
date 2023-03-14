import 'package:flutter/material.dart';
import 'package:flutter_qr_code/presentation/screens/student/scan_qr_code_screen.dart';
import 'package:flutter_qr_code/presentation/screens/student/student_reports_screen.dart';
import 'package:flutter_qr_code/utils/constants.dart';

import '../../../utils/colors.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: getWidth(context),
        height: getHeight(context),
        color: MyColors.myWhite,
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: getHeight(context) * .1,
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

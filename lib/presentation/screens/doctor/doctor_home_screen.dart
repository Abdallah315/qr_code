import 'package:flutter/material.dart';
import 'package:flutter_qr_code/data/store/auth.dart';
import 'package:flutter_qr_code/presentation/screens/doctor/doctor_courses_screen.dart';
import 'package:flutter_qr_code/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../../utils/colors.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  @override
  void initState() {
    Provider.of<Auth>(context, listen: false)
        .getToken()
        .then((value) => print(value));
    super.initState();
  }

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
                    height: getHeight(context) * .05,
                  ),
                  GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushNamed(DoctorCoursesScreen.routeName),
                      child: Image.asset('assets/images/create qr.jpeg')),
                  SizedBox(
                    height: getHeight(context) * 0.04,
                  ),
                  GestureDetector(
                      onTap: () {},
                      child: Image.asset('assets/images/reports.jpeg')),
                  SizedBox(
                    height: getHeight(context) * 0.04,
                  ),
                  GestureDetector(
                      onTap: () {},
                      child: Image.asset('assets/images/notify students.jpeg')),
                ]),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

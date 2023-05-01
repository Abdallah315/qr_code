import 'package:flutter/material.dart';
import 'package:flutter_qr_code/data/store/course_store.dart';
import 'package:flutter_qr_code/data/store/user_store.dart';
import 'package:flutter_qr_code/presentation/screens/doctor/create_qr_screen.dart';
import 'package:flutter_qr_code/presentation/screens/doctor/doctor_courses_screen.dart';
import 'package:flutter_qr_code/presentation/screens/doctor/doctor_home_screen.dart';
import 'package:flutter_qr_code/presentation/screens/loading_screen.dart';
import 'package:flutter_qr_code/presentation/screens/student/scan_qr_code_screen.dart';
import 'package:flutter_qr_code/presentation/screens/student/student_home_screen.dart';
import 'package:flutter_qr_code/presentation/screens/student/student_reports_screen.dart';
import 'package:provider/provider.dart';

import 'data/store/auth.dart';
import 'presentation/screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProvider(
            create: (context) => CourseStore(),
          ),
          ChangeNotifierProvider(
            create: (context) => UserStore(),
          )
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: Builder(
              builder: (context) {
                if (auth.isAuth) {
                  if (auth.userType == 'doctor') {
                    return const DoctorHomeScreen();
                  } else {
                    return const StudentHomeScreen();
                  }
                } else {
                  return FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? const LoadingScreen()
                            : const AuthScreen(),
                  );
                }
              },
            ),
            routes: {
              StudentReportsScreen.routeName: (context) =>
                  const StudentReportsScreen(),
              ScanScreen.routeName: (context) => const ScanScreen(),
              DoctorCoursesScreen.routeName: (context) =>
                  const DoctorCoursesScreen(),
              CreateQrCodeScreen.routeName: (context) =>
                  const CreateQrCodeScreen(),
            },
          ),
        ));
  }
}

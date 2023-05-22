import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_code/data/store/course_store.dart';
import 'package:flutter_qr_code/data/store/user_store.dart';
import 'package:flutter_qr_code/presentation/screens/doctor/create_qr_screen.dart';
import 'package:flutter_qr_code/presentation/screens/doctor/doctor_courses_screen.dart';
import 'package:flutter_qr_code/presentation/screens/doctor/doctor_home_screen.dart';
import 'package:flutter_qr_code/presentation/screens/doctor/doctor_notification_screen.dart';
import 'package:flutter_qr_code/presentation/screens/doctor/doctor_reports_screen.dart';
import 'package:flutter_qr_code/presentation/screens/loading_screen.dart';
import 'package:flutter_qr_code/presentation/screens/student/notifications_screen.dart';
import 'package:flutter_qr_code/presentation/screens/student/scan_qr_code_screen.dart';
import 'package:flutter_qr_code/presentation/screens/student/student_home_screen.dart';
import 'package:flutter_qr_code/presentation/screens/student/student_reports_screen.dart';
import 'package:provider/provider.dart';

import 'data/store/auth.dart';
import 'firebase_options.dart';
import 'presentation/screens/auth_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  print('User granted permission: ${settings.authorizationStatus}');

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
                  auth.tryAutoLogin();
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
              DoctorReportsScreen.routeName: (context) =>
                  const DoctorReportsScreen(),
              DoctorNotificationScreen.routeName: (context) =>
                  const DoctorNotificationScreen(),
              NotificationsScreen.routeName: (context) =>
                  const NotificationsScreen()
            },
          ),
        ));
  }
}

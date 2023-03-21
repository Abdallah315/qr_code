import 'package:flutter/material.dart';
import 'package:flutter_qr_code/data/store/auth.dart';
import 'package:flutter_qr_code/data/store/course_store.dart';
import 'package:flutter_qr_code/presentation/screens/doctor/create_qr_screen.dart';
import 'package:flutter_qr_code/utils/constants.dart';
import 'package:provider/provider.dart';

class DoctorCoursesScreen extends StatefulWidget {
  static const routeName = '/doctor-courses';
  const DoctorCoursesScreen({super.key});

  @override
  State<DoctorCoursesScreen> createState() => _DoctorCoursesScreenState();
}

class _DoctorCoursesScreenState extends State<DoctorCoursesScreen> {
  bool isLoading = false;
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    Provider.of<Auth>(context, listen: false).getToken().then((token) {
      Provider.of<CourseStore>(context, listen: false)
          .getAllCourses(context, token)
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff161E4C),
        title: const Text('Choose The Course'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: getWidth(context),
        height: getHeight(context),
        child: Consumer<CourseStore>(builder: (context, courseStore, child) {
          return isLoading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(
                              CreateQrCodeScreen.routeName,
                              arguments: {
                                'course': courseStore.allCourses[index]
                              }),
                          child: Container(
                            width: getWidth(context) * .8,
                            height: getHeight(context) * .1,
                            color: const Color.fromARGB(255, 237, 241, 248),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Course Code: ${courseStore.allCourses[index].title}',
                                  style: const TextStyle(
                                      color: Color(0xff5D6A7A),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  'Course Name: ${courseStore.allCourses[index].description}',
                                  style: const TextStyle(
                                      color: Color(0xff5D6A7A),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        )
                      ],
                    );
                  },
                  itemCount: courseStore.allCourses.length,
                );
        }),
      ),
    );
  }
}

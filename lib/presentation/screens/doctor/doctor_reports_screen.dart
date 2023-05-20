// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_qr_code/data/models/all_courses.dart';
import 'package:flutter_qr_code/data/store/auth.dart';
import 'package:flutter_qr_code/data/store/course_store.dart';
import 'package:flutter_qr_code/utils/colors.dart';
import 'package:flutter_qr_code/utils/constants.dart';
import 'package:provider/provider.dart';

import '../loading_screen.dart';

class DoctorReportsScreen extends StatefulWidget {
  static const routeName = '/doctor-report';
  const DoctorReportsScreen({super.key});

  @override
  State<DoctorReportsScreen> createState() => _DoctorReportsScreenState();
}

class _DoctorReportsScreenState extends State<DoctorReportsScreen> {
  bool _isLoading = false;
  String dropdownvalue = '';
  var items;
  String? courseId;
  List<AllCourses>? course;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _isLoading = true;
    Provider.of<Auth>(context, listen: false).getToken().then((token) {
      Provider.of<CourseStore>(context, listen: false)
          .getAllCourses(context, token)
          .then((value) {
        items = Provider.of<CourseStore>(context, listen: false)
            .allCourses
            .map((item) => item.description)
            .toList();
        print(items);
        if (items.length == 0) {
          dropdownvalue = 'no courses';
          items = ['no courses'];
        } else {
          dropdownvalue = items.first;
          course = Provider.of<CourseStore>(context, listen: false).allCourses;
          courseId = course?.first.id;
        }
        setState(() {
          _isLoading = false;
        });
      });
      // Provider.of<CourseStore>(context, listen: false)
      //     .getStudentCourses(context, token)
      //     .then((value) {
      //   // items = Provider.of<CourseStore>(context, listen: false).studentCourses.map((item) => item.courseInfo!.title).toList();
      //   items = Provider.of<CourseStore>(context, listen: false)
      //       .studentCourses
      //       .map((item) => item.courseInfo!.description)
      //       .toList();
      //   if (items.length == 0) {
      //     dropdownvalue = 'no courses';
      //     items = ['no courses'];
      //   } else {
      //     dropdownvalue = items.first;
      //     course =
      //         Provider.of<CourseStore>(context, listen: false).studentCourses;
      //   }
      //   Provider.of<UserStore>(context, listen: false).getUser(context, token);
      // });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Row(children: [
          Container(
            width: getWidth(context) * .2,
            height: getHeight(context),
            color: const Color(0xff161E4C),
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Image.asset('assets/images/book.jpeg'),
              ],
            ),
          ),
          Container(
            width: getWidth(context) * .8,
            height: getHeight(context),
            padding: const EdgeInsets.only(left: 15),
            child: _isLoading
                ? const Center(
                    child: LoadingScreen(),
                  )
                : ListView(
                    children: [
                      SizedBox(
                        height: getHeight(context) * .05,
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Reports Card',
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: getHeight(context) * .05,
                      ),
                      Container(
                        width: getWidth(context) * .7,
                        height: getHeight(context) * .23,
                        color: const Color.fromARGB(255, 237, 241, 248),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Student Name: ',
                                  style: TextStyle(
                                      color: Color(0xff5D6A7A),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: getWidth(context) * .35,
                                  height: 20,
                                  child: TextField(
                                    onChanged: (value) => setState(() {}),
                                    controller: _controller,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Choose Subject: ',
                                  style: TextStyle(
                                      color: Color(0xff5D6A7A),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: getWidth(context) * .3,
                                  child: DropdownButton<String>(
                                    value: dropdownvalue,
                                    onChanged: (String? newValue) async {
                                      setState(() => dropdownvalue = newValue!);
                                      // String token = await Provider.of<Auth>(
                                      //         context,
                                      //         listen: false)
                                      //     .getToken();
                                      // ignore: use_build_context_synchronously
                                      courseId = Provider.of<CourseStore>(
                                              context,
                                              listen: false)
                                          .allCourses
                                          .where((element) =>
                                              element.description == newValue)
                                          .toList()
                                          .first
                                          .id!;
                                    },
                                    isExpanded: true,

                                    items: items
                                        .map<DropdownMenuItem<String>>(
                                            (String? value) =>
                                                DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Center(
                                                      child: Text(
                                                    value!,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xff5D6A7A),
                                                    ),
                                                  )),
                                                ))
                                        .toList(),

                                    // add extra sugar..
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 20,
                                    underline: const SizedBox(),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: _controller.text.isEmpty
                                  ? null
                                  : () async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      String token = await Provider.of<Auth>(
                                              context,
                                              listen: false)
                                          .getToken();
                                      Provider.of<CourseStore>(context,
                                              listen: false)
                                          .getStudentReportForDoctor(
                                              context,
                                              token,
                                              courseId!,
                                              _controller.text)
                                          .then((value) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      });
                                    },
                              child: Container(
                                width: getWidth(context) * .5,
                                height: getHeight(context) * .05,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: _controller.text.isEmpty
                                        ? MyColors.myGrey
                                        : MyColors.myLightPurple),
                                child: const Center(
                                  child: Text(
                                    'Get Attendance',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 40,
                        width: double.infinity,
                        color: const Color(0xff161E4C),
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Student Attendance Count',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Consumer<CourseStore>(
                        builder: (context, courseStore, child) {
                          return Container(
                            // width: getWidth(context) * .7,
                            height: getHeight(context) * .15,
                            color: const Color.fromARGB(255, 237, 241, 248),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Lectures: ',
                                      style: TextStyle(
                                          color: Color(0xff5D6A7A),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      courseStore.studentReport == null
                                          ? 'No Data'
                                          : courseStore
                                              .studentReport!.lectureCount
                                              .toString(),
                                      style: const TextStyle(
                                          color: Color(0xff5D6A7A),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Sections: ',
                                      style: TextStyle(
                                          color: Color(0xff5D6A7A),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      courseStore.studentReport == null
                                          ? 'No Data'
                                          : courseStore
                                              .studentReport!.sectionCount
                                              .toString(),
                                      style: const TextStyle(
                                          color: Color(0xff5D6A7A),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 40,
                        width: double.infinity,
                        color: const Color(0xff161E4C),
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Student Attendance Percentage',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Consumer<CourseStore>(
                        builder: (context, courseStore, child) {
                          return Container(
                            // width: getWidth(context) * .7,
                            height: getHeight(context) * .15,
                            color: const Color.fromARGB(255, 237, 241, 248),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Lectures: ',
                                      style: TextStyle(
                                          color: Color(0xff5D6A7A),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      courseStore.studentReport == null
                                          ? 'No Data'
                                          : '${courseStore.studentReport!.lecturePercent} %',
                                      style: const TextStyle(
                                          color: Color(0xff5D6A7A),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Sections: ',
                                      style: TextStyle(
                                          color: Color(0xff5D6A7A),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      courseStore.studentReport == null
                                          ? 'No Data'
                                          : '${courseStore.studentReport!.sectionPercent} %',
                                      style: const TextStyle(
                                          color: Color(0xff5D6A7A),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
          )
        ]),
      ),
    );
  }
}

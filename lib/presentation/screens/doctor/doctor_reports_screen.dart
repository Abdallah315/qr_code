// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
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
  var _progress;
  String? courseId;
  String? courseName;
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
        if (items.length == 0) {
          dropdownvalue = 'no courses';
          items = ['no courses'];
        } else {
          dropdownvalue = items.first;
          course = Provider.of<CourseStore>(context, listen: false).allCourses;
          courseId = course?.first.id;
          courseName = course?.first.description;
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
                          'Reports',
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: getHeight(context) * .05,
                      ),
                      Container(
                        width: getWidth(context) * .7,
                        height: getHeight(context) * .25,
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
                                      courseName = newValue;
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
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: courseId == null
                                  ? null
                                  : () {
                                      FileDownloader.downloadFile(
                                        url:
                                            "http://134.122.64.234/api/v1/students-profiles/attendance_report_by_user_and_course/$courseId/",
                                        onProgress: (fileName, progress) {
                                          setState(() {
                                            _progress = progress;
                                          });
                                        },
                                        onDownloadCompleted: (pat) {
                                          String dir = path.dirname(pat);
                                          String newPath = path.join(dir,
                                              '$courseName-${DateTime.now().day}_${DateTime.now().month}_${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}.xlsx');

                                          File file = File(pat);
                                          file.rename(newPath);
                                          setState(() {
                                            _progress = null;
                                          });
                                        },
                                      );
                                    },
                              child: _progress != null
                                  ? const CircularProgressIndicator()
                                  : Container(
                                      width: getWidth(context) * .5,
                                      height: getHeight(context) * .05,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: courseId == null
                                              ? MyColors.myGrey
                                              : MyColors.myLightPurple),
                                      child: const Center(
                                        child: Text(
                                          'Download Excel',
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
                                          : '${courseStore.studentReport!.lecturePercent.toInt()} %',
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
                                          : '${courseStore.studentReport!.sectionPercent.toInt()} %',
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

  // Future<File?> downloadFile() async {
  //   var url =
  //       'http://134.122.64.234/api/v1/students-profiles/attendance_report_by_user_and_course/$courseId/';
  //   var response = await http.get(Uri.parse(url));
  //   var bytes = response.bodyBytes;
  //   var dir = await getApplicationDocumentsDirectory();
  //   File file = File('${dir.path}/file.xlsx');

  //   await file.writeAsBytes(bytes);
  //   if (response.statusCode == 200) {
  //     OpenFile.open(file.path);
  //   }

  //   print("Download completed.");
  //   print("File path: ${file.path}");
  //   return file;
  // }

  // Future<File?> downloadFile() async {
  //   try {
  //     var dir = await getApplicationDocumentsDirectory();
  //     final file = File('${dir.path}/file.xlsx');

  //     final reponse = await Dio().get(
  //       "http://134.122.64.234/api/v1/students-profiles/attendance_report_by_user_and_course/c4f77f26-ecba-438c-9139-bd59931f06e6/",
  //       options: Options(
  //         responseType: ResponseType.bytes,
  //         followRedirects: false,
  //         validateStatus: (status) => true,
  //         // receiveTimeout: 0,
  //       ),
  //     );
  //     print(reponse.statusCode);
  //     final raf = file.openSync(mode: FileMode.write);
  //     raf.writeFromSync(reponse.data);
  //     await raf.close();
  //     print("Download completed.");
  //     return file;
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  // Future<void> downloadFile() async {
  //   Dio dio = Dio();

  //   try {
  //     var dir = await getApplicationDocumentsDirectory();

  //     await dio.download(
  //       "http://134.122.64.234/api/v1/students-profiles/attendance_report_by_user_and_course/c4f77f26-ecba-438c-9139-bd59931f06e6/",
  //       "${dir.path}/file.xlsx",
  //       onReceiveProgress: (rec, total) {
  //         print("Rec: $rec , Total: $total");

  //         // Update the progress
  //       },
  //     );
  //     print("${dir.path}/file.xlsx");
  //   } catch (e) {
  //     print(e);
  //   }
  //   print("Download completed.");
  // }
}

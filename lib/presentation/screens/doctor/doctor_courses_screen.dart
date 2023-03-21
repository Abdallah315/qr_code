import 'package:flutter/material.dart';
import 'package:flutter_qr_code/data/store/auth.dart';
import 'package:flutter_qr_code/data/store/course_store.dart';
import 'package:flutter_qr_code/data/store/user_store.dart';
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
  String coursesDropDown = '';
  String lecturesDropDown = '';
  String periodsDropDown = '1';
  var lectures;
  List dummy = [];
  var courses;
  var periods = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    Provider.of<Auth>(context, listen: false).getToken().then((token) {
      Provider.of<UserStore>(context, listen: false).getUser(context, token);
      Provider.of<CourseStore>(context, listen: false)
          .getAllLectures(context, token)
          .then((value) {
        lectures = Provider.of<CourseStore>(context, listen: false)
            .allLectures
            .map((e) => e.description)
            .toList();
        if (lectures.length == 0) {
          lecturesDropDown = 'no lectures';
          lectures = ['no lectures'];
        } else {
          lecturesDropDown = lectures[0];
        }
      });
      Provider.of<CourseStore>(context, listen: false)
          .getAllCourses(context, token)
          .then((value) {
        courses = Provider.of<CourseStore>(context, listen: false)
            .allCourses
            .map((e) => e.description)
            .toList();
        if (courses.length == 0) {
          coursesDropDown = 'no courses';
          courses = ['no courses'];
        } else {
          coursesDropDown = courses[0];
        }

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
        elevation: 0,
      ),
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
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 70,
                    ),
                    const Text(
                      'Choose lecture',
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: getHeight(context) * .08,
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
                                'Choose Subject: ',
                                style: TextStyle(
                                    color: Color(0xff5D6A7A),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: getWidth(context) * .25,
                                child: DropdownButton<String>(
                                  value: coursesDropDown,
                                  onChanged: (String? newValue) {
                                    setState(() => coursesDropDown = newValue!);
                                  },
                                  isExpanded: true,

                                  items: courses != null
                                      ? courses
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
                                                        color:
                                                            Color(0xff5D6A7A),
                                                      ),
                                                    )),
                                                  ))
                                          .toList()
                                      : [],

                                  // add extra sugar..
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 20,
                                  underline: const SizedBox(),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Choose Lecture: ',
                                style: TextStyle(
                                    color: Color(0xff5D6A7A),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: getWidth(context) * .25,
                                child: DropdownButton<String>(
                                  value: lecturesDropDown,
                                  onChanged: (String? newValue) {
                                    setState(
                                        () => lecturesDropDown = newValue!);
                                  },
                                  isExpanded: true,

                                  items: lectures != null
                                      ? lectures
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
                                                        color:
                                                            Color(0xff5D6A7A),
                                                      ),
                                                    )),
                                                  ))
                                          .toList()
                                      : [],

                                  // add extra sugar..
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 20,
                                  underline: const SizedBox(),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Choose Period: ',
                                style: TextStyle(
                                    color: Color(0xff5D6A7A),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: getWidth(context) * .25,
                                child: DropdownButton<String>(
                                  value: periodsDropDown,
                                  onChanged: (String? newValue) {
                                    setState(() => periodsDropDown = newValue!);
                                  },
                                  isExpanded: true,

                                  items: periods
                                      .map<DropdownMenuItem<String>>(
                                          (String? value) =>
                                              DropdownMenuItem<String>(
                                                value: value,
                                                child: Center(
                                                    child: Text(
                                                  value!,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
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
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff161E4C),
                          fixedSize: Size(getWidth(context) * 0.6, 60)),
                      child: const Text(
                        ('Create QR'),
                      ),
                    ),
                  ],
                ),
        )
      ]),

      // body: SizedBox(
      //   width: getWidth(context),
      //   height: getHeight(context),
      //   child: Consumer<CourseStore>(builder: (context, courseStore, child) {
      //     return isLoading
      //         ? const Center(
      //             child: CircularProgressIndicator.adaptive(),
      //           )
      //         : ListView.builder(
      //             itemBuilder: (context, index) {
      //               return Column(
      //                 children: [
      //                   const SizedBox(
      //                     height: 20,
      //                   ),
      //                   GestureDetector(
      //                     onTap: () => Navigator.of(context).pushNamed(
      //                         CreateQrCodeScreen.routeName,
      //                         arguments: {
      //                           'course': courseStore.allCourses[index]
      //                         }),
      //                     child: Container(
      //                       width: getWidth(context) * .8,
      //                       height: getHeight(context) * .1,
      //                       color: const Color.fromARGB(255, 237, 241, 248),
      //                       padding: const EdgeInsets.all(10),
      //                       child: Column(
      //                         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //                         children: [
      //                           Text(
      //                             'Course Code: ${courseStore.allCourses[index].title}',
      //                             style: const TextStyle(
      //                                 color: Color(0xff5D6A7A),
      //                                 fontSize: 15,
      //                                 fontWeight: FontWeight.w500),
      //                           ),
      //                           Text(
      //                             'Course Name: ${courseStore.allCourses[index].description}',
      //                             style: const TextStyle(
      //                                 color: Color(0xff5D6A7A),
      //                                 fontSize: 15,
      //                                 fontWeight: FontWeight.w500),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //                   const SizedBox(
      //                     height: 5,
      //                   )
      //                 ],
      //               );
      //             },
      //             itemCount: courseStore.allCourses.length,
      //           );
      //   }),
      // ),
    );
  }
}

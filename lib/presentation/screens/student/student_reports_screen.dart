import 'package:flutter/material.dart';
import 'package:flutter_qr_code/data/store/auth.dart';
import 'package:flutter_qr_code/data/store/course_store.dart';
import 'package:flutter_qr_code/utils/constants.dart';
import 'package:provider/provider.dart';

class StudentReportsScreen extends StatefulWidget {
  static const routeName = '/student-report';
  const StudentReportsScreen({super.key});

  @override
  State<StudentReportsScreen> createState() => _StudentReportsScreenState();
}

class _StudentReportsScreenState extends State<StudentReportsScreen> {
  bool _isLoading = false;
  String dropdownvalue = '';
  var items;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Auth>(context, listen: false).getToken().then((token) {
      Provider.of<CourseStore>(context, listen: false)
          .getStudentCourses(context, token)
          .then((value) {
        // items = Provider.of<CourseStore>(context, listen: false).studentCourses.map((item) => item.courseInfo!.title).toList();
        items = Provider.of<CourseStore>(context, listen: false)
            .studentCourses
            .map((item) => item.courseInfo!.description)
            .toList();
        if (items.length == 0) {
          dropdownvalue = 'no courses';
          items = ['no courses'];
        }
        print(items);
        setState(() {
          _isLoading = false;
        });
      });
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
                    child: CircularProgressIndicator.adaptive(),
                  )
                : Column(
                    children: [
                      const SizedBox(
                        height: 70,
                      ),
                      const Text(
                        'Reports Card',
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.w700),
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
                              children: const [
                                Text(
                                  'Student Name: ',
                                  style: TextStyle(
                                      color: Color(0xff5D6A7A),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  'name',
                                  style: TextStyle(
                                      color: Color(0xff5D6A7A),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            Row(
                              children: const [
                                Text(
                                  'Grade: ',
                                  style: TextStyle(
                                      color: Color(0xff5D6A7A),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '50',
                                  style: TextStyle(
                                      color: Color(0xff5D6A7A),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
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
                                    value: dropdownvalue,
                                    onChanged: (String? newValue) {
                                      setState(() => dropdownvalue = newValue!);
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
                          'Your Attendance',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        // width: getWidth(context) * .7,
                        height: getHeight(context) * .18,
                        color: const Color.fromARGB(255, 237, 241, 248),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'Lectures: ',
                                  style: TextStyle(
                                      color: Color(0xff5D6A7A),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '1',
                                  style: TextStyle(
                                      color: Color(0xff5D6A7A),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            Row(
                              children: const [
                                Text(
                                  'Sections: ',
                                  style: TextStyle(
                                      color: Color(0xff5D6A7A),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '5',
                                  style: TextStyle(
                                      color: Color(0xff5D6A7A),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          )
        ]),
      ),
    );
  }
}

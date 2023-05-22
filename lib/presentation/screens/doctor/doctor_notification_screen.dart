// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/store/auth.dart';
import '../../../data/store/course_store.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../widgets/text_form.dart';

class DoctorNotificationScreen extends StatefulWidget {
  static const routeName = '/doctor-notification';
  const DoctorNotificationScreen({super.key});

  @override
  State<DoctorNotificationScreen> createState() =>
      _DoctorNotificationScreenState();
}

class _DoctorNotificationScreenState extends State<DoctorNotificationScreen> {
  TextEditingController notificationTitleController = TextEditingController();
  TextEditingController notificationSubtitleController =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey();

  var courses;
  bool isLoading = false;
  String coursesDropDown = '';
  String? courseId;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    Provider.of<Auth>(context, listen: false)
        .getToken()
        .then((value) => print(value));

    Provider.of<Auth>(context, listen: false).getToken().then((token) {
      Provider.of<CourseStore>(context, listen: false)
          .getAllCourses(context, token)
          .then((value) {
        // TODO :filter courses that belongs to the specific doctor
        courses = Provider.of<CourseStore>(context, listen: false)
            .allCourses
            .map((e) => e.description)
            .toList();
        if (courses.length == 0) {
          coursesDropDown = 'no courses';
          courses = ['no courses'];
        } else {
          coursesDropDown = courses[0];
          courseId = Provider.of<CourseStore>(context, listen: false)
              .allCourses
              .first
              .id;
        }
      }).then((value) {
        setState(() {
          isLoading = false;
        });
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
          child: Column(
            children: [
              SizedBox(
                height: getHeight(context) * .06,
              ),
              Container(
                width: getWidth(context),
                height: getHeight(context) * 0.94,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(29),
                    topLeft: Radius.circular(29),
                  ),
                  color: MyColors.myDarkPurple,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: getHeight(context) * .05,
                      ),
                      Container(
                        width: getWidth(context) * .85,
                        height: getHeight(context) * .85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: MyColors.myWhite,
                        ),
                        child: Column(
                          children: [
                            Form(
                              key: _formkey,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: getHeight(context) * .02,
                                  ),
                                  Text(
                                    "Title",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: MyColors.myDarkPurple,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: getWidth(context) * .7,
                                    child: TextForm(
                                        controller: notificationTitleController,
                                        obscure: false,
                                        hintText: 'notification title',
                                        textColor: MyColors.myDarkPurple,
                                        color: const Color(0xffb8c0e5),
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return 'please make sure you\'ve entered the right data';
                                          }
                                          return null;
                                        },
                                        onSaved: (val) {}),
                                  ),
                                  SizedBox(
                                    height: getHeight(context) * .05,
                                  ),
                                  Text(
                                    "Subtitle",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: MyColors.myDarkPurple,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                      width: getWidth(context) * .7,
                                      child: TextFormField(
                                        controller:
                                            notificationSubtitleController,
                                        maxLines: 10,
                                        style: TextStyle(
                                            color: MyColors.myWhite,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700),
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: const BorderSide(
                                              width: 2,
                                              color: Color(0xffA6B3BF),
                                            ),
                                          ),
                                          errorBorder: InputBorder.none,
                                          hintText: 'notification body',
                                          hintStyle: TextStyle(
                                            color: MyColors.myDarkPurple,
                                          ),
                                          filled: true,
                                          fillColor: MyColors.myGrey,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: const BorderSide(
                                              width: 2,
                                              color: Color(0xffA6B3BF),
                                            ),
                                          ),
                                        ),
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return 'please make sure you\'ve entered the right data';
                                          }
                                          return null;
                                        },
                                        onSaved: (val) {},
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: getHeight(context) * .05,
                            ),
                            Text(
                              "Choose Subject",
                              style: TextStyle(
                                fontSize: 12,
                                color: MyColors.myDarkPurple,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: getWidth(context) * .3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: const Color(0xffb8c0e5),
                              ),
                              child: DropdownButton<String>(
                                value: coursesDropDown,
                                onChanged: (String? newValue) {
                                  setState(() => coursesDropDown = newValue!);
                                  courseId = Provider.of<CourseStore>(context,
                                          listen: false)
                                      .allCourses
                                      .where((element) =>
                                          element.description == newValue)
                                      .toList()
                                      .first
                                      .id;
                                },
                                isExpanded: true,
                                isDense: true,
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
                                                      color: Color(0xff5D6A7A),
                                                    ),
                                                  )),
                                                ))
                                        .toList()
                                    : [],

                                // add extra sugar..
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: getHeight(context) * .05,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: _submit,
                                child: Container(
                                  width: getWidth(context) * .45,
                                  height: 55,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(29),
                                      color: MyColors.myLightPurple),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Notify',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: MyColors.myWhite),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        // Sign user up
        // ! send data to the backend
        final token =
            await Provider.of<Auth>(context, listen: false).getToken();
        Provider.of<CourseStore>(context, listen: false).sendNotification(
            context,
            token,
            courseId!,
            notificationTitleController.text,
            notificationSubtitleController.text);
      } catch (error) {
        const errorMessage =
            'Could not authenticate you. Please try again later.';
        print('canot handle $error');
      }

      setState(() {
        isLoading = false;
      });
    }
  }
}

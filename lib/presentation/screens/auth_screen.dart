import 'package:flutter/material.dart';
import 'package:flutter_qr_code/utils/colors.dart';
import 'package:flutter_qr_code/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../data/store/auth.dart';

enum AuthMode { SignUp, Login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  TextEditingController studentIdController = TextEditingController();
  AuthMode _authMode = AuthMode.SignUp;
  final GlobalKey<FormState> _formkey = GlobalKey();
  final Map<String, dynamic> _authData = {
    'name': '',
    'email': '',
    'student-id': '',
    'password': '',
    're-password': '',
  };
  bool showPass = false;
  bool isLoading = false;

  String dropdownvalue = 'Student';

  // List of items in our dropdown menu
  var items = [
    'Student',
    'Doctor',
  ];
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
                    height: getHeight(context) * .03,
                  ),
                  Text(
                    'Create New\n Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      color: MyColors.myWhite,
                    ),
                  ),
                  SizedBox(
                    height: getHeight(context) * .02,
                  ),
                  _authMode == AuthMode.SignUp
                      ? buildSignUpForm()
                      : buildLoginForm(),
                  SizedBox(
                    height: getHeight(context) * .05,
                  ),
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : buildFormButton(context),
                  SizedBox(
                    height: getHeight(context) * .02,
                  ),
                  switchAuthMode(),
                  const SizedBox(
                    height: 15,
                  ),
                ]),
              ),
            )
          ]),
        ),
      ),
    );
  }

  buildSignUpForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name",
                style: TextStyle(
                  fontSize: 12,
                  color: MyColors.myWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextForm(
                controller: nameController,
                obscure: false,
                hintText: 'Jiara Martin',
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'This field can\'t be empty';
                  }
                  return null;
                },
                onSaved: (val) {
                  _authData['name'] = val!;
                },
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                "Email",
                style: TextStyle(
                  fontSize: 12,
                  color: MyColors.myWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextForm(
                  controller: emailController,
                  obscure: false,
                  hintText: 'jiara@martin.com',
                  validator: (val) {
                    if (!val!.contains('@') || val.isEmpty) {
                      return 'please make sure you\'ve entered the right data';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authData['email'] = val!;
                  }),
              const SizedBox(
                height: 25,
              ),
              Text(
                "password",
                style: TextStyle(
                  fontSize: 12,
                  color: MyColors.myWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextForm(
                  controller: passwordController,
                  hintText: 'your password',
                  obscure: showPass == true ? false : true,
                  onTap: () {
                    setState(() {
                      if (showPass == true) {
                        showPass = false;
                      } else {
                        showPass = true;
                      }
                    });
                  },
                  validator: (val) {
                    if (val!.isEmpty || val.length < 6) {
                      return 'password must be 6 numbers or more';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authData['password'] = val!;
                  }),
              const SizedBox(
                height: 25,
              ),
              Text(
                "Repeat Password",
                style: TextStyle(
                  fontSize: 12,
                  color: MyColors.myWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextForm(
                  controller: rePasswordController,
                  hintText: 'repeat your password',
                  obscure: showPass == true ? false : true,
                  onTap: () {
                    setState(() {
                      if (showPass == true) {
                        showPass = false;
                      } else {
                        showPass = true;
                      }
                    });
                  },
                  validator: (val) {
                    if (val!.isEmpty || _authData['password'] != val) {
                      return 'password doesn\'t match';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authData['re-password'] = val!;
                  }),
              const SizedBox(
                height: 25,
              ),
              if (dropdownvalue == 'Student')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Student ID",
                      style: TextStyle(
                        fontSize: 12,
                        color: MyColors.myWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextForm(
                        controller: studentIdController,
                        hintText: 'Your id',
                        obscure: false,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter your id';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _authData['student-id'] = val!;
                        }),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              Text(
                "Role",
                style: TextStyle(
                  fontSize: 12,
                  color: MyColors.myWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Center(
                child: Container(
                  width: getWidth(context) * .88,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),

                  // dropdown below..
                  child: DropdownButton<String>(
                    value: dropdownvalue,
                    onChanged: (String? newValue) {
                      setState(() => dropdownvalue = newValue!);
                    },
                    isExpanded: true,
                    items: items
                        .map<DropdownMenuItem<String>>(
                            (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Center(child: Text(value)),
                                ))
                        .toList(),

                    // add extra sugar..
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 42,
                    underline: const SizedBox(),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Email",
                style: TextStyle(
                  fontSize: 12,
                  color: MyColors.myWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextForm(
                  controller: emailController,
                  obscure: false,
                  hintText: 'jiara@martin.com',
                  validator: (val) {
                    if (!val!.contains('@') || val.isEmpty) {
                      return 'please make sure you\'ve entered the right data';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authData['email'] = val!;
                  }),
              const SizedBox(
                height: 25,
              ),
              Text(
                "password",
                style: TextStyle(
                  fontSize: 12,
                  color: MyColors.myWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextForm(
                  controller: passwordController,
                  hintText: 'your password',
                  obscure: showPass == true ? false : true,
                  onTap: () {
                    setState(() {
                      if (showPass == true) {
                        showPass = false;
                      } else {
                        showPass = true;
                      }
                    });
                  },
                  validator: (val) {
                    if (val!.isEmpty || val.length < 6) {
                      return 'password must be 6 numbers or more';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authData['password'] = val!;
                  }),
            ],
          )),
    );
  }

  buildFormButton(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          _submit();
          print(_authData);
        },
        child: Container(
          width: getWidth(context) * .85,
          height: 55,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(29),
              color: MyColors.myLightPurple),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _authMode == AuthMode.SignUp ? 'Sign up' : 'Login',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: MyColors.myWhite),
              ),
            ],
          ),
        ),
      ),
    );
  }

  switchAuthMode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _authMode == AuthMode.SignUp
              ? 'Already have an account?'
              : 'Don\'t have an account?',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: MyColors.myWhite),
        ),
        const SizedBox(
          width: 5,
        ),
        GestureDetector(
          onTap: () {
            nameController.clear();
            passwordController.clear();
            emailController.clear();
            rePasswordController.clear();
            if (_authMode == AuthMode.SignUp) {
              setState(() {
                _authMode = AuthMode.Login;
              });
            } else {
              setState(() {
                _authMode = AuthMode.SignUp;
              });
            }
          },
          child: Text(
            _authMode == AuthMode.SignUp ? 'Login Now' : 'Register Now',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: MyColors.myLightPurple),
          ),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    _formkey.currentState!.save();
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        if (_authMode == AuthMode.Login) {
          // Log user in
          await Provider.of<Auth>(context, listen: false).login(
            email: _authData['email'].toString(),
            password: _authData['password'].toString(),
          );
        } else {
          // Sign user up
          await Provider.of<Auth>(context, listen: false).register(
              context: context,
              email: _authData['email'].toString(),
              name: _authData['name'].toString(),
              studentId: int.parse(_authData['student-id']),
              userType: dropdownvalue.toLowerCase(),
              password: _authData['password'].toString(),
              rePassword: _authData['re-password'].toString());
        }
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

class TextForm extends StatelessWidget {
  const TextForm(
      {Key? key,
      required this.controller,
      required this.obscure,
      required this.hintText,
      required this.onSaved,
      required this.validator,
      this.onTap})
      : super(key: key);

  final TextEditingController controller;
  final bool obscure;
  final String hintText;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(
          color: MyColors.myWhite, fontSize: 13, fontWeight: FontWeight.w700),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            width: 2,
            color: Color(0xffA6B3BF),
          ),
        ),
        errorBorder: InputBorder.none,
        hintText: hintText,
        hintStyle: TextStyle(
          color: MyColors.myWhite.withOpacity(.5),
        ),
        filled: true,
        fillColor: MyColors.myGrey,
        suffix: hintText == 'كلمة السر الخاصة بالحساب'
            ? GestureDetector(
                onTap: onTap,
                child: const Text(
                  'إظهار',
                  style: TextStyle(
                    color: Color(0xffFF494B),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            width: 2,
            color: Color(0xffA6B3BF),
          ),
        ),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}

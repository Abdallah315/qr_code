import 'package:flutter/material.dart';
import 'package:flutter_qr_code/utils/colors.dart';
import 'package:flutter_qr_code/utils/constants.dart';

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
  AuthMode _authMode = AuthMode.SignUp;
  final Map<String, dynamic> _authData = {
    'name': '',
    'email': '',
    'password': '',
  };
  bool showPass = false;

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
              height: getHeight(context) * .2,
            ),
            Container(
              width: getWidth(context),
              height: getHeight(context) * .8,
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
                  buildForm(),
                  SizedBox(
                    height: getHeight(context) * .05,
                  ),
                  buildFormButton(context),
                  SizedBox(
                    height: getHeight(context) * .02,
                  ),
                  switchAuthMode(),
                ]),
              ),
            )
          ]),
        ),
      ),
    );
  }

  buildForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_authMode == AuthMode.SignUp)
            Text(
              "Name",
              style: TextStyle(
                fontSize: 12,
                color: MyColors.myWhite,
                fontWeight: FontWeight.w700,
              ),
            ),
          if (_authMode == AuthMode.SignUp)
            const SizedBox(
              height: 5,
            ),
          if (_authMode == AuthMode.SignUp)
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
          if (_authMode == AuthMode.SignUp)
            const SizedBox(
              height: 5,
            ),
          if (_authMode == AuthMode.SignUp)
            Text(
              "Role",
              style: TextStyle(
                fontSize: 12,
                color: MyColors.myWhite,
                fontWeight: FontWeight.w700,
              ),
            ),
          if (_authMode == AuthMode.SignUp)
            const SizedBox(
              height: 5,
            ),
          if (_authMode == AuthMode.SignUp)
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

  buildFormButton(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // ! part of form submit
          // if (_authMode == AuthMode.SignUp) {
          //   FirebaseAuth.instance.createUserWithEmailAndPassword(
          //     email: _authData['email']!,
          //     password: _authData['password']!,
          //   );
          // } else {
          //   FirebaseAuth.instance.signInWithEmailAndPassword(
          //     email: _authData['email']!,
          //     password: _authData['password']!,
          //   );
          // }
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

import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class TextForm extends StatelessWidget {
  const TextForm(
      {Key? key,
      required this.controller,
      required this.obscure,
      required this.hintText,
      required this.onSaved,
      required this.validator,
      this.color,
      this.maxLines,
      this.textColor,
      required this.textFieldColor,
      this.onTap})
      : super(key: key);

  final TextEditingController controller;
  final bool obscure;
  final String hintText;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final Color? color;
  final int? maxLines;
  final Color? textColor;
  final Color? textFieldColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      // maxLines: obscure ? 1 : maxLines,
      style: TextStyle(
          color: textFieldColor, fontSize: 13, fontWeight: FontWeight.w700),
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
          color: textColor ?? MyColors.myWhite.withOpacity(.5),
        ),
        filled: true,
        fillColor: color ?? MyColors.myGrey,
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

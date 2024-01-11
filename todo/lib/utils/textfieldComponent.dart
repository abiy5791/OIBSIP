// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';

class TextfieldComponent extends StatelessWidget {
  String labelName;
  Color? inputColor;
  Color? labelColor;
  TextInputType? textInputType;
  TextEditingController controller;
  String? Function(String?)? validator;
  TextfieldComponent(
      {required this.labelName,
      required this.controller,
      this.inputColor = Colors.white,
      this.textInputType,
      this.labelColor = Colors.white70,
      this.validator,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        color: inputColor,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      controller: controller,
      keyboardType: textInputType,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          labelText: labelName,
          labelStyle: TextStyle(color: labelColor)),
    );
  }
}

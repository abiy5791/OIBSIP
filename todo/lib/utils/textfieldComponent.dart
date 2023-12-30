// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';

class TextfieldComponent extends StatelessWidget {
  String labelName;
  Color? inputColor;
  Color? labelColor;
  TextInputType? textInputType;
  TextfieldComponent(
      {required this.labelName,
      this.inputColor = Colors.white,
      this.textInputType,
      this.labelColor = Colors.white70,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
        color: inputColor,
      ),
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

// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';

class buttonComponent extends StatelessWidget {
  void Function()? onPressed;
  String btnName;
  Color? btnColor;
  Color? btnTextColor;
  buttonComponent({
    required this.btnName,
    this.btnColor,
    this.onPressed,
    this.btnTextColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(
            color: btnColor, borderRadius: BorderRadius.circular(10)),
        child: Text(
          btnName,
          style: TextStyle(
              color: btnTextColor, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

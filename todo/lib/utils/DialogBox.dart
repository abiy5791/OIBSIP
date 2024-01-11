// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_interpolation_to_compose_strings, sized_box_for_whitespace, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:todo/utils/buttonComponent.dart';

class DialogBox extends StatelessWidget {
  VoidCallback onSave;
  VoidCallback onCancel;
  final titleController;
  final detailsController;
  String save_or_update;

  DialogBox(
      {super.key,
      required this.onSave,
      required this.onCancel,
      required this.titleController,
      required this.detailsController,
      this.save_or_update = ""});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      backgroundColor: Colors.white,
      content: Container(
        height: MediaQuery.of(context).size.height / 2.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              save_or_update + " Task",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B6B93)),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: titleController,
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                hintText: 'Enter your Title',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: detailsController,
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                hintText: 'Enter your Details',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buttonComponent(
                  btnName: save_or_update,
                  onPressed: onSave,
                  btnColor: Color(0xFF5A96E3),
                  btnTextColor: Colors.white,
                ),
                const SizedBox(
                  width: 8,
                ),
                buttonComponent(
                  btnName: "Cancel",
                  onPressed: onCancel,
                  btnColor: Color(0xFFF24C3D),
                  btnTextColor: Colors.white,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

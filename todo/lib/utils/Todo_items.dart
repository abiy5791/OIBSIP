// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoItems extends StatelessWidget {
  final String taskTitle;
  final String taskDetail;
  final bool taskCompleted;
  Function(bool?)? onChange;
  Function(BuildContext)? DeleteFunction;
  Function(BuildContext)? EditFuncion;

  TodoItems(
      {super.key,
      required this.taskTitle,
      required this.taskDetail,
      required this.taskCompleted,
      required this.onChange,
      required this.DeleteFunction,
      required this.EditFuncion});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 15, right: 10),
      child: Slidable(
        endActionPane: ActionPane(motion: StretchMotion(), children: [
          SlidableAction(
            onPressed: DeleteFunction,
            icon: Icons.delete,
            backgroundColor: Color.fromARGB(210, 244, 67, 54),
            borderRadius: BorderRadius.circular(8),
          )
        ]),
        startActionPane: ActionPane(motion: StretchMotion(), children: [
          SlidableAction(
            onPressed: EditFuncion,
            icon: Icons.edit,
            backgroundColor: const Color.fromARGB(215, 76, 175, 79),
            borderRadius: BorderRadius.circular(8),
          )
        ]),
        child: Container(
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(8.0), // Set the border radius here
            color: taskCompleted
                ? Color.fromARGB(171, 158, 158, 158)
                : Color(0xFF89CFF3),
          ),
          child: ListTile(
            leading: Checkbox(
              value: taskCompleted,
              onChanged: onChange,
            ),
            title: Text(
              taskTitle,
              style: TextStyle(
                decoration: taskCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              taskDetail,
              style: TextStyle(
                decoration: taskCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/utils/DialogBox.dart';
import 'package:todo/utils/Todo_items.dart';
import '../database/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  String? displayName;
  String? phontoUrl;
  String? phoneNumber;
  String? email;
  HomePage(
      {this.displayName,
      this.email,
      this.phoneNumber,
      this.phontoUrl,
      super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the hive box
  final _mybox = Hive.box('mybox');
  Todo_db db_todo = Todo_db();

  @override
  void initState() {
    if (_mybox.get("TODOLIST") == null) {
      db_todo.InitialData();
    } else {
      db_todo.LoadData();
    }
    super.initState();
  }

  final titlecontroller = TextEditingController();
  final detailcontroller = TextEditingController();

  void checkbox_changed(bool? value, int index) {
    setState(() {
      db_todo.ToDoList[index][2] = !db_todo.ToDoList[index][2];
    });
    db_todo.update_db();
  }

  void saveTask() {
    setState(() {
      db_todo.ToDoList.add(
          [titlecontroller.text, detailcontroller.text, false]);
    });
    titlecontroller.clear();
    detailcontroller.clear();
    Navigator.of(context).pop();
    db_todo.update_db();
  }

  void createTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          onSave: saveTask,
          onCancel: () => Navigator.of(context).pop(),
          titleController: titlecontroller,
          detailsController: detailcontroller,
          save_or_update: "Add",
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF5F7F8),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFF89CFF3),
          title: Text(
            "To Do",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: GestureDetector(
                onTap: () async {
                  await GoogleSignIn().signOut();
                  FirebaseAuth.instance.signOut();
                },
                child: Icon(
                  Icons.logout,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createTask,
          backgroundColor: Color(0xFF89CFF3),
          child: Icon(
            Icons.add,
          ),
        ),
        body: ListView.builder(
          itemCount: db_todo.ToDoList.length,
          itemBuilder: (context, index) {
            return TodoItems(
              taskTitle: db_todo.ToDoList[index][0],
              taskDetail: db_todo.ToDoList[index][1],
              taskCompleted: db_todo.ToDoList[index][2],
              onChange: (value) => checkbox_changed(value, index),
              DeleteFunction: (context) {
                setState(() {
                  db_todo.ToDoList.removeAt(index);
                });
                db_todo.update_db();
              },
              EditFuncion: (context) {
                showDialog(
                  context: context,
                  builder: (context) {
                    // Fetch initial data
                    String initialTitle = db_todo.ToDoList[index][0];
                    String initialDetails = db_todo.ToDoList[index][1];

                    // Create TextEditingController instances and set initial values
                    TextEditingController titleController =
                        TextEditingController(text: initialTitle);
                    TextEditingController detailsController =
                        TextEditingController(text: initialDetails);

                    return DialogBox(
                      titleController: titleController,
                      detailsController: detailsController,
                      save_or_update: "Update",
                      onSave: () {
                        setState(() {
                          db_todo.ToDoList[index][0] = titleController.text;
                          db_todo.ToDoList[index][1] = detailsController.text;
                        });
                        titleController.clear();
                        detailsController.clear();
                        Navigator.of(context).pop();
                        db_todo.update_db();
                      },
                      onCancel: () {
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              },
            );
          },
        ));
  }
}

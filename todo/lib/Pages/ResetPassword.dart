// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:todo/utils/buttonComponent.dart';
import 'package:todo/utils/snackbarUtils.dart';
import 'package:todo/utils/textfieldComponent.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  Future _ResetPassword() async {
    final isvalid = formkey.currentState!.validate();
    if (!isvalid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      utils.showSnackBar("Password reset email is sent!");
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      utils.showSnackBar(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment(1, -1),
            child: Container(
              width: 200,
              height: 200,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.cyan),
            ),
          ),
          Align(
            alignment: Alignment(1, 1),
            child: Container(
              width: 200,
              height: 200,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
            ),
          ),
          Align(
            alignment: Alignment(-3, 0),
            child: Container(
              width: 320,
              height: 320,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: Container(
              decoration: BoxDecoration(color: Colors.transparent),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ResetPassword",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextfieldComponent(
                      controller: emailController,
                      labelName: "Email",
                      textInputType: TextInputType.emailAddress,
                      validator: (email) {
                        if (email == '') {
                          return 'The email field is required!';
                        } else if (email != null &&
                            !EmailValidator.validate(email)) {
                          return 'Enter a valid email please!';
                        } else {
                          return null;
                        }
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  buttonComponent(
                    btnName: 'ResetPassword',
                    onPressed: _ResetPassword,
                    btnColor: Colors.white,
                    btnTextColor: Colors.black,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

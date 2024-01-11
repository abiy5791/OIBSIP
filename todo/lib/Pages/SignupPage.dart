// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/main.dart';
import 'package:todo/utils/backgroundComponents.dart';
import 'package:todo/utils/buttonComponent.dart';
import 'package:todo/utils/snackbarUtils.dart';
import 'package:todo/utils/textfieldComponent.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future SignUp() async {
    final isvalid = formkey.currentState!.validate();
    if (!isvalid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      emailController.clear();
      passwordController.clear();
      nameController.clear();
    } on FirebaseAuthException catch (e) {
      // print(e);
      utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
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
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundComponents(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Form(
                key: formkey,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextfieldComponent(
                            controller: nameController,
                            labelName: "Full Name",
                            validator: (value) {
                              if (value == '') {
                                return 'The Name field is required!';
                              }
                              if (value != null && value.length < 3) {
                                return 'Enter a real name please!';
                              } else {
                                return null;
                              }
                            }),
                        SizedBox(
                          height: 5,
                        ),
                        TextfieldComponent(
                            labelName: "Email",
                            textInputType: TextInputType.emailAddress,
                            controller: emailController,
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
                          height: 5,
                        ),
                        TextfieldComponent(
                            controller: passwordController,
                            labelName: "Password",
                            textInputType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value == '') {
                                return 'The password field is required!';
                              }
                              if (value != null && value.length < 6) {
                                return 'Enter min. 6 characters!';
                              } else {
                                return null;
                              }
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "I have already an account!",
                            style: TextStyle(
                                color: Color.fromARGB(243, 194, 228, 255),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(height: 20),
                        buttonComponent(
                          btnName: 'SignUp',
                          onPressed: SignUp,
                          btnColor: Colors.white,
                          btnTextColor: Colors.black,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Text(
                            "SignUp With",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.phone,
                              size: 38,
                              color: Colors.white,
                            ),
                            SizedBox(
                                width: 50,
                                height: 50,
                                child: Image.network(
                                    'http://pngimg.com/uploads/google/google_PNG19635.png',
                                    fit: BoxFit.cover)),
                            Icon(
                              Icons.apple,
                              size: 38,
                              color: Colors.white,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

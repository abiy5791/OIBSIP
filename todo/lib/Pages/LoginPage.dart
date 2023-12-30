// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/utils/buttonComponent.dart';
import 'package:todo/utils/textfieldComponent.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
                TextfieldComponent(
                  labelName: "Email",
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 5,
                ),
                TextfieldComponent(
                  labelName: "Password",
                  textInputType: TextInputType.visiblePassword,
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "I don't have an account!",
                    style: TextStyle(
                        color: Color.fromARGB(243, 194, 228, 255),
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 20),
                buttonComponent(
                  btnName: "Login",
                  onPressed: () {},
                  btnColor: Colors.white,
                  btnTextColor: Colors.black,
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    "SignIn With",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
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
        ],
      ),
    );
  }
}

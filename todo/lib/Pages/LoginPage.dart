// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/Pages/HomePage.dart';
import 'package:todo/Pages/PhoneAuth.dart';
import 'package:todo/Pages/ResetPassword.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo/Pages/SignupPage.dart';
import 'package:todo/main.dart';
import 'package:todo/utils/backgroundComponents.dart';
import 'package:todo/utils/buttonComponent.dart';
import 'package:todo/utils/snackbarUtils.dart';
import 'package:todo/utils/textfieldComponent.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future SignIn() async {
    final isvalid = formkey.currentState!.validate();
    if (!isvalid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      // print(e);
      utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (userCredential.user != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  signinWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      if (userCredential.user != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => HomePage(
                    displayName: userCredential.user!.displayName!,
                    phontoUrl: userCredential.user!.photoURL ?? "",
                    phoneNumber: userCredential.user!.phoneNumber ?? "",
                    email: userCredential.user!.email ?? "",
                  )),
        );
      }
    } catch (e) {
      utils.showSnackBar('Failed to sign in with Facebook: $e');
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
          BackgroundComponents(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: formkey,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext) {
                          return SignupPage();
                        }),
                      );
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
                    btnName: 'Login',
                    onPressed: SignIn,
                    btnColor: Colors.white,
                    btnTextColor: Colors.black,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext) {
                          return ResetPassword();
                        }));
                      },
                      child: Text(
                        "forgot password?",
                        style: TextStyle(
                          color: Colors.green[100],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext) {
                            return PhoneAuth();
                          }));
                        },
                        child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Image.network(
                                'https://pngimg.com/uploads/phone/phone_PNG48933.png',
                                fit: BoxFit.cover)),
                      ),
                      GestureDetector(
                        onTap: () {
                          signInWithGoogle();
                        },
                        child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.network(
                                'http://pngimg.com/uploads/google/google_PNG19635.png',
                                fit: BoxFit.cover)),
                      ),
                      GestureDetector(
                        onTap: () {
                          signinWithFacebook();
                        },
                        child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Image.network(
                                'https://pngimg.com/uploads/facebook_logos/facebook_logos_PNG19750.png',
                                fit: BoxFit.cover)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

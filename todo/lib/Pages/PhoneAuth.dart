// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/Pages/HomePage.dart';
import 'package:todo/utils/buttonComponent.dart';
import 'package:todo/utils/snackbarUtils.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  bool isActive = false;
  final _auth = FirebaseAuth.instance;
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  String? _verificationId;

  Future<void> phoneAuthentication() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+2510" + _phoneController.text.trim(),
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);

          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            utils.showSnackBar('The provided phone number is not valid.');
          } else if (e.code == 'too-many-requests') {
            utils.showSnackBar(
                'We have blocked all requests from this device due to unusual activity. Try again later..');
          } else {
            utils.showSnackBar(
                'Phone authentication failed. Please try again later.');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          setState(() {
            isActive = true;
            _verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      utils.showSnackBar(
          'An error occurred during phone authentication. Please try again later.');
    }
  }

  Future<void> signInWithPhoneNumber() async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _otpController.text.trim(),
      );

      await _auth.signInWithCredential(credential);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'session-expired') {
        utils.showSnackBar(
            'The SMS code has expired. Please request a new one.');
      } else {
        utils.showSnackBar('Failed to sign in: ' + e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Stack(children: [
        // BackgroundComponents(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
                child: Padding(
              padding: const EdgeInsets.all(38.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Phone Authentication",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Mobile Number",
                    style: TextStyle(
                      color: const Color.fromARGB(127, 255, 255, 255),
                    ),
                  ),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 9,
                    style: TextStyle(color: Colors.white),
                    autofocus: true,
                    decoration: InputDecoration(
                        prefixText: "+251 ",
                        hintText: "910121687",
                        hintStyle: TextStyle(
                            color: const Color.fromARGB(116, 158, 158, 158)),
                        prefixStyle: TextStyle(
                          color: Colors.white,
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(15, 255, 255, 255)),
                  ),
                  Visibility(
                    visible: isActive,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "OTP Code",
                          style: TextStyle(
                            color: const Color.fromARGB(127, 255, 255, 255),
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _otpController,
                          maxLength: 6,
                          style: TextStyle(color: Colors.white),
                          autofocus: true,
                          decoration: InputDecoration(
                            suffix: buttonComponent(
                              btnTextColor: Color.fromARGB(200, 111, 190, 255),
                              btnName: "Resend",
                              onPressed: () {
                                phoneAuthentication();
                              },
                            ),
                            hintText: "1 5 9 7 6 2",
                            hintStyle: TextStyle(
                                color:
                                    const Color.fromARGB(116, 158, 158, 158)),
                            prefixStyle: TextStyle(
                              color: Colors.white,
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(15, 255, 255, 255),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  isActive
                      ? buttonComponent(
                          onPressed: () {
                            signInWithPhoneNumber();
                          },
                          btnName: "Verify OTP",
                          btnTextColor:
                              const Color.fromARGB(255, 237, 237, 237),
                          btnColor: Color.fromARGB(200, 111, 190, 255),
                        )
                      : buttonComponent(
                          onPressed: () {
                            phoneAuthentication();
                          },
                          btnName: "Next",
                          btnTextColor:
                              const Color.fromARGB(255, 237, 237, 237),
                          btnColor: Color.fromARGB(200, 111, 190, 255),
                        ),
                ],
              ),
            )),
          ],
        ),
      ]),
    );
  }
}

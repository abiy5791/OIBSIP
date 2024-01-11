// ignore_for_file: prefer_const_constructors, camel_case_types, non_constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../clock_view.dart';

class clockpage extends StatefulWidget {
  const clockpage({super.key});

  @override
  State<clockpage> createState() => _clockpageState();
}

class _clockpageState extends State<clockpage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startContinuousUpdate();
  }

  void startContinuousUpdate() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer in the dispose() method
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formattedTime = DateFormat('hh:mm').format(now);
    var am_pm = DateFormat('a').format(now);
    var formattedDate = DateFormat('EEE, d MMM').format(now);
    return Scaffold(
      backgroundColor: Color(0xFFFFFBF5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Clock",
                  style: TextStyle(
                      fontSize: 40,
                      color: Color(0xFF3A4D39),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      formattedTime,
                      style: TextStyle(
                        color: Color(0xFF3A4D39),
                        fontSize: 40,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      am_pm,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  formattedDate,
                  style: TextStyle(
                    color: Color(0xFF3A4D39),
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
              child: ClockView(
            size: MediaQuery.of(context).size.height / 3,
          )),
        ],
      ),
    );
  }
}

// ignore_for_file: camel_case_types, prefer_final_fields, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';

import '../components/buttonComponent.dart';

class timerpage extends StatefulWidget {
  const timerpage({super.key});

  @override
  State<timerpage> createState() => _timerpageState();
}

class _timerpageState extends State<timerpage> {
  bool _isRunning = false;
  Timer? _timer;
  int _seconds = 0;
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds == 0) {
          _seconds;
        } else {
          _seconds--;
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _resetTimer() {
    setState(() {
      _seconds = 0;
    });
  }

  void _setTimer() {
    int minutes = int.tryParse(_controller.text) ?? 0;
    setState(() {
      _seconds = minutes * 60;
    });
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds ~/ 60) % 60;
    int remainingSeconds = seconds % 60;
    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return '$hoursStr:$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFBF5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                'Timer',
                style: TextStyle(
                    color: Color(0xFF3A4D39),
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 4,
            ),
            Column(
              children: [
                Text(
                  _formatTime(_seconds),
                  style: TextStyle(
                    fontSize: 48.0,
                    color: Color(0xFF3A4D39),
                  ),
                ),
                SizedBox(height: 5.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 100.0),
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Set minutes',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _seconds == 0
                        ? buttonComponent(
                            btnName: "SetTimer",
                            btnColor: Color(0xFFDDDDDD),
                            btnTextColor: Color(0xFF3A4D39),
                            onPressed: () {
                              _setTimer();
                              _controller.clear();
                            },
                          )
                        : buttonComponent(
                            btnName: "Reset",
                            btnColor: Color(0xFFB5F1CC),
                            btnTextColor: Color(0xFF3A4D39),
                            onPressed: () {
                              _resetTimer();
                            },
                          ),
                    SizedBox(
                      width: 15,
                    ),
                    !_isRunning
                        ? buttonComponent(
                            btnName: "Start",
                            btnColor: Color(0xFF85CDFD),
                            btnTextColor: Color(0xFF3A4D39),
                            onPressed: () {
                              if (!_isRunning) {
                                _startTimer();
                                setState(() {
                                  _isRunning = true;
                                });
                              }
                            },
                          )
                        : buttonComponent(
                            btnName: "Stop",
                            btnColor: Color(0xFFF24C3D),
                            btnTextColor: Colors.white,
                            onPressed: () {
                              if (_isRunning) {
                                _stopTimer();
                                setState(() {
                                  _isRunning = false;
                                });
                              }
                            },
                          )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

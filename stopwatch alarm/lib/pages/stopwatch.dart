// ignore_for_file: camel_case_types, prefer_final_fields, prefer_const_constructors

import 'package:alarm/components/buttonComponent.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class stopwatchpage extends StatefulWidget {
  const stopwatchpage({super.key});

  @override
  State<stopwatchpage> createState() => _stopwatchpageState();
}

class _stopwatchpageState extends State<stopwatchpage> {
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  Duration _elapsedTime = Duration.zero;
  List<String> _laps = [];

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        _elapsedTime = _stopwatch.elapsed;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _resetTimer() {
    setState(() {
      _stopwatch.reset();
      _elapsedTime = Duration.zero;
      _laps.clear();
    });
  }

  void _captureLap() {
    setState(() {
      _laps.insert(0, _formatElapsedTime(_elapsedTime));
    });
  }

  String _formatElapsedTime(Duration duration) {
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    String milliseconds =
        ((duration.inMilliseconds % 1000) ~/ 10).toString().padLeft(2, '0');
    return '$minutes:$seconds:$milliseconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFBF5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text(
              'Stopwatch',
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
                _formatElapsedTime(_elapsedTime),
                style: TextStyle(
                  fontSize: 48.0,
                  color: Color(0xFF3A4D39),
                ),
              ),
              SizedBox(height: 25.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _stopwatch.isRunning
                      ? buttonComponent(
                          btnName: "Stop",
                          btnColor: Color(0xFFF24C3D),
                          btnTextColor: Colors.white,
                          onPressed: () {
                            if (_stopwatch.isRunning) {
                              _stopwatch.stop();
                              _stopTimer();
                            }
                          },
                        )
                      : buttonComponent(
                          btnName: "Start",
                          btnColor: Color(0xFF85CDFD),
                          btnTextColor: Color(0xFF3A4D39),
                          onPressed: () {
                            if (!_stopwatch.isRunning) {
                              _startTimer();
                              _stopwatch.start();
                            }
                          },
                        ),
                  SizedBox(
                    width: 20,
                  ),
                  !_stopwatch.isRunning
                      ? buttonComponent(
                          btnName: "Reset",
                          btnColor: Color(0xFFB5F1CC),
                          btnTextColor: Color(0xFF3A4D39),
                          onPressed: () {
                            _resetTimer();
                          },
                        )
                      : buttonComponent(
                          btnName: "Lap",
                          btnColor: Color(0xFFDDDDDD),
                          btnTextColor: Color(0xFF3A4D39),
                          onPressed: () {
                            _captureLap();
                          },
                        )
                ],
              ),
            ],
          ),
          SizedBox(height: 12.0),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _laps.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    'Lap ${index + 1}: ${_laps[index]}',
                    style: TextStyle(
                        color: Color(0xFF3A4D39), fontWeight: FontWeight.w500),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

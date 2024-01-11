// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'package:alarm/pages/alarm.dart';
import 'package:alarm/pages/clock.dart';
import 'package:alarm/pages/stopwatch.dart';
import 'package:alarm/pages/timer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  void _navigatebottom(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = [clockpage(), AlarmPage(), timerpage(), stopwatchpage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: _navigatebottom,
          currentIndex: _selectedIndex,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          selectedItemColor: Color(0xFF3A4D39),
          items: [
            BottomNavigationBarItem(
                backgroundColor: Color(0xFFD2E3C8),
                icon: Icon(
                  Icons.access_time,
                  size: 30,
                  color: Color(0xFF0C356A),
                ),
                label: "Clock"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.alarm,
                  size: 30,
                  color: Color(0xFF0C356A),
                ),
                label: "Alarm"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.timer_outlined,
                  size: 30,
                  color: Color(0xFF0C356A),
                ),
                label: "Timer"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.timer_off_outlined,
                  size: 30,
                  color: Color(0xFF0C356A),
                ),
                label: "StopWatch"),
          ]),
    );
  }
}

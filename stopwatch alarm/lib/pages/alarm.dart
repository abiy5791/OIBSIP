// ignore_for_file: prefer_const_constructors, sort_child_properties_last, avoid_print, prefer_const_declarations, prefer_interpolation_to_compose_strings, prefer_final_fields, sized_box_for_whitespace, non_constant_identifier_names

import 'dart:convert';
import 'package:alarm/database/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'dart:async';
import 'package:hive/hive.dart';
part 'alarm.g.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final _mybox = Hive.box('mybox');
  AlarmDB _alarmDB = AlarmDB();

  TextEditingController _controller = TextEditingController();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    if (_mybox.get("AlarmList") == null) {
      _alarmDB.InitialData();
    } else {
      _alarmDB.LoadData();
    }
    startContinuousUpdate();
    super.initState();
    // Initialize the local notifications plugin
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final settingsAndroid = AndroidInitializationSettings('logo');
    final initializationSettings =
        InitializationSettings(android: settingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Timer? _timer;

  void startContinuousUpdate() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    FlutterRingtonePlayer.stop();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formattedTime = DateFormat('hh:mm').format(now);
    var am_pm = DateFormat('a').format(now);

    return Scaffold(
      backgroundColor: Color(0xFFFFFBF5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Alarm",
                    style: TextStyle(
                        color: Color(0xFF3A4D39),
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Current Time " + formattedTime + " " + am_pm,
                    style: TextStyle(
                        color: Color(0xFF3A4D39), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _alarmDB.alarmsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return alarmComponent(_alarmDB.alarmsList[index], index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFEBF3E8),
        onPressed: () {
          _showAddAlarmDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _scheduleNotification(Alarm alarm) async {
    final title =
        'Your Alarm is ready ' + DateFormat('hh:mm a').format(alarm.time);
    final body = alarm.description;

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_channel', // Use your chosen channel ID
      'Alarm Notifications', // Use your chosen channel name
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationDetails =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      alarm.id,
      title,
      body,
      notificationDetails,
      payload: jsonEncode(<String, dynamic>{'alarm_id': alarm.id}),
    );
  }

  void _showAddAlarmDialog() {
    DateTime selectedTime = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Alarm'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Time:'),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: 'Alarm description',
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () async {
                    TimeOfDay? timeOfDay = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(selectedTime),
                    );
                    if (timeOfDay != null) {
                      setState(() {
                        selectedTime = DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          timeOfDay.hour,
                          timeOfDay.minute,
                        );
                      });
                    }
                  },
                  child: Text(
                    DateFormat('hh:mm a').format(selectedTime),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  int id = _alarmDB.alarmsList.length + 1;
                  _alarmDB.alarmsList.add(Alarm(
                    id: id,
                    time: selectedTime,
                    description: _controller.text,
                    isActive: true,
                  ));

                  // Start the timer
                  _timer?.cancel();
                  _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
                    if (DateTime.now().hour == selectedTime.hour &&
                        DateTime.now().minute == selectedTime.minute) {
                      _playRingtone();

                      // Schedule the notification
                      _scheduleNotification(_alarmDB.alarmsList.last);
                      t.cancel();
                    }
                  });
                });
                _alarmDB.update_db();
                Navigator.pop(context);
                _controller.clear();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _playRingtone() {
    FlutterRingtonePlayer.play(
      android: AndroidSounds.alarm,
      ios: IosSounds.glass,
      looping: true,
      volume: 1.0,
    );
  }

  Widget alarmComponent(Alarm alarm, int index) {
    String formattedTime = DateFormat('hh:mm a').format(alarm.time);
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.only(top: 5, bottom: 5, right: 15, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  alarm.isActive
                      ? Icon(
                          Icons.alarm_on_outlined,
                          color: Color(0xFF164863),
                        )
                      : Icon(
                          Icons.alarm_off_outlined,
                          color: Color(0xFF164863),
                        ),
                  SizedBox(
                    width: 5,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      // Set a fixed width to limit the width of the text container
                      width: 200, // Adjust this value as needed
                      child: Text(
                        alarm.description,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF164863),
                        ),
                        maxLines: 1, // Limit to a single line
                        overflow: TextOverflow
                            .ellipsis, // Add an ellipsis (...) when text overflows
                      ),
                    ),
                  )
                ],
              ),
              Switch(
                value: alarm.isActive,
                onChanged: (value) {
                  setState(() {
                    alarm.isActive = value;
                  });
                  _alarmDB.update_db();
                  if (value == false) {
                    FlutterRingtonePlayer.stop();
                  } else {
                    _timer?.cancel();
                    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
                      if (DateTime.now().hour == alarm.time.hour &&
                          DateTime.now().minute == alarm.time.minute) {
                        _playRingtone();
                        t.cancel();
                      }
                    });
                  }
                },
                activeColor: Color(0xFF427D9D),
                inactiveThumbColor: Color(0xFFDDF2FD),
              ),
            ],
          ),
          Text(
            "Mon - Fri",
            style: TextStyle(
              color: Color(0xFF164863),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedTime,
                style: TextStyle(
                  fontSize: 25,
                  color: Color(0xFF164863),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Are you sure !\n You want to delete this alarm.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3A4D39),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _alarmDB.alarmsList.removeAt(
                                              index); // Remove the alarm from the alarms list
                                        });
                                        _alarmDB.update_db();
                                        FlutterRingtonePlayer.stop();
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Delete",
                                        style:
                                            TextStyle(color: Color(0xFFF24C3D)),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel"))
                                ],
                              )
                            ],
                          ),
                        );
                      });
                },
                child: Icon(
                  Icons.delete_outline,
                  color: Color(0xFFF24C3D),
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
      height: 125,
      decoration: BoxDecoration(
        color: alarm.isActive
            ? Color(0xFFEBF3E8)
            : Color.fromARGB(166, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

@HiveType(typeId: 0)
class Alarm {
  @HiveField(0)
  int id;

  @HiveField(1)
  DateTime time;

  @HiveField(2)
  String description;

  @HiveField(3)
  bool isActive;

  Alarm({
    required this.id,
    required this.time,
    required this.description,
    required this.isActive,
  });
}

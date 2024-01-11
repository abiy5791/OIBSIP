// ignore_for_file: prefer_const_constructors, avoid_print, unused_local_variable

import 'package:alarm/homepage.dart';
import 'package:alarm/pages/alarm.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AlarmAdapter()); // Register the adapter
  var box = await Hive.openBox('mybox');
  WidgetsFlutterBinding.ensureInitialized();
  // Check and request notification permissions
  Map<Permission, PermissionStatus> statuses = await [
    Permission.notification, // Request notification permission
  ].request();

  if (statuses[Permission.notification]!.isGranted) {
    runApp(MyApp());
  } else {
    // Handle the case where permission is not granted
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyAlarm',
      home: HomePage(),
    );
  }
}

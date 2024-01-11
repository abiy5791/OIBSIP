// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/Pages/HomePage.dart';
import 'package:todo/Pages/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo/utils/snackbarUtils.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDk9jHv9hFJi1zi6F_I_vGD-kaYn0b3bIg",
      appId: "367414543134",
      messagingSenderId: "1:367414543134:android:deeacbe3ea679e0d833f0f",
      projectId: "todo-fd09b",
    ),
  );

  await Hive.initFlutter();

  var box = await Hive.openBox('mybox');
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: utils.messengerKey,
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return Center(
            //     child: CircularProgressIndicator(),
            //   );
            // } else if (snapshot.hasError) {
            //   return Center(
            //     child: Text("Something went wrong!"),
            //   );
            // }
            if (snapshot.hasData) {
              return HomePage();
            } else {
              return LoginPage();
            }
          }),
    );
  }
}

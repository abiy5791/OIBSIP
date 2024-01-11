// ignore_for_file: non_constant_identifier_names

import 'package:hive_flutter/hive_flutter.dart';

class AlarmDB {
  List alarmsList = [];
  final _mybox = Hive.box('mybox');

  void InitialData() {
    // 1st time ever opening this app we look this
    alarmsList = [];
  }

  // Load Data

  void LoadData() {
    alarmsList = _mybox.get("AlarmList");
  }

  // updata the data

  void update_db() {
    _mybox.put("AlarmList", alarmsList);
  }
}

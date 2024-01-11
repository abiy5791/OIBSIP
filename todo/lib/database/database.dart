import 'package:hive_flutter/hive_flutter.dart';

class Todo_db {
  List ToDoList = [];
  final _mybox = Hive.box('mybox');

  void InitialData() {
    // 1st time ever opening this app we look this
    ToDoList = [
      ["Make Homework", "i will work my homework tonignt", false],
      ["Walking", "i will walk at 7am for 30 min", false]
    ];
  }

  // Load Data

  void LoadData() {
    ToDoList = _mybox.get("TODOLIST");
  }

  // updata the data

  void update_db() {
    _mybox.put("TODOLIST", ToDoList);
  }
}

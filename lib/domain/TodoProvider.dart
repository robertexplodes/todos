import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasetodos/domain/todo.dart';
import 'package:flutter/cupertino.dart';

class TodoProvider with ChangeNotifier {

  final _todos = <Todo>[];


  void completeTodoIndex(int index) {
    _todos[index].completed = true;
    notifyListeners();
  }

  void completeTodo(Todo todo) {
    todo.completed = true;
    notifyListeners();
  }
}
import 'package:firebasetodos/domain/todo.dart';
import 'package:flutter/cupertino.dart';

class TodoProvider with ChangeNotifier {

  final todos = <Todo>[];

  void addTodo(Todo todo) {
    todos.add(todo);
    notifyListeners();
  }

  void completeTodoIndex(int index) {
    todos[index].completed = true;
    notifyListeners();
  }

  void completeTodo(Todo todo) {
    todo.completed = true;
    notifyListeners();
  }
}
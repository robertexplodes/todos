import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasetodos/domain/todo.dart';
import 'package:flutter/cupertino.dart';

class TodoProvider with ChangeNotifier {



  var _todos = <Todo>[];

  final firestore = FirebaseFirestore.instance;

  late final _documentStream =
      firestore.collection('users').doc('3BIxVCSwl8jXUMuW6JKc').snapshots();

  Stream<DocumentSnapshot> get documentStream => _documentStream;

  List<Todo> get todos => _todos;

  List<Todo> todosByState(bool completed) => _todos.where((todo) => todo.completed == completed).toList();


  void completeTodoIndex(int index) async {
    todos[index].completed = !todos[index].completed;
    await setDatabase();
    notifyListeners();
  }

  void addTodo(Todo todo) async {
    _todos.add(todo);
    await setDatabase();
    notifyListeners();
  }

  Future<List<Todo>> _loadTodos() async {
    return await firestore.collection("users").doc("3BIxVCSwl8jXUMuW6JKc").get().then((value) {
      return (value.data()?["todos"] as List<dynamic>)
          .map((e) => Todo.fromJson(e))
          .toList();
    });
  }

  setDatabase() async {
    List<Map<String, dynamic>> jsonTodos =
        _todos.map((e) => e.toJson()).toList();

    await firestore.collection("users").doc("3BIxVCSwl8jXUMuW6JKc").set({
      "todos": jsonTodos,
    });
  }

  void init() async {
    await _loadTodos().then((value) => _todos = value);
  }
}

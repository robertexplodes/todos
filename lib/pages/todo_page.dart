import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasetodos/domain/todo.dart';
import 'package:firebasetodos/widgets/list.dart';
import 'package:flutter/material.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final firestore = FirebaseFirestore.instance;

  List<Todo> todos = [];

  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Todos'),
        ),
        body: Column(
          children: [
            TextField(
              controller: controller,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  addTodo();
                },
                child: Icon(Icons.add),
              ),
            ),
            Expanded(
              child: TodoList(
                firestore: firestore,
                todos: todos,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addTodo() {
    setState(() {
      todos = [...todos, Todo(controller.text, false)];
    });
    var jsonString = todos.map((todo) => todo.toJson()).toList();
    firestore.collection("users").doc("3BIxVCSwl8jXUMuW6JKc").set({
      "todos": jsonString,
    });
    controller.clear();
  }
}
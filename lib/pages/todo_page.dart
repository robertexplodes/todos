import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasetodos/domain/todo.dart';
import 'package:firebasetodos/pages/completed_todos.dart';
import 'package:firebasetodos/widgets/drawer.dart';
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

  var documentStream = FirebaseFirestore.instance
      .collection('users')
      .doc('3BIxVCSwl8jXUMuW6JKc')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: TodoDrawer(),
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Form(
                  child: TextFormField(
                    controller: controller,

                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      if (value.isNotEmpty) {
                        addTodo();
                      }
                    },
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  addTodo();
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: documentStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var foundTodos = (snapshot.data?.get("todos") as List<dynamic>)
                    .map((e) => Todo.fromJson(e))
                    .toList();

                todos = foundTodos;
                return TodoList(
                  todos: todos,
                  deleteAt: deleteAt,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void addTodo() {
    todos.add(Todo(controller.text, false));
    var jsonString = todos.map((todo) => todo.toJson()).toList();
    firestore.collection("users").doc("3BIxVCSwl8jXUMuW6JKc").set({
      "todos": jsonString,
    });
    controller.clear();
  }

  void deleteAt(int index) async {
    todos[index].completed = true;
    List<Map<String, dynamic>> jsonTodos =
        todos.map((e) => e.toJson()).toList();
    await firestore
        .collection("users")
        .doc("3BIxVCSwl8jXUMuW6JKc")
        .set({"todos": jsonTodos});
  }
}

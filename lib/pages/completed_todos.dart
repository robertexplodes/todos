import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasetodos/domain/todo.dart';
import 'package:firebasetodos/widgets/list.dart';
import 'package:flutter/material.dart';

class CompletedTodos extends StatefulWidget {
  const CompletedTodos({Key? key}) : super(key: key);

  static const String route = '/completed';

  @override
  _CompletedTodosState createState() => _CompletedTodosState();
}

class _CompletedTodosState extends State<CompletedTodos> {
  List<Todo> todos = [];

  var firestore = FirebaseFirestore.instance;

  late var documentStream = firestore
      .collection('users')
      .doc('3BIxVCSwl8jXUMuW6JKc')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Todos'),
      ),
      body: Container(
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
              deleteAt: (index) async {
                todos[index].completed = false;
                List<Map<String, dynamic>> jsonTodos =
                    todos.map((e) => e.toJson()).toList();
                await firestore
                    .collection("users")
                    .doc("3BIxVCSwl8jXUMuW6JKc")
                    .set({"todos": jsonTodos});
              },
              showCompleted: true,
            );
          },
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasetodos/domain/todo_provider.dart';
import 'package:firebasetodos/widgets/todo_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompletedTodos extends StatefulWidget {
  const CompletedTodos({Key? key}) : super(key: key);

  static const String route = '/completed';

  @override
  _CompletedTodosState createState() => _CompletedTodosState();
}

class _CompletedTodosState extends State<CompletedTodos> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Todos'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: Provider.of<TodoProvider>(context).documentStream,
        builder: (context, snapshot) {
          return TodoList(
            deleteAt: (index) async {
              Provider.of<TodoProvider>(context).completeTodoIndex(index);
            },
            showCompleted: true,
          );
        },
      ),
    );
  }
}

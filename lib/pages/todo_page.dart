import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasetodos/domain/todo.dart';
import 'package:firebasetodos/pages/completed_todos.dart';
import 'package:firebasetodos/widgets/drawer.dart';
import 'package:firebasetodos/widgets/todo_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/todo_provider.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {

  var controller = TextEditingController();

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
              stream: Provider.of<TodoProvider>(context).documentStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return TodoList(
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
    Provider.of<TodoProvider>(context, listen: false).addTodo(Todo(controller.text, false));
    controller.clear();
  }

  void deleteAt(int index) async {
    Provider.of<TodoProvider>(context).completeTodoIndex(index);
  }
}

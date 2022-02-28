import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasetodos/domain/todo.dart';
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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const TodoDrawer(),
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          callAddTodoModal();
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
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

  void callAddTodoModal() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Add todo',
                      ),
                      autofocus: true,
                      validator: (value) {
                        return validateInput(value);
                      },
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      handleSubmit(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      Provider.of<TodoProvider>(context, listen: false)
          .addTodo(Todo(controller.text, false));
      controller.clear();
      Navigator.pop(context);
    }
  }

  String? validateInput(String? value) {
    if (value == null) return null;
    if (value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  void deleteAt(int index) async {
    Provider.of<TodoProvider>(context).completeTodoIndex(index);
  }
}

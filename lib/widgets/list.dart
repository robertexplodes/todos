import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasetodos/domain/todo.dart';
import 'package:flutter/material.dart';

class TodoList extends StatefulWidget {
  List<Todo> todos;
  final FirebaseFirestore firestore;

  TodoList({Key? key, required this.todos, required this.firestore})
      : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  var documentStream = FirebaseFirestore.instance
      .collection('users')
      .doc('3BIxVCSwl8jXUMuW6JKc')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: documentStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        var foundTodos = (snapshot.data?.get("todos") as List<dynamic>)
            .map((e) => Todo.fromJson(e as Map<String, dynamic>))
            .toList();

        widget.todos = foundTodos;

        return ListView.builder(
          itemBuilder: (context, index) {
            return Dismissible(
              key: GlobalKey(),
              child: Container(
                padding: EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                height: 50,
                child: Text(foundTodos[index].title),
                color: Colors.white,
              ),
              background: Container(
                padding: EdgeInsets.only(left: 16),
                color: Colors.red,
                alignment: Alignment.centerLeft,
                child: const Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
              ),
              onDismissed: (direction) {
                deleteAt(index);
              },
              direction: DismissDirection.startToEnd,
            );
          },
          itemCount: foundTodos.length,
        );
      },
    );
  }

  void deleteAt(int index) async {
    widget.todos[index].completed = true;
    await widget.firestore
        .collection("users")
        .doc("3BIxVCSwl8jXUMuW6JKc")
        .set({"todos": widget.todos});
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasetodos/domain/todo.dart';
import 'package:flutter/material.dart';

class TodoList extends StatefulWidget {
  List<Todo> todos;
  final FirebaseFirestore firestore;
  final Function(int index) deleteAt;
  final Function(List<Todo> todos) setTodos;

  TodoList(
      {Key? key,
      required this.todos,
      required this.firestore,
      required this.deleteAt,
      required this.setTodos})
      : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Dismissible(
          key: GlobalKey(),
          child: Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            width: double.infinity,
            height: 50,
            child: Text(widget.todos[index].title),
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
            widget.deleteAt(index);
          },
          direction: DismissDirection.startToEnd,
        );
      },
      itemCount: widget.todos.length,
    );
  }
}

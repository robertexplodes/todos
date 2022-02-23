import 'package:firebasetodos/domain/todo.dart';
import 'package:flutter/material.dart';

class TodoList extends StatelessWidget {
  final List<Todo> todos;
  final Function(int index) deleteAt;
  const TodoList({Key? key, required this.todos, required this.deleteAt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if(todos[index].completed) {
          return const SizedBox();
        }
        return Dismissible(
          key: GlobalKey(),
          child: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            width: double.infinity,
            height: 50,
            child: Text(todos[index].title),
            color: Colors.white,
          ),
          background: Container(
            padding: const EdgeInsets.only(left: 16),
            color: Colors.green,
            alignment: Alignment.centerLeft,
            child: const Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
          onDismissed: (direction) {
            deleteAt(index);
          },
          direction: DismissDirection.startToEnd,
        );
      },
      itemCount: todos.length,
    );
  }
}

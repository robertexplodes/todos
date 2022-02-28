import 'package:firebasetodos/widgets/dismissible_background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/todo_provider.dart';

class TodoList extends StatelessWidget {
  final Function(int index) deleteAt;
  final bool showCompleted;

  const TodoList({Key? key, required this.deleteAt, this.showCompleted = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var todos = Provider.of<TodoProvider>(context).todos;
    return ListView.builder(
      itemBuilder: (context, index) {
        if (!showCompleted && todos[index].completed ||
            showCompleted && !todos[index].completed) {
          return const SizedBox();
        }
        return Dismissible(
          key: GlobalKey(),
          child: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            width: double.infinity,
            height: 50,
            child: Row(children: [
              CircleAvatar(
                backgroundColor:
                    todos[index].completed ? Colors.grey : Colors.blue,
                radius: 5,
              ),
              const SizedBox(width: 10),
              Text(
                todos[index].title,
                style: todos[index].completed
                    ? const TextStyle(
                        decoration: TextDecoration.lineThrough,
                      )
                    : null,
              ),
            ]),
            color: Colors.white,
          ),
          background: DismissibleBackground(completed: showCompleted),
          secondaryBackground: Container(
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  Text(
                    'Move to trash',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              Provider.of<TodoProvider>(context, listen: false).delete(index);
            } else {
              Provider.of<TodoProvider>(context, listen: false)
                  .completeTodoIndex(index);
            }
          },
          direction: showCompleted
              ? DismissDirection.horizontal
              : DismissDirection.startToEnd,
        );
      },
      itemCount: todos.length,
    );
  }
}

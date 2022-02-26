import 'package:firebasetodos/domain/todo.dart';
import 'package:flutter/material.dart';

class TodoList extends StatelessWidget {
  final List<Todo> todos;
  final Function(int index) deleteAt;
  final bool showCompleted;

  const TodoList(
      {Key? key,
      required this.todos,
      required this.deleteAt,
      this.showCompleted = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (!showCompleted && todos[index].completed || showCompleted && !todos[index].completed) {
          return const SizedBox();
        }
        return Dismissible(
          key: GlobalKey(),
          child: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            width: double.infinity,
            height: 50,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: todos[index].completed ? Colors.grey : Colors.blue,
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
              ),]
            ),
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
            // TODO: fix this
            if(direction == DismissDirection.endToStart) {
              deleteAt(index);
            } else {
              todos[index].completed = !todos[index].completed;
            }
          },
          direction: showCompleted ? DismissDirection.horizontal : DismissDirection.startToEnd,
        );
      },
      itemCount: todos.length,
    );
  }
}

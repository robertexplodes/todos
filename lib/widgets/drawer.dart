import 'package:flutter/material.dart';

import '../pages/completed_todos.dart';

class TodoDrawer extends StatelessWidget {
  const TodoDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Todo List'),
          ),
          ListTile(
            title: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Todos'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).popAndPushNamed(CompletedTodos.route);
            },
            child: const Text('Completed Todos'),
          ),
        ],
      ),
    );
  }
}

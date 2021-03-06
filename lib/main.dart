import 'package:firebasetodos/domain/todo_provider.dart';
import 'package:firebasetodos/pages/completed_todos.dart';
import 'package:firebasetodos/pages/todo_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: const TodoApp(),
    ),
  );
}

class TodoApp extends StatefulWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  @override
  Widget build(BuildContext context) {
    Provider.of<TodoProvider>(context).init();
    return MaterialApp(
      routes: {
        '/': (context) => const TodoPage(),
        CompletedTodos.route: (context) => const CompletedTodos(),
      },
      title: 'TodoApp',
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(TodoApp());
}

class TodoApp extends StatefulWidget {
  TodoApp({Key? key}) : super(key: key);

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final firestore = FirebaseFirestore.instance;

  List<String> todos = [];

  void _loadMessages() async {
    var query = firestore.collection("users").doc("3BIxVCSwl8jXUMuW6JKc");
    var found = await query.get().then((value) =>
        (value.get("todos") as List<dynamic>).map((e) => e as String).toList());
    setState(() {
      todos = found;
    });
  }

  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _loadMessages();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Todos'),
        ),
        body: Column(
          children: [
            TextField(
              controller: controller,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  firestore
                      .collection("users")
                      .doc("3BIxVCSwl8jXUMuW6JKc")
                      .set({
                    "todos": [...todos, controller.text]
                  });
                  controller.clear();
                },
                child: Icon(Icons.add),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(todos[index]),
                  );
                },
                itemCount: todos.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

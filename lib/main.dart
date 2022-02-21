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
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
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
                  addTodo();
                },
                child: Icon(Icons.add),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: ValueKey(index),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      height: 50,
                      child: Text(todos[index]),
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
                itemCount: todos.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addTodo() {
    setState(() {
      todos = [...todos, controller.text];
    });
    firestore
        .collection("users")
        .doc("3BIxVCSwl8jXUMuW6JKc")
        .set({
      "todos": todos,
    });
    controller.clear();
  }

  void deleteAt(int index) {
    setState(() {
      todos.removeAt(index);
    });
    firestore
        .collection("users")
        .doc("3BIxVCSwl8jXUMuW6JKc")
        .set({"todos": todos});
  }
}

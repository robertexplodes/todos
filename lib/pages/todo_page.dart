import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasetodos/domain/todo.dart';
import 'package:firebasetodos/widgets/list.dart';
import 'package:flutter/material.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final firestore = FirebaseFirestore.instance;

  List<Todo> todos = [];

  var controller = TextEditingController();

  var documentStream = FirebaseFirestore.instance
      .collection('users')
      .doc('3BIxVCSwl8jXUMuW6JKc')
      .snapshots();

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
              child: StreamBuilder<DocumentSnapshot>(
                stream: documentStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  var foundTodos =
                      (snapshot.data?.get("todos") as List<dynamic>)
                          .map((e) => Todo.fromJson(e))
                          .toList();

                  todos = foundTodos;

                  return ListView.builder(
                    itemBuilder: (context, index) {
                      if(todos[index].completed) {
                        return SizedBox();
                      }
                      return Dismissible(
                        key: GlobalKey(),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          alignment: Alignment.centerLeft,
                          width: double.infinity,
                          height: 50,
                          child: Text(todos[index].title),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addTodo() {
    todos.add(Todo(controller.text, false));
    var jsonString = todos.map((todo) => todo.toJson()).toList();
    print(jsonString);
    firestore.collection("users").doc("3BIxVCSwl8jXUMuW6JKc").set({
      "todos": jsonString,
    });
    controller.clear();
  }

  void deleteAt(int index) async {
    todos[index].completed = true;
    List<Map<String, dynamic>> jsonTodos =
        todos.map((e) => e.toJson()).toList();
    await firestore
        .collection("users")
        .doc("3BIxVCSwl8jXUMuW6JKc")
        .set({"todos": jsonTodos});
  }
}

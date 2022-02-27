import 'package:flutter/material.dart';

class DismissibleBackground extends StatelessWidget {
  final bool completed;
  const DismissibleBackground({Key? key, required this.completed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      color: completed ? Colors.deepOrangeAccent : Colors.green,
      alignment: Alignment.centerLeft,
      child: Icon(
        completed ? Icons.undo : Icons.check,
        color: Colors.white,
      ),
    );
  }
}

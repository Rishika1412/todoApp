import 'package:flutter/material.dart';

import '../model/todo.dart';

class TodoItem extends StatelessWidget {
  TodoItem({
    required this.todo,
    required this.onTodoChanged,
    required this.onClicked,
  }) : super(key: ObjectKey(todo));

  final Todo todo;
  final onTodoChanged;
  final onClicked;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        onTap: () {
          onTodoChanged(todo);
        },
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade300,
          child: Text(
            todo.name[0],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(todo.name, style: _getTextStyle(todo.checked)),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: () {
            onClicked(todo);
          },
        ),
      ),
    );
  }
}

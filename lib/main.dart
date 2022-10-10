import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:todo/screens/todolist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = '2pERbYIqQYBSIU8Zeqj6PC1V1rxuH4udRHIzV9Ai';
  final keyClientKey = 'ZZ5iO41840FJXFp9UVMv9g74NuclkyLokr0AjLqt';
  final keyParseServerUrl = 'https://parseapi.back4app.com';
  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      home: TodoListWidget(),
    );
  }
}

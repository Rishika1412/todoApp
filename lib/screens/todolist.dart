import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:todo/screens/todoitem.dart';
import '../model/todo.dart';

class TodoListWidget extends StatefulWidget {
  const TodoListWidget({Key? key}) : super(key: key);

  @override
  State<TodoListWidget> createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  final TextEditingController _textFieldController = TextEditingController();
  final List<Todo> _todos = <Todo>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        title: const Text('Todo App'),
      ),
      body: FutureBuilder<List<ParseObject>>(
        future: getdata(),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Container(
                  height: 100,
                  width: 100,
                  child: const CircularProgressIndicator(
                    color: Colors.teal,
                  ),
                ),
              );
            default:
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Error..."),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Text("No Data..."),
                );
              } else {
                return ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final vartodo = snapshot.data![index];
                      final varname = vartodo.get<String>('Entry')!;
                      final state = vartodo.get<bool>('Done')!;
                      Todo todo = Todo(name: varname, checked: state);
                      return TodoItem(
                        todo: todo,
                        onTodoChanged: () =>
                            _handleTodoChange(todo, vartodo.objectId!, state),
                        onClicked: () => _deleteTodo(vartodo.objectId!),
                        // () async {
                        //   var mytodo = ParseObject('appdata')
                        //     ..objectId = vartodo.objectId!;

                        //   await mytodo
                        //       .delete()
                        //       .then((value) => setState(() {}));
                        // }
                      );
                    });
              }
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          onPressed: () => _displayDialog(),
          tooltip: 'Add Item',
          child: const Icon(Icons.add)),
    );
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new todo item'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Type your new todo'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(_textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addTodoItem(String name) async {
    setState(() {
      _todos.add(Todo(name: name, checked: false));
    });

    // you can add the code for creating a row for db and sending to the db here.

    final mytodo = ParseObject('appdata')
      ..set('Done', false)
      ..set('Entry', name);

    await mytodo.save();
    setState(() {});
    _textFieldController.clear();
  }

  Future<List<ParseObject>> getdata() async {
    QueryBuilder<ParseObject> queryTodo =
        QueryBuilder<ParseObject>(ParseObject('appdata'));
    final ParseResponse apiResponse = await queryTodo.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<void> _handleTodoChange(Todo todo, String id, bool done) async {
    setState(() {
      todo.checked = !todo.checked;
    });

    //you can add the code for updating the db and setting the done column to true here
    var mytodo = ParseObject('appdata')
      ..objectId = id
      ..set('Done', !done);

    await mytodo.save();
  }

  Future<void> _deleteTodo(String id) async {
    //you can write the code here for deleting the entry from db.
    var mytodo = ParseObject('appdata')..objectId = id;
    await mytodo.delete();
    setState(() {});
  }
}

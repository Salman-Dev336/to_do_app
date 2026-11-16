import 'package:flutter/material.dart';
import 'package:to_do_app/utils/dialog_box.dart';
import 'package:to_do_app/utils/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //text controller
  final _controller = TextEditingController();

  final List<List<Object>> toDoList = [
    ["make tutorial", false,],
    ["Do exercise", false],
    ['build a todo app', false],

  ];
  //method for checkbox changed
  void checkBoxChanged(bool? value, int index){
    setState((){
    toDoList[index][1] = value ?? false;
    });
  }

  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
  }

  //method for saving new task

  void saveNewTask(){
    setState(() {
      toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
  }

  // methiod for creating new task
  void createTask(){
    showDialog(
      context: context,
      builder: (context){
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: ()=> Navigator.of(context).pop(),
        );

      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: Text('TO DO'),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          createTask();

        },
        child: Icon(Icons.add_card_sharp),
        ),
      body: ListView.builder(
        itemCount: toDoList.length,
        itemBuilder:(context, index){
          return ToDoTile(
            taskName: toDoList[index][0] as String,
            taskCompleted: toDoList[index][1] as bool,
            onDelete: () => deleteTask(index),
            onChanged: (value) {
              checkBoxChanged(value, index);
            },
          );
        },
      ),
    );
  }
}

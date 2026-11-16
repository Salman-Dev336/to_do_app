import 'package:flutter/material.dart';
import 'package:to_do_app/utils/dialog_box.dart';
import 'package:to_do_app/utils/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List toDoList = [
    ["make tutorial", false,],
    ["Do exercise", false],
    ['build a todo app', false],

  ];
  //method for checkbox changed
  void checkBoxChanged(bool? value, int index){
    setState((){
      toDoList[index][1] = !toDoList[index][1];
    });
  }

  // methiod for creating new task
  void createTask(){
    showDialog(
      context: context,
      builder: (context){
        return DialogBox();

      },
    );
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
            taskName: toDoList[index][0],
            taskCompleted: toDoList[index][1],
            onChanged:(value)=>{
              checkBoxChanged(value, index),
            }
          );
        },
      ),
    );
  }
}
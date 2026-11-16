import 'package:flutter/material.dart';

class ToDoTile extends StatelessWidget {

  final String taskName;
  final bool taskCompleted;

  Function(bool?)? onChanged;



  ToDoTile({super.key, required this.taskName, required this.taskCompleted, required this.onChanged,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, left:10, right: 10),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [

              // check box
              Checkbox(
                value: taskCompleted,
                 onChanged: onChanged,
              activeColor: Colors.green[700],
              ),

              //task Name
              Text(
                taskName,
                style:TextStyle(
                  decoration: taskCompleted? TextDecoration.lineThrough : TextDecoration.none,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(15)
          
        ),
      ),
    );
  }
}
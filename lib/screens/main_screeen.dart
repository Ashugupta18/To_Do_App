import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/data/database.dart';
import 'package:to_do_app/screens/dialog_bos.dart';
import 'listpage.dart';
import 'package:get/get.dart';

// ignore: camel_case_types
class Main_Screen extends StatefulWidget {
  const Main_Screen({super.key});

  @override
  State<Main_Screen> createState() => _Main_ScreenState();
}

// ignore: camel_case_types
class _Main_ScreenState extends State<Main_Screen> {
  //reference to hive box

  final _myBox = Hive.openBox('mybox');
  ToDoDataBase db = ToDoDataBase();

  // @override
  // void initState() {
  //   // if this is the 1st time ever openin the app, then create default data
  //   if (_myBox.get("TODOLIST") == null) {
  //     db.createInitialData();
  //   } else {
  //     // there already exists data
  //     db.loadData();
  //   }

  //   super.initState();
  // }

  final _controller = TextEditingController();

//check box Click
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDolist[index][1] = !db.toDolist[index][1];
    });
    db.updateDataBase();
  }

// for save task
  void savedNewTask() {
    setState(() {
      db.toDolist.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

// create new task

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: savedNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

// For Delete task
  void deleteTask(int index) {
    setState(() {
      db.toDolist.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        title: const Center(child: Text('T O D O   A P P')),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.deepPurple[300],
        child: const Icon(
          Icons.add,
        ),
      ),
      body: ListView.builder(
        itemCount: db.toDolist.length,
        itemBuilder: (context, index) {
          return ToDoList(
            taskName: db.toDolist[index][0],
            taskCompleted: db.toDolist[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}

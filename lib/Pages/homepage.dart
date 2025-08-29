import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:todo_app/Services/dbhelper.dart';
import 'package:todo_app/Services/todomodal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final todoController = TextEditingController();
  Future<List<ToDoModal>>? data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshNotes();
  }

  refreshNotes() {
    data = Dbhelper.instance.GetToDo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "To Do",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            Text("ist", style: TextStyle(color: Colors.white54, fontSize: 30)),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          show(
            context,
            ButtonText: 'Add To Do',
            bottomsheetheading: 'Add To Do',
            textfieldhint: 'Add To Do',
            isUpdate: false,
          );
        },
        backgroundColor: Colors.teal,
        child: Icon(Icons.add_task_sharp, color: Colors.white),
      ),
      body: FutureBuilder<List<ToDoModal>>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.teal));
          } else if (!snapshot.hasData) {
            return Center(child: Text("No To Do Added !!!"));
          } else {
            final dataa = snapshot.data;
            return ListView.builder(
              itemCount: dataa!.length,
              itemBuilder: (context, index) {
                bool isddd = dataa[index].isdone == 1 ? true : false;
                return Card(
                  color: const Color.fromARGB(255, 148, 180, 173),
                  child: ListTile(
                    title: Text(
                      dataa[index].todo.toString(),
                      style: isddd == false
                          ? TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            )
                          : TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                              decoration: TextDecoration.lineThrough,
                            ),
                    ),
                    onLongPress: () {
                      Dbhelper.instance.deleteToDo(
                        ToDoModal(id: dataa[index].id),
                      );
                      refreshNotes();
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () {
                          todoController.text = dataa[index].todo.toString();
                          show(
                            context,
                            ButtonText: 'Edit To Do',
                            bottomsheetheading: 'Edit To Do',
                            modal: ToDoModal(
                              id: dataa[index].id,
                              todo: dataa[index].todo,
                              isdone: dataa[index].isdone,
                            ),
                            isUpdate: true,
                          );
                        },
                        icon: Icon(Icons.edit),
                        color: Colors.green,
                      ),
                    ),
                    trailing: Checkbox(
                      value: dataa[index].isdone == 1 ? true : false,
                      onChanged: (bool? value) {
                        Dbhelper.instance.updateToDo(
                          ToDoModal(
                            id: dataa[index].id,
                            todo: dataa[index].todo,
                            isdone: value == false ? 0 : 1,
                          ),
                        );
                        setState(() {
                          dataa[index].isdone = value == true ? 1 : 0;
                        });
                      },
                      activeColor: Colors.red, // color when checked
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void show(
    BuildContext contextt, {
    required String bottomsheetheading,
    String? textfieldhint,
    required String ButtonText,
    ToDoModal? modal,
    bool? isUpdate,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: contextt,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: 200, // Adjust height as needed
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      bottomsheetheading,
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: todoController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: textfieldhint,
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        isUpdate == true
                            ? Dbhelper.instance.updateToDo(
                                ToDoModal(
                                  id: modal!.id,
                                  todo: todoController.text,
                                  isdone: modal.isdone,
                                ),
                              )
                            : Dbhelper.instance.insertToDo(
                                ToDoModal(todo: todoController.text),
                              );
                        refreshNotes();
                        todoController.clear();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      child: Text(
                        ButtonText,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

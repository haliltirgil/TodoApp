import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app/loading.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/db_services.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isCompleted = false;
  TextEditingController todoContentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: StreamBuilder<List<Todo>>(
            stream: DatabaseService().listTodos(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              }

              List<Todo> todos = snapshot.data;

              return Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height / 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Yapılacaklar Listesi",
                      style: GoogleFonts.mcLaren(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height / 22,
                      ),
                    ),
                    Divider(color: Colors.yellow),
                    SizedBox(height: MediaQuery.of(context).size.height / 500),
                    ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.blueGrey,
                      ),
                      shrinkWrap: true,
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          background: Container(
                            color: Colors.orange,
                            padding: EdgeInsets.only(left: 20),
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          key: Key(todos[index].content),
                          onDismissed: (direction) async {
                            await DatabaseService()
                                .removeTodo(todos[index].uid);
                          },
                          child: ListTile(
                              onTap: () {
                                DatabaseService()
                                    .completedTodo(todos[index].uid);
                              },
                              leading: Container(
                                height: MediaQuery.of(context).size.height / 25,
                                width: MediaQuery.of(context).size.height / 25,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    shape: BoxShape.circle),
                                child: todos[index].isCompleted
                                    ? Icon(Icons.check, color: Colors.white)
                                    : Container(),
                              ),
                              title: Text(
                                todos[index].content,
                                style: GoogleFonts.mcLaren(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.height /
                                            38),
                              )),
                        );
                      },
                    )
                  ],
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.orangeAccent,
        onPressed: () {
          showDialog(
            builder: (context) => SimpleDialog(
              contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 30),
              backgroundColor: Colors.grey[700],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Text(
                    "To-do Ekleyin",
                    style: GoogleFonts.mcLaren(color: Colors.white),
                  ),
                  Spacer(),
                  IconButton(
                      icon: Icon(Icons.cancel, color: Colors.orange, size: 35),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ),
              children: [
                Divider(),
                TextFormField(
                  controller: todoContentController,
                  style: GoogleFonts.mcLaren(
                      fontSize: 18, height: 0.2, color: Colors.white),
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Bir şeyler yazın...",
                    hintStyle: GoogleFonts.mcLaren(color: Colors.white60),
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: FlatButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      if (todoContentController.text.isNotEmpty) {
                        await DatabaseService()
                            .createNewTodo(todoContentController.text.trim());
                        Navigator.pop(context);
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Ekle",
                      style: GoogleFonts.mcLaren(
                          fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20)
              ],
            ),
            context: context,
          );
        },
      ),
    );
  }
}

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/AddrUpdate.dart';
import 'package:todo/details.dart';
import 'package:todo/models/task.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext taskscontext) {
    return MaterialApp(
      title: 'Todo App',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isSelected = false;
  final List<Task> tasks = List<Task>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        actions: <Widget>[
          !isSelected
              ? Container()
              : Row(children: <Widget>[
                  // IconButton(
                  //   icon: Icon(Icons.arrow_back),
                  //   onPressed: () {
                  //     setState(() {
                  //       isSelected = false;
                  //     });
                  //   },
                  // ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteTasks();
                    },
                  )
                ])
        ],
      ),
      body: todoList(context),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            Task task = await Navigator.of(context)
                .push(MaterialPageRoute<Task>(builder: (BuildContext context) {
              return new AddorUpdate(null);
            }));
            if (task != null) {
              addTask(task);
            }
          }),
    );
  }

  Widget todoList(BuildContext context) {
    sortList();
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute<Null>(builder: (BuildContext context) {
                return new Details(todo: tasks[index]);
              }));
              setState(() {
                _deselectTasks();
              });
            },
            onLongPress: () {
              // _showDialog(tasks[index],context);
              setState(() {
                isSelected = true;
                tasks[index].isChecked = true;
              });
            },
            child: new Card(
              child: Slidable(
                delegate: new SlidableDrawerDelegate(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 3,
                      height: 50,
                      decoration: BoxDecoration(
                          color: _containerColor(tasks[index].priority)),
                    ),
                    Expanded(
                      child: Container(
                        padding: linePadding(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              tasks[index].taskName,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            Padding(
                              padding: linePadding(3.0),
                            ),
                            Text(
                              EnumToString.parse(tasks[index].status),
                            ),
                          ],
                        ),
                      ),
                    ),
                    !isSelected
                        ? Container()
                        : Container(
                            child: Align(
                              child: Checkbox(
                                value: tasks[index].isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    tasks[index].isChecked = value;
                                  });
                                },
                                activeColor: Colors.blue,
                              ),
                            ),
                            width: 40.0,
                          )
                  ],
                ),
                secondaryActions: <Widget>[
                  new IconSlideAction(
                      icon: Icons.edit,
                      color: Colors.black38,
                      onTap: () async {
                        Task task = await Navigator.of(context).push(
                            MaterialPageRoute<Task>(
                                builder: (BuildContext context) {
                          return new AddorUpdate(tasks[index]);
                        }));
                        if (task != null) {
                          updateTask(task, index);
                        }
                      }),
                  new IconSlideAction(
                    icon: Icons.cancel,
                    onTap: () {
                      _showDialog(tasks[index], context);
                    },
                    color: Colors.red,
                  ),
                ],
              ),
            ));
      },
    );
  }

  addTask(task) {
    setState(() {
      tasks.add(task);
    });
    _deselectTasks();
  }

  removeTask(Task task) {
    setState(() {
      tasks.remove(task);
    });
  }

  updateTask(Task task, int index) {
    for (var i = 0; i < tasks.length; i++) {
      if (i == index) {
        tasks[i] = task;
      }
    }
    _deselectTasks();
  }

  sortList() {
    tasks.sort((a, b) => a.priority.index.compareTo(b.priority.index));
  }

  _showDialog(task, context) {
    showDialog(
      context: context,
      builder: (context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert !"),
          content: new Text("Are you sure you want to delete?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                removeTask(task);
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                _deselectTasks();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _deleteTasks() {
    var todos = [];
    tasks.forEach((todo) {
      if (todo.isChecked) {
        todos.add(todo);
      }
    });
    todos.forEach((todo) {
      tasks.remove(todo);
    });
    _deselectTasks();
  }

  _deselectTasks() {
    setState(() {
      isSelected = false;
      tasks.forEach((todo) => todo.isChecked ? todo.isChecked = false : null);
    });
  }

  Color _containerColor(priority) {
    switch (priority) {
      case Priority.High:
        return Colors.red;
      case Priority.Medium:
        return Colors.yellow;
      default:
        return Colors.green;
    }
  }
}

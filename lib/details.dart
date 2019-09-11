import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo/models/task.dart';
import 'package:enum_to_string/enum_to_string.dart';

class Details extends StatelessWidget {
  final Task todo;

  const Details({Key key, this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.taskName),
      ),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Description : ', style: textStyle(20.0, FontWeight.w500)),
              Text(todo.description, style: textStyle(18.0, FontWeight.w400)),
              Padding(padding: linePadding(5.0)),
              Text('Task End Date : ', style: textStyle(20.0, FontWeight.w500)),
              Text(todo.taskDate.toString().substring(0, 10),
                  style: textStyle(18.0, FontWeight.w400)),
              Padding(padding: linePadding(5.0)),
              Text('Status : ', style: textStyle(20.0, FontWeight.w500)),
              Text(EnumToString.parse(todo.status),
                  style: textStyle(18.0, FontWeight.w400)),
              Padding(padding: linePadding(5.0)),
              Text('Priority : ', style: textStyle(20.0, FontWeight.w500)),
              Text(EnumToString.parse(todo.priority),
                  style: textStyle(18.0, FontWeight.w400)),
            ],
          )),
    );
  }
}

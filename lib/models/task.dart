import 'package:flutter/material.dart';

class Task {
  String taskName;
  String description;
  Status status;
  Priority priority;
  DateTime taskDate;
  bool isChecked = false;
}

enum Status{
  Not_Started,
  In_Progress,
  Completed
}

enum Priority{
  High,
  Medium,
  Low
}

 TextStyle textStyle(size,weight){
    return TextStyle(fontSize: size,fontWeight: weight);
  }

  EdgeInsetsGeometry linePadding(value){
    return EdgeInsets.all(value);
  }
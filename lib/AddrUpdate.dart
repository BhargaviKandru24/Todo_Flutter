import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/models/task.dart';

class AddorUpdate extends StatelessWidget {
  final Task task;
  AddorUpdate(this.task);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task != null ? 'Update Todo' : 'Add Todo'),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(padding: linePadding(16.0), child: AddForm(task)),
    );
  }
}

class AddForm extends StatefulWidget {
  AddForm(this.task);
  final Task task;
  _AddFormState createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  var _task = new Task();
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var formFields = <Widget>[
      TextFormField(
        decoration: InputDecoration(labelText: 'Task Name'),
        initialValue: widget.task != null ? widget.task.taskName : '',
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter Task Name';
          }
          return null;
        },
        onSaved: (val) => _task.taskName = val,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Description'),
        initialValue: widget.task != null ? widget.task.description : '',
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter description';
          }
          return null;
        },
        onSaved: (val) => _task.description = val,
      ),
      new DropdownButtonFormField<Status>(
          value: (widget.task != null && _task.status == null)
              ? widget.task.status
              : _task.status,
          onChanged: (Status newValue) {
            setState(() {
              _task.status = newValue;
            });
          },
          onSaved: (val) => _task.status = val,
          validator: (value) {
            if (value == null) {
              return 'Please Select Status';
            }
            return null;
          },
          decoration: InputDecoration(labelText: 'Status'),
          items: Status.values.map((Status classType) {
            return new DropdownMenuItem<Status>(
                value: classType,
                child: new Text(
                  EnumToString.parse(classType),
                  overflow: TextOverflow.ellipsis,
                ));
          }).toList()),
      GestureDetector(
        onTap: () {
          _selectDate(context);
        },
        child: AbsorbPointer(
          child: new TextFormField(
            decoration: new InputDecoration(labelText: 'Task Date'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter Task Date';
              }
              return null;
            },
            controller: new TextEditingController(
                text: (widget.task != null && _task.taskDate == null)
                    ? _dateFormat(widget.task.taskDate)
                    : _dateFormat(selectedDate)),
            onSaved: (val) => _task.taskDate = selectedDate,
          ),
        ),
      ),
      new DropdownButtonFormField<Priority>(
          value: (widget.task != null && _task.priority == null)
              ? widget.task.priority
              : _task.priority,
          onChanged: (Priority newValue) {
            setState(() {
              _task.priority = newValue;
            });
          },
          decoration: InputDecoration(labelText: 'Priority'),
          validator: (value) {
            if (value == null) {
              return 'Please Select Priority';
            }
            return null;
          },
          onSaved: (val) => _task.priority = val,
          items: Priority.values.map((Priority classType) {
            return new DropdownMenuItem<Priority>(
                value: classType,
                child: new Text(
                  EnumToString.parse(classType),
                  overflow: TextOverflow.ellipsis,
                ));
          }).toList()),
      Padding(
        padding:  linePadding( 16.0),
        child: RaisedButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              Navigator.of(context).pop(_task);
            }
          },
          child: Text('Save'),
        ),
      ),
    ];
    return Form(
        key: _formKey,
        child: Column(
          children: formFields,
        ));
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      firstDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      initialDate: selectedDate,
      lastDate: DateTime(2020, 9),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _task.taskDate = selectedDate;
      });
    }
  }

  String _dateFormat(DateTime date) {
    return date.toString().substring(0, 10);
  }
}

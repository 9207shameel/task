import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CalendarController _calendarController;
  late Map<DateTime, List<Task>> _tasksMap;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _tasksMap = {};
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
      ),
      body: Column(
        children: [
          TableCalendar(
            calendarController: _calendarController,
            onDaySelected: (date, events, holidays) {
              setState(() {
                // Update UI based on selected date
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasksMap[_calendarController.selectedDay]?.length ?? 0,
              itemBuilder: (context, index) {
                Task task = _tasksMap[_calendarController.selectedDay][index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteTask(index);
                    },
                  ),
                  onTap: () {
                    _editTask(task, index);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                RaisedButton(
                  child: Text('Add Task'),
                  onPressed: () {
                    _addTask();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addTask() {
    if (_titleController.text.isNotEmpty) {
      Task newTask = Task(_titleController.text, _descriptionController.text);
      DateTime selectedDay = _calendarController.selectedDay;
      if (_tasksMap.containsKey(selectedDay)) {
        _tasksMap[selectedDay].add(newTask);
      } else {
        _tasksMap[selectedDay] = [newTask];
      }
      setState(() {
        _titleController.clear();
        _descriptionController.clear();
      });
    }
  }

  void _editTask(Task task, int index) {
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
            ],
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            FlatButton(
              onPressed: () {
                _updateTask(index);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _updateTask(int index) {
    Task updatedTask = Task(_titleController.text, _descriptionController.text);
    DateTime selectedDay = _calendarController.selectedDay;
    _tasksMap[selectedDay][index] = updatedTask;
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
    });
  }

  void _deleteTask(int index) {
    DateTime selectedDay = _calendarController.selectedDay;
    _tasksMap[selectedDay].removeAt(index);
    setState(() {});
  }

  @override
  void dispose() {
    _calendarController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

  }





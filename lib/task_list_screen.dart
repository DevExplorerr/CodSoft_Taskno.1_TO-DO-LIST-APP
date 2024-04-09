import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/constants/colors.dart';
import 'package:to_do_app/task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  Priority _priority = Priority.Low;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tasks = (prefs.getStringList('tasks') ?? []).map((task) {
        List<String> taskDetails = task.split('|');
        DateTime? dueDate;
        if (taskDetails[4].isNotEmpty) {
          dueDate = DateTime.parse(taskDetails[4]);
        }
        return Task(
          title: taskDetails[0],
          description: taskDetails[1],
          isCompleted: taskDetails[2] == 'true' ? true : false,
          priority: Priority.values[int.parse(taskDetails[3])],
          dueDate: dueDate,
        );
      }).toList();
    });
  }

  void _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasksList = tasks.map((task) {
      return '${task.title}|${task.description}|${task.isCompleted}|${task.priority.index}|${task.dueDate}';
    }).toList();
    prefs.setStringList('tasks', tasksList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tgbackground,
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: tgpurple,
        title: Text(
          'To-Do App',
          style: GoogleFonts.jost(
              color: tgwhite, fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tasks[index].title),
            subtitle: Text(tasks[index].description),
            trailing: Checkbox(
              value: tasks[index].isCompleted,
              onChanged: (value) {
                setState(() {
                  tasks[index].isCompleted = value!;
                  _saveTasks();
                });
              },
            ),
            onTap: () {
              _showTaskDetailsDialog(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: tgpurple,
        onPressed: _showAddTaskDialog,
        child: Icon(
          Icons.add,
          color: tgwhite,
          size: 23,
        ),
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add Task',
            style: GoogleFonts.jost(
                color: tgpurple, fontSize: 25, fontWeight: FontWeight.w500),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  style: TextStyle(color: tgblack),
                  keyboardType: TextInputType.text,
                  controller: _titleController,
                  decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(color: tggrey, fontSize: 16)),
                ),
                TextField(
                  style: TextStyle(color: tgblack),
                  keyboardType: TextInputType.text,
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      labelText: 'Detail (Optional)',
                      labelStyle: TextStyle(color: tggrey, fontSize: 16)),
                ),
                DropdownButton<Priority>(
                  value: _priority,
                  onChanged: (value) {
                    setState(() {
                      _priority = value!;
                    });
                  },
                  items: Priority.values.map((Priority priority) {
                    return DropdownMenuItem<Priority>(
                      value: priority,
                      child: Text(priority.toString().split('.').last),
                    );
                  }).toList(),
                ),
                TextButton(
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && picked != _selectedDate)
                      setState(() {
                        _selectedDate = picked;
                      });
                  },
                  child: Text(
                      _selectedDate != null
                          ? 'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}'
                          : 'Select Due Date',
                      style: GoogleFonts.jost(
                          color: tgpurple, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.jost(
                    fontSize: 15, fontWeight: FontWeight.w500, color: tgpurple),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  setState(() {
                    tasks.add(Task(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      isCompleted: false,
                      priority: _priority,
                      dueDate: _selectedDate,
                    ));
                    _titleController.clear();
                    _descriptionController.clear();
                    _priority = Priority.Low;
                    _selectedDate = null;
                    _saveTasks();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'Add',
                style: GoogleFonts.jost(
                    color: tgpurple, fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showTaskDetailsDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Task Details',
            style: GoogleFonts.jost(
                color: tgpurple, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title: ${tasks[index].title}'),
                Text('Description: ${tasks[index].description}'),
                Text(
                    'Priority: ${tasks[index].priority.toString().split('.').last}'),
                Text(
                    'Due Date: ${tasks[index].dueDate != null ? DateFormat('yyyy-MM-dd').format(tasks[index].dueDate!) : 'N/A'}'),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 1),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _showEditTaskDialog(index);
                          },
                          child: Text(
                            'Edit',
                            style: GoogleFonts.jost(
                                color: tgpurple,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 1),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              tasks.removeAt(index);
                              _saveTasks();
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Delete',
                            style: GoogleFonts.jost(
                                color: tgpurple,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditTaskDialog(int index) {
    _titleController.text = tasks[index].title;
    _descriptionController.text = tasks[index].description;
    _priority = tasks[index].priority;
    _selectedDate = tasks[index].dueDate!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit Task',
            style: GoogleFonts.jost(
                color: tgpurple, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  style: TextStyle(color: tgblack),
                  decoration: InputDecoration(
                      labelText: 'Title', labelStyle: TextStyle(color: tggrey)),
                ),
                TextField(
                  controller: _descriptionController,
                  style: TextStyle(color: tgblack),
                  decoration: InputDecoration(
                      labelText: 'Detail',
                      labelStyle: TextStyle(color: tggrey)),
                ),
                DropdownButton<Priority>(
                  value: _priority,
                  onChanged: (value) {
                    setState(() {
                      _priority = value!;
                    });
                  },
                  items: Priority.values.map((Priority priority) {
                    return DropdownMenuItem<Priority>(
                      value: priority,
                      child: Text(priority.toString().split('.').last),
                    );
                  }).toList(),
                ),
                TextButton(
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && picked != _selectedDate)
                      setState(() {
                        _selectedDate = picked;
                      });
                  },
                  child: Text(
                      _selectedDate != null
                          ? 'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}'
                          : 'Select Due Date',
                      style: GoogleFonts.jost(
                          color: tgpurple, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel',
                  style: GoogleFonts.jost(
                      color: tgpurple,
                      fontSize: 15,
                      fontWeight: FontWeight.w500)),
            ),
            TextButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  setState(() {
                    tasks[index].title = _titleController.text;
                    tasks[index].description = _descriptionController.text;
                    tasks[index].priority = _priority;
                    tasks[index].dueDate = _selectedDate;
                    _titleController.clear();
                    _descriptionController.clear();
                    _priority = Priority.Low;
                    _saveTasks();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'Save',
                style: GoogleFonts.jost(
                    color: tgpurple, fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
      },
    );
  }
}

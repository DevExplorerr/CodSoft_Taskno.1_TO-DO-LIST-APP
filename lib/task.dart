class Task {
  String title;
  String description;
  bool isCompleted;
  DateTime? dueDate;
  Priority priority;

  Task({
    required this.title,
    required this.isCompleted,
    required this.priority,
    this.description = '',
    this.dueDate,
  });
}

enum Priority { Low, Medium, High }

class Task {
  int id;
  String title;
  String description;
  String time;
  bool done;
  int day;
  int importance;

  Task({
    required this.title,
    required this.time,
    required this.description,
    required this.day,
    required this.importance,
    required this.done,
    required this.id,
  });
}

class Todo {
  final int id;
  final String title;
  late final DateTime createdAt;
  DateTime? finishedAt;
  bool finished = false;

  Todo({required this.id, required this.title}) {
    createdAt = DateTime.now();
  }

  finishTodo() {
    finishedAt = DateTime.now();
    finished = !finished;
  }
}

class Todo {
  String title;
  bool completed;

  Todo(this.title, this.completed);

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(json['title'], json['completed']);
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'completed': completed};
  }
}
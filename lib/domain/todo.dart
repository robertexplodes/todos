class Todo {
  String title;
  bool completed;

  Todo(this.title, this.completed);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['completed'] = completed;
    return data;
  }

  Todo.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        completed = json['completed'];

}
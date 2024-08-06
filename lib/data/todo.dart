class Todo{
  final String title;
  final String description;
  bool isDone;

  Todo({
    required this.title,
    required this.description,
    this.isDone = false,
  });

  Todo copyWith({
    String? title,
    String? description,
    bool? isDone,
  }) {
    return Todo(
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      description: json['description'],
      isDone: json['isDone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }
  @override
  String toString() {
    return '''Todo:{
    title: $title\n
    description: $description\n
    isDone: $isDone\n
    }''';
  }
}
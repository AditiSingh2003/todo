part of 'todo_bloc.dart';

enum TodoStatus { initial, loading, success, error }

class TodoState extends Equatable {
  final List<Todo> todos;
  final TodoStatus status;

  const TodoState({
    this.todos = const <Todo>[],
    this.status = TodoStatus.initial,
  });

  TodoState copyWith({
    List<Todo>? todos,
    TodoStatus? status,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      status: status ?? this.status,
    );
  }

  factory TodoState.fromJson(Map<String, dynamic> json) {
    try {
      var listOfTodos = (json['todos'] as List)
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList();

      return TodoState(
        todos: listOfTodos,
        status: TodoStatus.values.firstWhere(
          (element) => element.name == json['status'],
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'todos': todos.map((todo) => todo.toJson()).toList(),
      'status': status.name,
    };
  }

  @override
  List<Object?> get props => [todos, status];
}

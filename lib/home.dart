import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/bloc/todo_bloc.dart';
import 'data/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDarkTheme = false;

  // Define the custom colors
  final Color lightLavender = Color(0xFFB57EDC); // Light lavender color
  final Color darkLavender = Color.fromARGB(255, 125, 44, 200);  // Dark lavender color
  final Color primaryColor = Color(0xFFB57EDC); // Primary color for FloatingActionButton

  // text colors 
  Color get textColor => _isDarkTheme ? Colors.white : Colors.black;
  Color get backgroundColor => _isDarkTheme ? Colors.black.withOpacity(0.5) : Colors.white;
  Color get cardColor => _isDarkTheme ? darkLavender : lightLavender;
  Color get appBarColor => _isDarkTheme ? darkLavender : primaryColor;
  Color get appBarTextColor => _isDarkTheme ? Colors.white : Colors.black;

  // switch colors
  Color get switchThumbColor => _isDarkTheme ? Colors.white : Colors.black;
  Color get switchTrackColor => _isDarkTheme ? Colors.grey[700]! : Colors.grey[300]!;

  late TextEditingController controller1;
  late TextEditingController controller2;

  @override
  void initState() {
    super.initState();
    controller1 = TextEditingController();
    controller2 = TextEditingController();

    controller1.addListener(_updateFormState);
    controller2.addListener(_updateFormState);
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  void addTodo(Todo todo) {
    context.read<TodoBloc>().add(AddTodo(todo: todo));
  }

  void removeTodo(Todo todo) {
    context.read<TodoBloc>().add(RemoveTodo(todo: todo));
  }

  void alertTodo(int index) {
    context.read<TodoBloc>().add(AlterTodo(index: index));
  }

  bool _isFormValid() {
    return controller1.text.isNotEmpty;  // Validation only on task title
  }

  void _updateFormState() {
    setState(() {});
  }

  //Completed Task Dialogbox
  void _showCompletedTasks(BuildContext context, List<Todo> todos) {
    showDialog(
      context: context,
      builder: (context) {
        List<Todo> completedTodos = todos.where((todo) => todo.isDone).toList();
        return AlertDialog(
          backgroundColor: _isDarkTheme ? Colors.grey[900] : Colors.white,
          title: Text(
            'Completed Tasks',
            style: TextStyle(color: textColor),
          ),
          content: completedTodos.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: completedTodos.map((todo) {
                    return Slidable(
                      key: ValueKey(todo.title),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) {
                              setState(() {
                                removeTodo(todo);
                                Navigator.of(context).pop();
                                _showCompletedTasks(context, todos);
                              });
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(todo.title, style: TextStyle(color: textColor)),
                        subtitle: Text(todo.description, style: TextStyle(color: textColor)),
                      ),
                    );
                  }).toList(),
                )
              : Text(
                  'No completed tasks.',
                  style: TextStyle(color: textColor),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // add task pop menu 
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add a Task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: controller1,
                      cursorColor: primaryColor,
                      decoration: InputDecoration(
                        hintText: 'Task Title...',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controller2,
                      cursorColor: primaryColor,
                      decoration: InputDecoration(
                        hintText: 'Task Description...',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),

                //adding functionality to the button
                actions: [
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: TextButton(
                      onPressed: _isFormValid()
                          ? () {
                              addTodo(Todo(
                                title: controller1.text,
                                description: controller2.text,
                              ));
                              controller1.clear();
                              controller2.clear();
                              Navigator.pop(context);
                            }
                          : null,
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: primaryColor),
                        ),
                        foregroundColor: primaryColor,
                        backgroundColor: _isFormValid() ? primaryColor : Colors.grey,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Icon(
                          CupertinoIcons.check_mark,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        title: Text(
          'My ToDo App',
          style: TextStyle(
            color: appBarTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Switch(
            value: _isDarkTheme,
            onChanged: (value) {
              setState(() {
                _isDarkTheme = value;
              });
            },
            activeColor: switchThumbColor,
            inactiveTrackColor: switchTrackColor,
            inactiveThumbColor: switchThumbColor,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              
              //bloc builer
              child: BlocBuilder<TodoBloc, TodoState>(
                builder: (context, state) {
                  if (state.status == TodoStatus.success) {
                    final activeTodos = state.todos.where((todo) => !todo.isDone).toList();
                    return ListView.builder(
                      itemCount: activeTodos.length,
                      itemBuilder: (context, int i) {
                        return Card(
                          color: cardColor,
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Slidable(
                            key: ValueKey(activeTodos[i].title),
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (_) {
                                    removeTodo(activeTodos[i]);
                                  },
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                activeTodos[i].title,
                                style: TextStyle(color: textColor),
                              ),
                              subtitle: Text(
                                activeTodos[i].description,
                                style: TextStyle(color: textColor),
                              ),
                              trailing: Checkbox(
                                value: activeTodos[i].isDone,
                                activeColor: Colors.lightGreen,
                                onChanged: (value) {
                                  alertTodo(state.todos.indexOf(activeTodos[i]));
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state.status == TodoStatus.initial) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<TodoBloc>(context).state.status == TodoStatus.success
                      ? _showCompletedTasks(context, BlocProvider.of<TodoBloc>(context).state.todos)
                      : null;
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: primaryColor,
                ),
                child: const Text('Show Completed Tasks'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

  addTodo(Todo todo){
    context.read<TodoBloc>().add(
      AddTodo(todo: todo),
    );
  }

  removeTodo(Todo todo){
    context.read<TodoBloc>().add(
      RemoveTodo( todo: todo),
    );
  }

  alertTodo(int index){
    context.read<TodoBloc>().add(
      AlterTodo(index: index)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(context: context, builder: (context){

            TextEditingController controller1 = TextEditingController();
            TextEditingController controller2 = TextEditingController();

            return AlertDialog(
              title: const Text(
                'Add a Task'
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller1,
                    cursorColor:  Colors.lightGreen,
                    decoration: InputDecoration(
                      hintText: 'Task Title...',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.lightGreen,
                        )
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.grey
                        )
                      )
                    ),
                  ),
                  const SizedBox(height:10),
                  TextField(
                    controller: controller2,
                    cursorColor: Colors.lightGreen,
                    decoration: InputDecoration(
                      hintText: 'Task DEscription...',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.lightGreen,
                        )
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.grey
                        )
                      )
                    ),
                  ),
              ],
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: TextButton(
                    onPressed: (){
                      addTodo(
                        Todo(title: controller1.text, 
                        description: controller2.text),
                      );
                      controller1.text = '';
                      controller2.text = '';
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.lightGreen,),),
                        foregroundColor: Colors.lightGreen
                        ,
                      ),

                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Icon(
                          CupertinoIcons.check_mark,
                          color: Colors.green,
                        ),
                        )
                    ),
                  ),
              ],
            );
          });
        },
        backgroundColor: Color(0xFF569DAA),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        )
        ),

        appBar: AppBar(
          backgroundColor: Color(0xFF569DAA),
          elevation: 0,
          title: const Text(
            'My ToDo App',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state){
                if(state.status == TodoStatus.success){
                  return ListView.builder(
                    itemCount: state.todos.length,
                    itemBuilder: (context, int i){
                      return Card(
                        color: Color(0xFF569DAA),
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Slidable(
                          key: const ValueKey(0),
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children:[
                              SlidableAction(
                                onPressed:(_){
                                  removeTodo(state.todos[i]);
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              )
                            ]
                          ), child: ListTile(
                            title: Text(
                              state.todos[i].title
                            ),
                            subtitle: Text(
                              state.todos[i].description
                            ),
                            trailing: Checkbox(
                              value: state.todos[i].isDone,
                              activeColor: Colors.lightGreen,
                              onChanged: (value){
                                alertTodo(i);
                              },
                            )
                            ),
                        ),
                      );
                    }
                    );
                }
                else if (state.status == TodoStatus.initial){
                  return const Center(child: CircularProgressIndicator());
                }
                else{
                  return Container();
                }
              },
              ),
          ),
    );
  }
}
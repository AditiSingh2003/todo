import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/bloc/todo_bloc.dart';
import 'package:todo/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          background: Colors.white,
          onBackground: Colors.black,
          primary: Color(0xFF569DAA),
          onPrimary: Colors.black,
          secondary: Colors.lightGreen,
          onSecondary: Colors.white
        ),
      ),
      home: BlocProvider<TodoBloc>(
        create: (context) => TodoBloc()..add(TodoStarted()),
        child:const HomeScreen(),
        ),
    );
  }
}

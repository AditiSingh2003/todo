import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/bloc/todo_bloc.dart';
import 'package:todo/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  HydratedBloc.storage = storage;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodoBloc>(
      create: (context) => TodoBloc()..add(TodoStarted()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        // theme: ThemeData(
        //   colorScheme: const ColorScheme.light(
        //     background: Colors.white,
        //     onBackground: Colors.black,
        //     primary: Color(0xFF569DAA),
        //     onPrimary: Colors.black,
        //     secondary: Colors.lightGreen,
        //     onSecondary: Colors.white,
        //   ),
        // ),
        home: const HomeScreen(),
      ),
    );
  }
}

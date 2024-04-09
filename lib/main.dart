import 'package:flutter/material.dart';
import 'package:to_do_app/splash_screen.dart';
import 'package:to_do_app/task_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        'todo-page': (context) => TaskListScreen(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:untitled/responsive/app/todo/todo_screen_mobile.dart';
import 'package:untitled/responsive/app/todo/todo_screen_web.dart';
import '../../responsive_layout.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: const TodoPageMobile(),
        desktopBody: const TodoPageWeb(),
      ),
    );
  }
}

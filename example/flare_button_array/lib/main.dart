import 'package:flutter/material.dart';
///our newly created Class
import 'options_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      ///set our new home here
      home: OptionsView(),
    );
  }
}


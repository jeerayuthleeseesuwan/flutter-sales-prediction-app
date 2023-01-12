import 'package:flutter/material.dart';
import 'package:prediciton_model/views/lockScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prediction Mobile App',
      theme: ThemeData(
        fontFamily: "Montserrat",
        primaryColor: Colors.blue[300],
        primarySwatch: Colors.blue,
      ),
      home: LockScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

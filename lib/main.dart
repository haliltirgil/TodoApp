import 'package:flutter/material.dart';
import 'package:todo_app/screens/main_screen.dart';
import 'package:todo_app/loading.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text(snapshot.error.toString())),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: MainScreen(),
            theme: ThemeData(primarySwatch: Colors.orange),
          );
        });
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mensa_meet_app/sections/auth_home_wrapper.dart';
import 'sections/home//homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthHomeWrapper(),
      theme: ThemeData(
        //primarySwatch: Colors.deepOrange,
        //brightness: Brightness.dark 
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Home extends StatelessWidget {
  const Home({super.key});



  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Flutter layout demo';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        backgroundColor: HexColor("F3EBDD"),
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: HexColor("F3EBDD"),
          title: Padding(
            padding: const EdgeInsets.only(top:15,left:15),
            child: Image.asset('assets/Logo.png')
          ),

        ),
        body: Container(
          width: 300,
          height: 300,
          color: HexColor("ffffff"),
          child: Center(
            child: Text("this")
          )
        )
      ),
    );
  }
}

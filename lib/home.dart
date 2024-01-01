import 'package:flutter/material.dart';

class Home extends StatefulWidget{
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() =>_HomeState();
}

class _HomeState extends State<Home>{
  DateTime _dateTime = DateTime.now();

  void _showDatePicker(){
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
    ).then((value){
      setState(() {
        _dateTime = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: Center(
            child: Column(
              //display chosen date
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(_dateTime.toString(), style: TextStyle(fontSize: 25)),
                MaterialButton(
                  onPressed: _showDatePicker,
                  color: Colors.deepOrangeAccent,
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('Choose Date',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                        )
                    ),
                  ),
                ),
              ],
            )
        )
    );
  }
}
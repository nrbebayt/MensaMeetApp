import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mensa_meet_app/sections/auth_home_wrapper.dart';

class Homepage extends StatefulWidget{
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() =>_HomepageState();
}

class _HomepageState extends State<Homepage>{
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

  Future _logout() async{
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          backgroundColor: Colors.deepOrangeAccent,
          actions: <Widget>[
            TextButton.icon(
                onPressed:() async{
                  await _logout();
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AuthHomeWrapper()));
                },
                icon: Icon(Icons.account_box_rounded),
                label: Text('Logout')),
          ],
        ),
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
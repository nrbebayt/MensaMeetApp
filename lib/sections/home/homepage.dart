import 'package:firebase_auth/firebase_auth.dart';
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
    //return FirebaseAuth.instance.currentUser!.delete();
    FirebaseAuth.instance.signOut();
  }

  @override

  TimeOfDay selectedTime = TimeOfDay.now();
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: Colors.amber,
          actions: <Widget>[
            TextButton.icon(
                onPressed:() async{
                  await _logout();
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const AuthHomeWrapper()));
                },
                icon: const Icon(Icons.account_box_rounded),
                label: const Text('Logout')),
          ],
        ),
        body: Center(
            child: Column(
              //display chosen date
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(_dateTime.toString(), style: const TextStyle(fontSize: 25)),

                Text("${selectedTime.hour.toString().padLeft(2,'0')}:${selectedTime.minute.toString().padLeft(2,'0')}",
                    style: const TextStyle(fontSize: 16)),
                MaterialButton(
                  onPressed: _showDatePicker,
                  color: Colors.amber,
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
                ElevatedButton(
                  onPressed: () async {
                    //await MeetingDatabase().addMeetingToDatabase("ein datum", "eine uhrzeit","Bottrop",1, FirebaseAuth.instance.currentUser!.uid);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: const Text('Test set database data',
                      style: TextStyle(color: Colors.white)),
                ),
                MaterialButton(
                  onPressed: () async{
                    final TimeOfDay? timeOfDay = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                      initialEntryMode: TimePickerEntryMode.input,
                      builder: (BuildContext context, Widget? child) {
                        return MediaQuery(
                          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                          child: child!,
                        );
                      },
                    );
                    if(timeOfDay != null){
                      setState(() {
                        selectedTime = timeOfDay;
                      });
                    }

                  },
                  color: Colors.amber,
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('Choose Time',
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
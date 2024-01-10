import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

class MeetingData {
  String date;
  String time;
  String campus;
  int tableNumber;
  List<String> users;

  MeetingData(this.date, this.time, this.campus, this.tableNumber, this.users);
}

class MeetingDatabase {
  //final String userid = '';
  //DateDatabase({required this.userid});

  //const DateDatabase({Key? key}) : super(key: key);
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('termine');

  List<String> b = <String>["asdf", "bcde", "gjlk"];
  //List<List<String>> a = <List<String>>[b,b,b];

  //MeetingData meetingData = MeetingData();

  Future addMeetingToDatabase(String date, String time, String campus,
      int tableNumber, String uid) async {
    List<String> users = <String>[uid];

    //sets a collection of data for the doc corresponding to the current user id
    return await collectionReference.add({
      'date': date,
      'time': time,
      'campus': campus,
      'tisch': tableNumber,
      'nutzer': users
    });
    //campus, tisch, datum, uhrzeit, nutzer
  }

  Future<List<MeetingData>> getListOfAllMeetings() async {
    List<String> users = <String>[];
    List<MeetingData> list = <MeetingData>[];
    //list.add(MeetingData("date", "time", "campus", 1, users));
    //print(list.length);

    await FirebaseFirestore.instance.collection('termine').get().then(
      (value) {
        for (var termin in value.docs) {
            var array = termin['nutzer'];
            MeetingData meetingData = (MeetingData(
                termin.get('date'),
                termin.get('time'),
                termin.get('campus'),
                termin.get('tisch'),
                List<String>.from(array))
            );
            list.add(meetingData);
            //print(list.elementAt(0).tableNumber);
          }
      },
    );
    //print(list);
    //print(list.length);
    return list;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

class MeetingData {
  String campus;
  String datum;
  String uhrzeit;
  int tisch;
  List<String> nutzer;



  MeetingData( this.campus, this.datum, this.uhrzeit, this.tisch, this.nutzer);
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

  Future addMeetingToDatabase(String campus,String datum, String uhrzeit,
      int tisch, String uid) async {
    List<String> nutzer = <String>[uid];

    //sets a collection of data for the doc corresponding to the current user id
    return await collectionReference.add({
      'campus': campus,
      'datum': datum,
      'uhrzeit': uhrzeit,
      'tisch': tisch,
      'nutzer': nutzer
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
                termin.get('campus'),
                termin.get('datum'),
                termin.get('uhrzeit'),
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

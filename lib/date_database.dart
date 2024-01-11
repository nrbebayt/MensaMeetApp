import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

class MeetingData {
  String campus;
  String datum;
  String uhrzeit;
  int tisch;
  List<String> nutzer;
  String meetingID;
  bool inMeeting;

  MeetingData( this.campus, this.datum, this.uhrzeit, this.tisch, this.nutzer, this.meetingID, this.inMeeting);
}

class MeetingDatabase {

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('termine');

  List<String> b = <String>["asdf", "bcde", "gjlk"];


  Future<void> addDataToFirebase(String campus, String date, String time, int table,String user) async {
    try {
      // Verbinden Sie sich mit Ihrer Firestore-Datenbank
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Fügen Sie Daten in eine Sammlung hinzu
      List<String> users = <String>[];
      users.add(user);
      await firestore.collection('termine').add({
        'campus': campus,
        'datum': date,
        'uhrzeit': time,
        'tisch': table,
        'nutzer': users
        // Weitere Felder nach Bedarf hinzufügen
      });

      print('Daten erfolgreich in Firebase geschrieben!');
    } catch (e) {
      print('Fehler beim Schreiben in Firebase: $e');
    }
  }

  Future<List<MeetingData>> getListOfAllMeetings() async {
    List<MeetingData> list = <MeetingData>[];

    await FirebaseFirestore.instance.collection('termine').get().then(
      (value) {
        for (var termin in value.docs) {
            var userArray = termin['nutzer'];
            List<String> users = List<String>.from(userArray);
            bool inMeeting = users.contains(FirebaseAuth.instance.currentUser!.uid);

            MeetingData meetingData = (MeetingData(
                termin.get('campus'),
                termin.get('datum'),
                termin.get('uhrzeit'),
                termin.get('tisch'),
                List<String>.from(userArray),
                termin.id,
                inMeeting)
            );
            list.add(meetingData);
          }
      },
    );
    return list;
  }

  //joins a meeting by adding user id to the list of users of the chosen meeting
  Future<void> joinMeeting(String meetingID) async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('termine');
    DocumentReference documentReference = collectionReference.doc(meetingID);

    //create an empty string of users to populate with the existing users of the meeting
    List<String> users = <String>[];

    //get userArray from database for the given meeting id
    await documentReference.get().then((value) {
      dynamic userArray;
      try {
        userArray = value.get('nutzer');
      }
      catch(e){
        log(e.toString());
      }
      //create List<String> from the existing users inside the meeting
      users = List<String>.from(userArray);

      //add own user id to users
      users.add(FirebaseAuth.instance.currentUser!.uid);
    });

    //updates only the users field inside the database
    collectionReference.doc(meetingID).update({
          'nutzer': users,
    });
  }
}

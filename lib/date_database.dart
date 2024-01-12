import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mensa_meet_app/sections/notification_handler.dart';

class MeetingData {
  String campus;
  String date;
  String time;
  int table;
  List<String> user;
  String meetingID;
  bool inMeeting;

  MeetingData( this.campus, this.date, this.time, this.table, this.user, this.meetingID, this.inMeeting);
}

class MeetingDatabase {

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('meetings');

  List<String> b = <String>["asdf", "bcde", "gjlk"];

  ///Adds a new meeting to the database.
  Future<void> addDataToFirebase(String campus, DateTime dateTime, int table,String user) async {
    try {
      //Connects with the firestore database
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      //Adds data to the collection
      List<String> users = <String>[];
      users.add(user);
      await firestore.collection('meetings').add({
        'campus': campus,
        'dateTime': dateTime,
        'table': table,
        'user': users
      });

      //Notifies the user of the added meeting
      String date = "${dateTime.day.toString().padLeft(2,'0')}.${dateTime.month.toString().padLeft(2,'0')}.${dateTime.year}";
      String time = "${dateTime.hour.toString().padLeft(2,'0')}:${dateTime.minute.toString().padLeft(2,'0')}";
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      NotificationHandler().initialize(flutterLocalNotificationsPlugin);
      NotificationHandler().showNotification("MensaMeet [Termin um $time am $date]:", "Du hast ein Meetup erstellt.", flutterLocalNotificationsPlugin);
    } catch (e) {
      log(e.toString());
    }
  }

  ///Fetches a list of all available meetings from the database to be displayed under MeetUps.
  ///Returns a List<MeetingData> populated with data from the database.
  Future<List<MeetingData>> getListOfAllMeetings() async {
    List<MeetingData> list = <MeetingData>[];
    if(FirebaseAuth.instance.currentUser == null) return list;

    await FirebaseFirestore.instance.collection('meetings').get().then(
      (value) async {
        for (var meeting in value.docs) {
            var userArray = meeting['user'];
            List<String> users = List<String>.from(userArray);
            bool inMeeting = users.contains(FirebaseAuth.instance.currentUser!.uid);

            var dateTime = (meeting.get('dateTime') as Timestamp).toDate();
            String date = "${dateTime.day.toString().padLeft(2,'0')}.${dateTime.month.toString().padLeft(2,'0')}.${dateTime.year}";
            String time = "${dateTime.hour.toString().padLeft(2,'0')}:${dateTime.minute.toString().padLeft(2,'0')}";

            //Checks if one week has passed after the dateTime has passed and deletes the meeting
            if(DateTime.now().subtract(const Duration(days: 7)).isAfter(dateTime)){
              await deleteMeeting(meeting.id);
              if (!inMeeting) break;
              //Notifies the user if he was in the deleted meeting
              FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
              NotificationHandler().initialize(flutterLocalNotificationsPlugin);
              NotificationHandler().showNotification("MensaMeet [Termin um $time am $date]:", "Der Termin ist eine Woche alt und wurde gelöscht.", flutterLocalNotificationsPlugin);
              break;
            }

            MeetingData meetingData = (MeetingData(
                meeting.get('campus'),
                date,
                time,
                meeting.get('table'),
                List<String>.from(userArray),
                meeting.id,
                inMeeting)
            );
            list.add(meetingData);
          }
      },
    );
    return list;
  }

  ///Joins a meeting by adding user id to the list of users of the chosen meeting.
  Future<void> joinMeeting(String meetingID) async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('meetings');
    DocumentReference documentReference = collectionReference.doc(meetingID);

    //create an empty string of users to populate with the existing users of the meeting
    List<String> users = <String>[];

    //get userArray from database for the given meeting id
    await documentReference.get().then((value) {
      dynamic userArray;
      try {
        userArray = value.get('user');
      }
      catch(e){
        log(e.toString());
      }
      //create List<String> from the existing users inside the meeting
      users = List<String>.from(userArray);

      //add own user id to users unless it is already there
      if(!users.contains(FirebaseAuth.instance.currentUser!.uid)) {
        users.add(FirebaseAuth.instance.currentUser!.uid);
      }
    });

    //updates only the users field inside the database
    collectionReference.doc(meetingID).update({
          'user': users,
    });
  }

  ///Leave a meeting with the given id. Calls the delete method if the meeting is empty after leaving.
  Future<void> leaveMeeting(String meetingID) async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('meetings');
    DocumentReference documentReference = collectionReference.doc(meetingID);

    //create an empty string of users to populate with the existing users of the meeting
    List<String> users = <String>[];

    //get userArray from database for the given meeting id
    await documentReference.get().then((value) async {
      dynamic userArray;
      try {
        userArray = value.get('user');
      }
      catch(e){
        log(e.toString());
      }
      //create List<String> from the existing users inside the meeting
      users = List<String>.from(userArray);

      //add own user id to users
      users.remove(FirebaseAuth.instance.currentUser!.uid);
    });

    if(users.isEmpty){
      await deleteMeeting(meetingID);
    }
    else {
      collectionReference.doc(meetingID).update({
        'user': users,
      });
    }
  }

  ///Delete a meeting with the given id.
  Future<void> deleteMeeting(String meetingID) async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('meetings');

    collectionReference.doc(meetingID).delete();
  }
}

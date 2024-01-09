import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MeetingData {
  String date;
  String time;
  String campus;
  int tableNumber;
  List<String> users;

  MeetingData(this.date, this.time, this.campus, this.tableNumber, this.users);
}

class DateDatabase {
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
    List<MeetingData> list = <MeetingData>[];
    FirebaseFirestore.instance.collection('termine').get().then(
      (value) {
        value.docs.forEach(
          (termin) {
            list.add(MeetingData(
                termin.get('date'),
                termin.get('time'),
                termin.get('field'),
                termin.get('tisch'),
                termin.get('nutzer')));
          },
        );
      },
    );
    return list;
  }
}

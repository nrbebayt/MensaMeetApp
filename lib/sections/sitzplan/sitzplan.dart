//Design
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//Log
import 'dart:developer';
//Use Hexcode for Colors
import 'package:hexcolor/hexcolor.dart';
import 'package:mensa_meet_app/sections/home/home.dart';
import 'package:mensa_meet_app/sections/home/homepage.dart';
import 'package:mensa_meet_app/sections/supportClass/_Colors.dart';
import 'package:mensa_meet_app/sections/supportClass/_Images.dart';

//FireBase
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//open URL so we can open PDF's
import 'package:mensa_meet_app/sections/supportClass/urlHandler.dart';
//Format Date, Number etc.

//open URL
import 'package:url_launcher/url_launcher.dart';

//add SVG Support
import 'package:flutter_svg/flutter_svg.dart';

import '../auth_home_wrapper.dart';

class sitzplan extends StatefulWidget {
  const sitzplan({super.key});

  @override
  State<sitzplan> createState() => _sitzplanState();
}

const campus = "Mensa Bottrop";
var currentTable = 0;

DateTime _dateTime = DateTime.now();
TimeOfDay selectedTime = TimeOfDay.now();

class _sitzplanState extends State<sitzplan> {
  int currentPageIndex = 0;
  DateTime dateTime = DateTime(2024,1,10,1,24);


  Future<DateTime?> pickDate() => showDatePicker(
    context: context,
    initialDate: dateTime,
    firstDate: DateTime(2000),
    lastDate: DateTime(2025),
  );

  Future<TimeOfDay?> pickTime() => showTimePicker(
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

  Future pickDateTime(int num) async{
    DateTime? date = await pickDate();
    if(date == null) return;

    TimeOfDay? time = await pickTime();
    if(time == null) return;

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute
    );

    setState(()  {
      this.dateTime = dateTime;
      String date = "${dateTime.day.toString().padLeft(2,'0')}.${dateTime.month.toString().padLeft(2,'0')}.${dateTime.year}";
      String time = "${dateTime.hour.toString().padLeft(2,'0')}:${dateTime.minute.toString().padLeft(2,'0')}";
      addDataToFirebase(campus,date,time,num,"TestUser");
    });
  }


  @override
  Widget build(BuildContext context) {

    final hours = dateTime.hour.toString().padLeft(2,'0');
    final minutes = dateTime.minute.toString().padLeft(2,'0');

    const String appTitle = 'Flutter layout demo';
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 130,
          backgroundColor: HexColor("F3EBDD"),
          title: Padding(
            padding: const EdgeInsets.only(top: 15, left: 15),
            child: SvgPicture.asset(Images.logo_light),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(Images.appbar,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(index: 2)));
            });
          },
          indicatorColor: colorlib.red,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.fastfood),
              label: 'Speiseplan',
            ),
            NavigationDestination(
              icon: Icon(Icons.no_accounts),
              label: 'Meetups',
            ),
          ],
        ),
        backgroundColor: colorlib.backgroundColor,
        body: SafeArea(
        top: true,
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
          },
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 0.95,
            decoration: BoxDecoration(
              color: colorlib.backgroundColor,
              shape: BoxShape.rectangle,
            ),
            child: Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text(
                          'Sitzplatz Mensa Bottrop',
                            style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child:  Text("${dateTime.day.toString().padLeft(2,'0')}.${dateTime.month.toString().padLeft(2,'0')}.${dateTime.year} ${dateTime.hour.toString().padLeft(2,'0')}:${dateTime.minute.toString().padLeft(2,'0')}"),
                        ),
                    ],
                  ),
                  Expanded(
                    child: GridView(
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                      scrollDirection: Axis.vertical,
                      children: [
                        GestureDetector(
                          onTap: ()  {
                          pickDateTime(1);

                        },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SvgPicture.asset(Images.tisch1,
                              width: 300,
                              height: 200,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            pickDateTime(2);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SvgPicture.asset(Images.tisch2,
                              width: 300,
                              height: 200,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            pickDateTime(3);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SvgPicture.asset(Images.tisch3,
                              width: 300,
                              height: 200,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            pickDateTime(4);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SvgPicture.asset(Images.tisch4,
                              width: 300,
                              height: 200,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            pickDateTime(5);
                          },
                            child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SvgPicture.asset(Images.tisch5,
                              width: 300,
                              height: 200,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            pickDateTime(6);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SvgPicture.asset(Images.tisch6,
                              width: 300,
                              height: 200,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            pickDateTime(7);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SvgPicture.asset(Images.tisch7,
                              width: 300,
                              height: 200,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            pickDateTime(8);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SvgPicture.asset(Images.tisch8,
                              width: 300,
                              height: 200,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    ),

    );
  }
}

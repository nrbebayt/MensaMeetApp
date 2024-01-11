//Design
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//Log
import 'dart:developer';
//Use Hexcode for Colors
import 'package:hexcolor/hexcolor.dart';
import 'package:mensa_meet_app/date_database.dart';
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

import '../auth/authentication_service.dart';
import '../auth_home_wrapper.dart';

class sitzplan_mul extends StatefulWidget {
  const sitzplan_mul({super.key});

  @override
  State<sitzplan_mul> createState() => _sitzplan_mulState();
}

const campus = "Mensa Muelheim";
var currentTable = 0;

DateTime _dateTime = DateTime.now();
TimeOfDay selectedTime = TimeOfDay.now();

class _sitzplan_mulState extends State<sitzplan_mul> {
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
      MeetingDatabase().addDataToFirebase(campus,dateTime,num,FirebaseAuth.instance.currentUser!.uid);
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
              child: Image.asset(Images.appbar_mul,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton.icon(
                onPressed:() async{
                  await AuthenticationService().logout();
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const AuthHomeWrapper()));
                },
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                icon: const Icon(Icons.account_box_rounded),
                label: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white)
                )
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(index: index)));
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
                            'Sitzplatz Mensa Mülheim',
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   mainAxisSize: MainAxisSize.max,
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(bottom: 15),
                    //       child:  Text("${dateTime.day.toString().padLeft(2,'0')}.${dateTime.month.toString().padLeft(2,'0')}.${dateTime.year} ${dateTime.hour.toString().padLeft(2,'0')}:${dateTime.minute.toString().padLeft(2,'0')}"),
                    //     ),
                    //   ],
                    // ),
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

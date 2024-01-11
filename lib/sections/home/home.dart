import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:hexcolor/hexcolor.dart';
import 'package:mensa_meet_app/sections/home/homepage.dart';
import 'package:mensa_meet_app/sections/sitzplan/sitzplan.dart';
import 'package:mensa_meet_app/sections/supportClass/_Colors.dart';
import 'package:mensa_meet_app/sections/supportClass/_Images.dart';
import 'package:mensa_meet_app/sections/supportClass/urlHandler.dart';
//TEST
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



//open URL
import 'package:url_launcher/url_launcher.dart';

//add SVG Support
import 'package:flutter_svg/flutter_svg.dart';

import '../../date_database.dart';
import '../auth_home_wrapper.dart';

class Home extends StatefulWidget {
  late int index;
  Home({required this.index});

  @override

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<MeetingData> listOfMeetings = <MeetingData>[];
  @override
  initState() {
    super.initState();

    //initializes listOfMeetings before build method is executed (in case we use the navigation bar outside
    // of the home class to navigate to the meetups)
    MeetingDatabase().getListOfAllMeetings().then((value){
      setState(() {
        listOfMeetings = value;
      });
    });
  }
   //int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
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

          onDestinationSelected: (int index) async {
            if(index == 2) {
              listOfMeetings = await MeetingDatabase().getListOfAllMeetings();
            }
            widget.index = index;
            print(listOfMeetings.length);

            setState(() {

            });
          },
          indicatorColor: colorlib.red,
          selectedIndex: widget.index,
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
        body: <Widget>[
          //HOMEPAGEE
          SafeArea(
            top: true,
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * 1,
              decoration: BoxDecoration(color: colorlib.backgroundColor),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 25),
                        child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(-1, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, bottom: 3.0),
                                      child: Text('Bottrop',
                                          textAlign: TextAlign.start),
                                    ),
                                    GestureDetector(
                                      onTap: () async{
                                        Navigator.pop(context);
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> sitzplan()));
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.asset(
                                          Images.bottrop,
                                          width: 320,
                                          height: 130,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 25),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 3.0),
                                  child:
                                      Text('Mülheim', textAlign: TextAlign.start),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    Images.muelheim,
                                    width: 320,
                                    height: 130,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, bottom: 3.0),
                                child:
                                    Text('Duisburg', textAlign: TextAlign.start),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  Images.duisburg,
                                  width: 320,
                                  height: 130,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //Speiseplan
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {},
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * 0.95,
              decoration: BoxDecoration(
                color: colorlib.backgroundColor,
                shape: BoxShape.rectangle,
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 25),
                                child: Text('Speisepläne',
                                    style: TextStyle(fontSize: 22)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Deine Favoriten',
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bottrop',
                                  textAlign: TextAlign.start,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    var url = urlHandler.bottropthis;
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 3,
                                          color: Color(0x33000000),
                                          offset: Offset(0, 1),
                                        )
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        Images.speiseplan1,
                                        width: 300,
                                        height: 130,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mülheim',
                                  textAlign: TextAlign.start,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 3,
                                        color: Color(0x33000000),
                                        offset: Offset(0, 1),
                                      )
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onTap:() async {
                                      var url = urlHandler.muelheimthis;
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        Images.speiseplan2,
                                        width: 300,
                                        height: 130,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'weitere:',
                                  textAlign: TextAlign.start,
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0, 0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 10, 0, 0),
                                    child: GestureDetector(
                                      onTap:() async {
                                        var url = urlHandler.duisburgthis;
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            width: 300,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 3,
                                                  color: Color(0x33000000),
                                                  offset: Offset(0, 1),
                                                )
                                              ],
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.white,
                                                  Colors.white
                                                ],
                                                stops: [0, 1],
                                                begin:
                                                    AlignmentDirectional(0, -1),
                                                end: AlignmentDirectional(0, 1),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.asset(
                                                    Images.teaser1,
                                                    width: 90,
                                                    height: 90,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(10, 0, 0, 0),
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text('Mo. - Fr. geöffnet',
                                                            style: TextStyle(
                                                                fontSize: 9)),
                                                        Text(
                                                            'Mensa, Campus Duisburg',
                                                            style: TextStyle(
                                                                fontSize: 14)),
                                                        Text(
                                                            'Lotharstraße 23-25\n47057 Duisburg',
                                                            style: TextStyle(
                                                                fontSize: 9)),
                                                      ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 10, 0, 0),
                                  child: GestureDetector(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: 300,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 3,
                                                color: Color(0x33000000),
                                                offset: Offset(0, 1),
                                              )
                                            ],
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.white,
                                                Colors.white
                                              ],
                                              stops: [0, 1],
                                              begin: AlignmentDirectional(0, -1),
                                              end: AlignmentDirectional(0, 1),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: GestureDetector(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.asset(
                                                    Images.teaser2,
                                                    width: 90,
                                                    height: 90,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(10, 0, 0, 0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text('Mo. - Fr. geöffnet',
                                                          style: TextStyle(
                                                              fontSize: 9)),
                                                      Text(
                                                          'Kafeebar, Campus Duisburg',
                                                          style: TextStyle(
                                                              fontSize: 14)),
                                                      Text(
                                                          'Lotharstraße 23-25\n47057 Duisburg',
                                                          style: TextStyle(
                                                              fontSize: 9)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 10, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 300,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 3,
                                              color: Color(0x33000000),
                                              offset: Offset(0, 1),
                                            )
                                          ],
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Colors.white
                                            ],
                                            stops: [0, 1],
                                            begin: AlignmentDirectional(0, -1),
                                            end: AlignmentDirectional(0, 1),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.asset(
                                                Images.teaser3,
                                                width: 90,
                                                height: 90,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(10, 0, 0, 0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('Mo. - Fr. geöffnet',
                                                      style: TextStyle(
                                                          fontSize: 9)),
                                                  Text(
                                                      'Kafeebar, Campus Duisburg',
                                                      style: TextStyle(
                                                          fontSize: 14)),
                                                  Text(
                                                      'Lotharstraße 23-25\n47057 Duisburg',
                                                      style: TextStyle(
                                                          fontSize: 9)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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

          /// Notifications page
          Padding(
            padding: EdgeInsets.all(8.0),

            child: Column(

              children: <Widget>[
                for(var item in listOfMeetings) Card(
                  child: ListTile(
                    leading: Icon(Icons.notifications_sharp),
                    title: Text('${item.uhrzeit}'),
                    subtitle: Text('This is a notification'),
                    onTap:() async {
                      //if(!item.inMeeting) MeetingDatabase().joinMeeting(item.meetingID);
                      await MeetingDatabase().deleteMeeting(item.meetingID);
                      listOfMeetings = await MeetingDatabase().getListOfAllMeetings();
                      setState(() {

                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ][widget.index],
      ),
    );
  }
}

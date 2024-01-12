import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:developer';
import 'package:hexcolor/hexcolor.dart';
import 'package:mensa_meet_app/sections/auth/authentication_service.dart';
import 'package:mensa_meet_app/sections/home/homepage.dart';
import 'package:mensa_meet_app/sections/notification_handler.dart';
import 'package:mensa_meet_app/sections/sitzplan/sitzplan_bot.dart';
import 'package:mensa_meet_app/sections/sitzplan/sitzplan_duis.dart';
import 'package:mensa_meet_app/sections/sitzplan/sitzplan_mul.dart';
import 'package:mensa_meet_app/sections/supportClass/_Colors.dart';
import 'package:mensa_meet_app/sections/supportClass/_Images.dart';
import 'package:mensa_meet_app/sections/supportClass/urlHandler.dart';

//TEST
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';



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

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Map<String, int> userCountMapOfMyMeetings = {};


///maps the meetingID to the user count for all meetings which the current user is part of
///to later check if another user was added to one of the
///current users meetings
void refreshUserCountMap(List<MeetingData> listOfMeetings){
  for(var meeting in listOfMeetings){
    if(meeting.inMeeting){
      String meetingID = meeting.meetingID;
      int userCount = meeting.nutzer.length;
      userCountMapOfMyMeetings[meetingID] = userCount;
      //print("USERCOUNT: ");
      //print(userCount);

    }
  }
}

void checkIfNewUserJoined(List<MeetingData> listOfMeetings){
  for(var meeting in listOfMeetings){
    if(userCountMapOfMyMeetings.containsKey(meeting.meetingID)){
      int oldUserCount = userCountMapOfMyMeetings[meeting.meetingID]!;
      int newUserCount = meeting.nutzer.length;
      print("OLD: "); print(oldUserCount);
      print("NEW: "); print(newUserCount);

      if(meeting.nutzer.length > userCountMapOfMyMeetings[meeting.meetingID]!){
        NotificationHandler().showNotification("MensaMeet", "A user has joined your Meetup!", flutterLocalNotificationsPlugin);
      }
    }
  }
}

class _HomeState extends State<Home> {
   int currentPageIndex = 0;
   List<MeetingData> listOfMeetings = <MeetingData>[];
   @override
   initState() {
     NotificationHandler().initialize(flutterLocalNotificationsPlugin);
     super.initState();

     //initializes listOfMeetings before build method is executed (in case we use the navigation bar outside
     // of the home class to navigate to the meetups)
     MeetingDatabase().getListOfAllMeetings().then((value){
       setState(() {
         listOfMeetings = value;
       });
     });
     checkIfNewUserJoined(listOfMeetings);
     refreshUserCountMap(listOfMeetings);

   }
   final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

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
              child: Image.asset(Images.appbar_bot,
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

          onDestinationSelected: (int index) async {
            if(index == 2) {
              listOfMeetings = await MeetingDatabase().getListOfAllMeetings();
              checkIfNewUserJoined(listOfMeetings);
              refreshUserCountMap(listOfMeetings);
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

          Container(
            decoration: BoxDecoration(),
            alignment: AlignmentDirectional(0, -1),
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.90,
              height: 620,
              child: CarouselSlider(
                items: [
                  Container(
                    child: GestureDetector(
                      onTap: () async{
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> sitzplan_bot()));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(Images.bot,
                          width: 320,
                          height: 130,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async{
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> sitzplan_duis()));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(Images.duis,
                        width: 320,
                        height: 130,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async{
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> sitzplan_mul()));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(Images.mul,
                        width: 320,
                        height: 130,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(Images.rw,
                      width: 320,
                      height: 130,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(Images.essen,
                      width: 320,
                      height: 230,
                      fit: BoxFit.contain,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(Images.aachen,
                      width: 320,
                      height: 130,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ],

                options: CarouselOptions(
                  initialPage: 1,
                  viewportFraction: 0.3,
                  disableCenter: true,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.25,
                  enableInfiniteScroll: true,
                  scrollDirection: Axis.vertical,
                  autoPlay: false,

                ),
              ),
            ),
          ),
          //HOMEPAGEE
          // SafeArea(
          //   top: true,
          //   child: Container(
          //     width: MediaQuery.sizeOf(context).width,
          //     height: MediaQuery.sizeOf(context).height * 1,
          //     decoration: BoxDecoration(color: colorlib.backgroundColor),
          //     child: Padding(
          //       padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
          //       child: SingleChildScrollView(
          //         child: Column(
          //           mainAxisSize: MainAxisSize.max,
          //           children: [
          //             Padding(
          //               padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 25),
          //               child: Row(
          //                   mainAxisSize: MainAxisSize.max,
          //                   crossAxisAlignment: CrossAxisAlignment.center,
          //                   children: [
          //                     Align(
          //                       alignment: AlignmentDirectional(-1, 0),
          //                       child: Column(
          //                         mainAxisSize: MainAxisSize.max,
          //                         crossAxisAlignment: CrossAxisAlignment.start,
          //                         children: [
          //                           Padding(
          //                             padding: const EdgeInsets.only(
          //                                 left: 5.0, bottom: 3.0),
          //                             child: Text('Bottrop',
          //                                 textAlign: TextAlign.start),
          //                           ),
          //                           GestureDetector(
          //                             onTap: () async{
          //                               Navigator.pop(context);
          //                               Navigator.push(context, MaterialPageRoute(builder: (context)=> sitzplan_bot()));
          //                             },
          //                             child: ClipRRect(
          //                               borderRadius: BorderRadius.circular(16),
          //                               child: Image.asset(
          //                                 Images.bottrop,
          //                                 width: 320,
          //                                 height: 130,
          //                                 fit: BoxFit.cover,
          //                               ),
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   ]),
          //             ),
          //             Padding(
          //               padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 25),
          //               child: Row(
          //                 mainAxisSize: MainAxisSize.max,
          //                 children: [
          //                   Column(
          //                     mainAxisSize: MainAxisSize.max,
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       Padding(
          //                         padding: const EdgeInsets.only(
          //                             left: 8.0, bottom: 3.0),
          //                         child:
          //                             Text('Mülheim', textAlign: TextAlign.start),
          //                       ),
          //                       ClipRRect(
          //                         borderRadius: BorderRadius.circular(16),
          //                         child: Image.asset(
          //                           Images.muelheim,
          //                           width: 320,
          //                           height: 130,
          //                           fit: BoxFit.cover,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             Row(
          //               mainAxisSize: MainAxisSize.max,
          //               children: [
          //                 Column(
          //                   mainAxisSize: MainAxisSize.max,
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Padding(
          //                       padding:
          //                           const EdgeInsets.only(left: 8.0, bottom: 3.0),
          //                       child:
          //                           Text('Duisburg', textAlign: TextAlign.start),
          //                     ),
          //                     ClipRRect(
          //                       borderRadius: BorderRadius.circular(16),
          //                       child: Image.asset(
          //                         Images.duisburg,
          //                         width: 320,
          //                         height: 130,
          //                         fit: BoxFit.cover,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ],
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

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
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding:EdgeInsetsDirectional.fromSTEB(0, 5, 0,0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Deine Meetups',
                          style: TextStyle(fontSize: 22
                          )),
                    ),
                  ),
                  for(var item in listOfMeetings) Padding(
                    padding: const EdgeInsets.only(left:15,top:15),
                    child: FlipCard(
                      fill: Fill.fillBack,
                      direction: FlipDirection.VERTICAL,
                      speed: 400,
                      front: Container(
                        width: 330,
                        height: 100,
                        decoration: BoxDecoration(
                          color: colorlib.grey,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Container(
                          width: 330,
                          height: 100,
                          decoration: BoxDecoration(
                            color: colorlib.offwhite,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                          child: Text(
                                            '${item.campus}',
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            ElevatedButton(
                                              onPressed:
                                                item.inMeeting ? null : () async {
                                                  await MeetingDatabase().joinMeeting(item.meetingID);
                                                  listOfMeetings = await MeetingDatabase().getListOfAllMeetings();
                                                  checkIfNewUserJoined(listOfMeetings);
                                                  refreshUserCountMap(listOfMeetings);
                                                  NotificationHandler().showNotification("MensaMeet:", "Du bist einem Meetup beigetreten für den ${item.datum} um ${item.uhrzeit}.", flutterLocalNotificationsPlugin);
                                                  setState(() {
                                                  });
                                              },
                                              // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
                                              style: ElevatedButton.styleFrom(
                                                  minimumSize: Size(150, 40),
                                                  elevation: 5.0,
                                                  backgroundColor: colorlib.grey,
                                                  textStyle: const TextStyle(color: Colors.white)),
                                              child: const Text('Beitreten',
                                            style: TextStyle(color: Colors.white),)
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${item.datum}',
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                          Text(
                                            '${item.uhrzeit}',
                                            style: TextStyle(fontSize: 32.0),
                                          ),
                                          Text(
                                            'Tisch: ${item.tisch}',
                                            style: TextStyle(fontSize: 10.0),
                                          ),
                                        ]),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      back: Container(
                        width: 330,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Color(0xFFDFDFDF),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(20, 0, 15, 0),
                                child: Text(
                                  'Nutzer: ${item.nutzer.length}',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                              child:  ElevatedButton(
                                onPressed:
                                  !item.inMeeting ? null : () async {
                                    await MeetingDatabase().leaveMeeting(item.meetingID);
                                    listOfMeetings = await MeetingDatabase().getListOfAllMeetings();
                                    checkIfNewUserJoined(listOfMeetings);
                                    refreshUserCountMap(listOfMeetings);
                                    NotificationHandler().showNotification("MensaMeet:", "Du hast ein Meetup verlassen.", flutterLocalNotificationsPlugin);
                                    setState(() {

                                    });
                                },
                                // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
                                style: ElevatedButton.styleFrom(
                                    minimumSize: Size(150, 40),
                                    elevation: 5.0,
                                    backgroundColor: colorlib.grey,
                                    textStyle: const TextStyle(color: Colors.white)),
                                child: const Text('Verlassen',
                                style: TextStyle(color: Colors.redAccent)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ][widget.index],
      ),
    );
  }
}

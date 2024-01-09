//Design
import 'package:flutter/material.dart';
//Log
import 'dart:developer';
//Use Hexcode for Colors
import 'package:hexcolor/hexcolor.dart';
import 'package:mensa_meet_app/sections/home/homepage.dart';
import 'package:mensa_meet_app/sections/supportClass/_Colors.dart';
import 'package:mensa_meet_app/sections/supportClass/_Images.dart';
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


class _sitzplanState extends State<sitzplan> {
  int currentPageIndex = 0;

  DateTime _dateTime = DateTime.now();

  void _showDatePicker(){
    var test = [];
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2025)
    ).then((value){
      setState(() {
        _dateTime = value!;
        log('$value');
        test.add('$value');
        log('$test');
      });
    });
  }

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
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
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
                        child:  Text(_dateTime.toString(), style: TextStyle(fontSize: 25)),
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SvgPicture.asset(Images.tisch1,
                            width: 300,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SvgPicture.asset(Images.tisch2,
                            width: 300,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SvgPicture.asset(Images.tisch3,
                            width: 300,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SvgPicture.asset(Images.tisch4,
                            width: 300,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SvgPicture.asset(Images.tisch5,
                            width: 300,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SvgPicture.asset(Images.tisch6,
                            width: 300,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SvgPicture.asset(Images.tisch7,
                            width: 300,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                        GestureDetector(
                            onTap: _showDatePicker,
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

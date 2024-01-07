import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mensa_meet_app/sections/supportClass/_Colors.dart';
import 'package:mensa_meet_app/sections/supportClass/_Images.dart';

import '../auth_home_wrapper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Flutter layout demo';
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: HexColor("F3EBDD"),
          title: Padding(
              padding: const EdgeInsets.only(top:15,left:15),
              child: Row(
                children: [
                  SvgPicture.asset(Images.logoSvg),
                  SvgPicture.asset(Images.settings)


                ],
              )
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
              icon: Badge(child: Icon(Icons.fastfood)),
              label: 'Speiseplan',
            ),
            NavigationDestination(
              icon: Badge(
                label: Text('2'),
                child: Icon(Icons.no_accounts),
              ),
              label: 'Meetups',
            ),
          ],
        ),
        backgroundColor: colorlib.backgroundColor,

        body:

            <Widget>[
              SafeArea(
                top: true,
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 1,
                  decoration: BoxDecoration(
                      color: colorlib.backgroundColor
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
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
                                        padding: const EdgeInsets.only(left: 5.0,bottom: 3.0),
                                        child: Text(
                                            'Bottrop',
                                            textAlign: TextAlign.start
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.asset(Images.bottrop,
                                          width: 320,
                                          height: 130,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]


                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 25),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Padding(
                                  padding: const EdgeInsets.only(left: 8.0,bottom: 3.0),
                                  child: Text(
                                      'Mülheim',
                                      textAlign: TextAlign.start
                                  ),
                                ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.asset(Images.muelheim,
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
                              children: [Padding(
                                padding: const EdgeInsets.only(left: 8.0,bottom: 3.0),
                                child: Text(
                                    'Duisburg',
                                    textAlign: TextAlign.start
                                ),
                              ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(Images.duisburg,
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
              //HOMEPAGE
              Card(
                shadowColor: Colors.transparent,
                margin: const EdgeInsets.all(8.0),
                child: SizedBox.expand(
                  child: Center(
                    child: Text(
                        'Home page'
                    ),
                  ),
                ),
              ),

              /// Notifications page
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.notifications_sharp),
                        title: Text('Notification 1'),
                        subtitle: Text('This is a notification'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.notifications_sharp),
                        title: Text('Notification 2'),
                        subtitle: Text('This is a notification'),
                      ),
                    ),
                  ],
                ),
              ),
            ][currentPageIndex],
        /// FAKEPAGE




      ),
    );
  }
}

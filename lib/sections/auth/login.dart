import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mensa_meet_app/sections/auth/authentication_service.dart';
import 'package:mensa_meet_app/sections/home/home.dart';
import 'package:mensa_meet_app/sections/supportClass/_Colors.dart';
import 'package:mensa_meet_app/sections/supportClass/_Images.dart';

import '../impressum/impressum.dart';


class Login extends StatefulWidget {
  final Function changeLoginStatus;
  const Login({super.key, required this.changeLoginStatus});


  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formStateKey = GlobalKey<FormState>();

  bool isClicked = false;

  AuthenticationService authenticationService = AuthenticationService();

  String mail = '';
  String password = '';
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorlib.backgroundColor,
        appBar: AppBar(
          toolbarHeight: 130,
          backgroundColor: colorlib.backgroundColor,
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
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Impressum()));
                },
                icon: const Icon(Icons.info,
                color: Colors.white),
                label: const Text('Impressum',
                  style: TextStyle(color: Colors.white),)),
            TextButton.icon(
                onPressed: () async {
                  widget.changeLoginStatus();
                },
                icon: const Icon(Icons.account_box_rounded,
                    color: Colors.white),
                label: const Text('Register',
                  style: TextStyle(color: Colors.white),))
          ],
        ),
        body: Container(

          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
              key: formStateKey,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SvgPicture.asset(Images.logoSvg),
          ),
    ],
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    style: TextStyle(color: Colors.white), // Weiße Textfarbe
                    decoration: InputDecoration(
                      hintText: 'E-Mail',
                      filled: true,
                      fillColor: colorlib.grey, // Dunkelgrauer Hintergrund
                      hintStyle: TextStyle(color: Colors.grey), // Weiße Schriftfarbe für den Platzhalter
                      labelStyle: TextStyle(color: Colors.white), // Weiße Schriftfarbe für den Label-Text
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // Weiße Umrandung
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return 'Enter E-Mail address';
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        mail = value;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    style: TextStyle(color: Colors.white), // Weiße Textfarbe
                    decoration: InputDecoration(
                      hintText: 'password',
                      filled: true,
                      fillColor: colorlib.grey, // Dunkelgrauer Hintergrund
                      hintStyle: TextStyle(color: Colors.grey), // Weiße Schriftfarbe für den Platzhalter
                      labelStyle: TextStyle(color: Colors.white), // Weiße Schriftfarbe für den Label-Text
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // Weiße Umrandung
                      ),
                    ),
                    validator: (value){
                      if(password.length < 6) return 'Enter a password with at least 6 characters';
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      if(formStateKey.currentState!.validate()){
                        String uid = await authenticationService.loginWithCredentials(mail, password);
                        setState(() {
                          if(uid == '') {
                            errorMessage = 'E-Mail or password was not valid';
                          }
                          else {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(index: 0,)));
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorlib.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: const Text('Login', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      authenticationService.signInWithoutCredentials();
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home(index: 0)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorlib.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: const Text('Go to Home without Outh',
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 30),
                  Text(errorMessage, style: const TextStyle(color: Colors.red)),
                ],
              )),
        ));
  }
}

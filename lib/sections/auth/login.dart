import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mensa_meet_app/sections/auth_home_wrapper.dart';
import 'package:mensa_meet_app/sections/home//homepage.dart';
import 'package:mensa_meet_app/sections/auth/authentication_service.dart';
import 'package:mensa_meet_app/sections/home/home.dart';

import 'package:mensa_meet_app/date_database.dart';

class Login extends StatefulWidget {
  final Function changeLoginStatus;
  Login({required this.changeLoginStatus});

  //const Login({super.key});

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
        //backgroundColor: Colors.deepOrangeAccent,
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          title: Text('Login Page'),
          actions: <Widget>[
            TextButton.icon(
                onPressed: () async {
                  widget.changeLoginStatus();
                },
                icon: Icon(Icons.account_box_rounded),
                label: Text('Register')),
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
              key: formStateKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 30),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'E-Mail'),
                    validator: (value){
                      if(value!.isEmpty) return 'Enter E-Mail adress';
                    },
                    onChanged: (value) {
                      //onChanged runs code inside curly brackets everytime we change something
                      setState(() {
                        mail = value;
                      });
                    },
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Passwort'),
                    validator: (value){
                      if(password!.length < 6) return 'Enter a password with at least 6 characters';
                    },
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    obscureText: true,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    child: Text('Login', style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      if(formStateKey.currentState!.validate()){
                        String uid = await authenticationService.loginWithCredentials(mail, password);
                        setState(() {
                          if(uid == '') {
                            errorMessage = 'E-Mail or password was not valid';
                          }
                          else { 
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()));
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    child: Text('Go to Screen without Outh',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      authenticationService.signInWithoutCredentials();
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(errorMessage, style: TextStyle(color: Colors.red)),
                ],
              )),
        ));
  }
}

/*
child: MaterialButton(
          child: Text('Login Without Credentials'),
          color: Colors.deepOrangeAccent,
          onPressed: () async {
            if(isClicked) return;
            isClicked = true;
            dynamic authenticationAnswer = await authenticationService.signInWithoutCredentials();
            if(authenticationAnswer == null){
              print('login error. returned null');
            }
            else{
              print('anonymous login successful');
              print(authenticationAnswer);
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> AuthHomeWrapper()));
            }
            isClicked = false;
          },
        ),
 */

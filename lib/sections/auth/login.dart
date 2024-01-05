import 'package:flutter/material.dart';
import 'package:mensa_meet_app/sections/home//homepage.dart';
import 'package:mensa_meet_app/service/authentication_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  AuthenticationService authenticationService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.deepOrangeAccent,
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text('Login Page'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: MaterialButton(
          child: Text('Login Without Credentials'),
          color: Colors.deepOrangeAccent,
          onPressed: () async {
            dynamic authenticationAnswer = await authenticationService.signInWithoutCredentials();
            if(authenticationAnswer == null){
              print('login error. returned null');
            }
            else{
              print('anonymous login successful');
              print(authenticationAnswer);
            }
          },
        ),
      )
    );
  }
}

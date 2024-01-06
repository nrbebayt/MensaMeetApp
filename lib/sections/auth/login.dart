import 'package:flutter/material.dart';
import 'package:mensa_meet_app/sections/auth_home_wrapper.dart';
import 'package:mensa_meet_app/sections/home//homepage.dart';
import 'package:mensa_meet_app/sections/auth/authentication_service.dart';
import 'package:mensa_meet_app/sections/home/home.dart';

class Login extends StatefulWidget {
  final Function changeLoginStatus;
  Login({required this.changeLoginStatus});

  //const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool isClicked = false;

  AuthenticationService authenticationService = AuthenticationService();

  String mail = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.deepOrangeAccent,
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text('Login Page'),
        actions: <Widget>[
          TextButton.icon(
              onPressed:() async{
                widget.changeLoginStatus();
              },
              icon: Icon(Icons.account_box_rounded),
              label: Text('Register')),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          child: Column(
            children: <Widget>[
              SizedBox(height:30),
              TextFormField(
                onChanged: (value) { //onChanged runs code inside curly brackets everytime we change something
                  setState(() {
                    mail = value;
                  });
                },
              ),
              SizedBox(height:30),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                obscureText: true,
              ),
              SizedBox(height:30),
              ElevatedButton(
                child: Text(
                    'Login', style: TextStyle(color: Colors.white)
                ),
                onPressed: () async {
                  //use mail and pw to login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ),
              ElevatedButton(
                child: Text(
                    'Go to Screen without Outh', style: TextStyle(color: Colors.white)
                ),
                onPressed: () async {
                  authenticationService.signInWithoutCredentials();
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              )
            ],
          )
        ),
      )
    );
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

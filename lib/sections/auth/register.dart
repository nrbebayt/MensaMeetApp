import 'package:flutter/material.dart';
import 'package:mensa_meet_app/sections/auth/authentication.dart';
import 'package:mensa_meet_app/sections/auth_home_wrapper.dart';
import 'package:mensa_meet_app/sections/home/homepage.dart';
import 'package:mensa_meet_app/sections/auth/authentication_service.dart';


class Register extends StatefulWidget {
  final Function changeLoginStatus;
  Register({required this.changeLoginStatus});


  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  GlobalKey<FormState> formStateKey = GlobalKey<FormState>();
  bool isClicked = false;

  AuthenticationService authenticationService = AuthenticationService();

  String email = '';
  String password = '';
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          title: Text('Register Page'),
          actions: <Widget>[
            TextButton.icon(
                onPressed:() async{
                  widget.changeLoginStatus();
                },
                icon: Icon(Icons.account_box_rounded),
                label: Text('Login')),
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
              key: formStateKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height:30),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'E-Mail'),
                    validator: (value){
                      if(value!.isEmpty) return 'Enter E-Mail adress';
                    },
                    onChanged: (value) { //onChanged runs code inside curly brackets everytime we change something
                      setState(() {
                        setState(() {
                          email = value;
                        });
                      });
                    },
                  ),
                  SizedBox(height:30),
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
                  SizedBox(height:30),
                  ElevatedButton(
                    child: Text(
                        'Register', style: TextStyle(color: Colors.white)
                    ),
                    onPressed: () async {
                      if(formStateKey.currentState!.validate()){
                        String uid = await authenticationService.registerWithCredentials(email, password);
                        setState(() {
                          if(uid == '') {
                            errorMessage = 'E-Mail or password was not valid';
                          }
                          else {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> AuthHomeWrapper()));
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
                  SizedBox(height: 30),
                  Text(errorMessage, style: TextStyle(color: Colors.red)),
                ],
              )
          ),
        )
    );
  }
}

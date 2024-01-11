import 'package:flutter/material.dart';
import 'package:mensa_meet_app/sections/auth_home_wrapper.dart';
import 'package:mensa_meet_app/sections/auth/authentication_service.dart';

import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mensa_meet_app/sections/supportClass/_Colors.dart';

import '../auth/authentication_service.dart';
import '../auth_home_wrapper.dart';
import '../supportClass/_Images.dart';


class Register extends StatefulWidget {
  final Function changeLoginStatus;
  const Register({super.key, required this.changeLoginStatus});


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
      backgroundColor: colorlib.backgroundColor,
        appBar: AppBar(
          toolbarHeight: 130,
          backgroundColor: colorlib.backgroundColor,
          title: Padding(
            padding: const EdgeInsets.only(top: 15, left: 15),
            child: SvgPicture.asset(Images.register),
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
                onPressed: () async {
                  widget.changeLoginStatus();
                },
                icon: const Icon(Icons.login_outlined,
                    color: Colors.white),
                label: const Text('Login',
                  style: TextStyle(color: Colors.white),))
          ],
        ),
        body: Container(

          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
              key: formStateKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(height:30),
                  TextFormField(
                    decoration: const InputDecoration(hintText: 'E-Mail'),
                    validator: (value){
                      if(value!.isEmpty) return 'Enter E-Mail adress';
                      return null;
                    },
                    onChanged: (value) { //onChanged runs code inside curly brackets everytime we change something
                      setState(() {
                        setState(() {
                          email = value;
                        });
                      });
                    },
                  ),
                  const SizedBox(height:30),
                  TextFormField(
                    decoration: const InputDecoration(hintText: 'Passwort'),
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
                  const SizedBox(height:30),
                  ElevatedButton(
                    onPressed: () async {
                      if(formStateKey.currentState!.validate()){
                        String uid = await authenticationService.registerWithCredentials(email, password);
                        setState(() {
                          if(uid == '') {
                            errorMessage = 'E-Mail or password was not valid';
                          }
                          else {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> const AuthHomeWrapper()));
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
                    child: const Text(
                        'Register', style: TextStyle(color: Colors.white)
                    ),

                  ),
                  const SizedBox(height: 30),
                  Text(errorMessage, style: const TextStyle(color: Colors.red)),
                ],
              )
          ),

        )
    );
  }
}

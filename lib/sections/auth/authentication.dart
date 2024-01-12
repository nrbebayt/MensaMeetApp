import 'package:flutter/material.dart';
import 'package:mensa_meet_app/sections/auth/login.dart';
import 'package:mensa_meet_app/sections/auth/register.dart';

enum LoginStatus{
  atRegisterPage,
  atLoginPage
}

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {

  LoginStatus status = LoginStatus.atLoginPage;

  ///Method to switch between the Login and Register Screen.
  void switchBetweenLoginAndRegister(){
    setState(() {
      if(status == LoginStatus.atRegisterPage) {
        status = LoginStatus.atLoginPage;
      }
      else if(status == LoginStatus.atLoginPage) {
        status = LoginStatus.atRegisterPage;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(status == LoginStatus.atRegisterPage){
      return Register(changeLoginStatus: switchBetweenLoginAndRegister);
    }
    else {
      return Login(changeLoginStatus: switchBetweenLoginAndRegister);
    }
  }
}


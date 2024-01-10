import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mensa_meet_app/sections/home//homepage.dart';
import 'package:mensa_meet_app/sections/auth/authentication.dart';
import 'package:mensa_meet_app/sections/home/home.dart';

import 'auth/authentication_service.dart';

class AuthHomeWrapper extends StatelessWidget {
  const AuthHomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // return either homepage or authentication (later on)
    AuthenticationService authenticationService = AuthenticationService();
    if (FirebaseAuth.instance.currentUser == null){
      return Authentication();
    }
    else {
      return Home(index: 0);
    }
  }
}

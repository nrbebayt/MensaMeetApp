import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService{

  ///Bypasses authentication and signs in anonymously.
  Future signInWithoutCredentials() async {
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
      return userCredential.user;
    } catch(e){
      log(e.toString());
      return null;
    }
  }

  ///Tries to login using the FirebaseAuth signInWithEmailAndPassword function using the given email and password.
  Future loginWithCredentials(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      return user?.uid;
    }
    catch(e){
      log(e.toString());
    }
    return '';
  }

  ///Tries to sign up using the FirebaseAuth createUserWithEmailAndPassword function using the given email and password.
  Future registerWithCredentials(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      return user!.uid;
    }
    catch(e){
      log(e.toString());
    }
    return '';
  }

  Future logout() async{
    FirebaseAuth.instance.signOut();
  }
}
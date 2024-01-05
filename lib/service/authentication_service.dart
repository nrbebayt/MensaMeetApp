import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService{

  FirebaseAuth authenticator = FirebaseAuth.instance;

  Future signInWithoutCredentials() async {
    try{
      UserCredential userCredential = await authenticator.signInAnonymously();
      return userCredential.user;
    } catch(e){
      print(e.toString());
      return null;
    }
  }

// todo sign in with email and pw
}
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

  Future registerWithCredentials(String email, String password) async {
    try {
      UserCredential userCredential = await authenticator.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      return user?.uid;
    }
    catch(e){
      print(e.toString());
    }
    return '';
  }

// todo sign in with email and pw
}
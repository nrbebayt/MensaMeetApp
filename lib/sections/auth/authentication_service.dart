import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService{

  FirebaseAuth authenticator = FirebaseAuth.instance;

  //bypasses authentication and signs in anonymously
  Future signInWithoutCredentials() async {
    try{
      UserCredential userCredential = await authenticator.signInAnonymously();
      return userCredential.user;
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //tries to login using the FirebaseAuth signInWithEmailAndPassword function using the given email and password
  Future loginWithCredentials(String email, String password) async {
    try {
      UserCredential userCredential = await authenticator.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      return user?.uid;
    }
    catch(e){
      print(e.toString());
    }
    return '';
  }

  //tries to sign up using the FirebaseAuth createUserWithEmailAndPassword function using the given email and password
  Future registerWithCredentials(String email, String password) async {
    try {
      UserCredential userCredential = await authenticator.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      //await DateDatabase().refresh(user!.uid, "irgendein Name", "irgendwas");
      return user!.uid;
    }
    catch(e){
      print(e.toString());
    }
    return '';
  }

  Future logout() async{
    FirebaseAuth.instance.signOut();
  }

// todo sign in with email and pw
}
import 'package:flutter/material.dart';
import 'package:mensa_meet_app/sections/auth/authentication_service.dart';
import 'package:mensa_meet_app/sections/home/home.dart';


class Login extends StatefulWidget {
  final Function changeLoginStatus;
  const Login({super.key, required this.changeLoginStatus});


  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formStateKey = GlobalKey<FormState>();

  bool isClicked = false;

  AuthenticationService authenticationService = AuthenticationService();

  String mail = '';
  String password = '';
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          title: const Text('Login Page'),
          actions: <Widget>[
            TextButton.icon(
                onPressed: () async {
                  widget.changeLoginStatus();
                },
                icon: const Icon(Icons.account_box_rounded),
                label: const Text('Register')),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
              key: formStateKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: const InputDecoration(hintText: 'E-Mail'),
                    validator: (value){
                      if(value!.isEmpty) return 'Enter E-Mail adress';
                      return null;
                    },
                    onChanged: (value) {
                      //onChanged runs code inside curly brackets everytime we change something
                      setState(() {
                        mail = value;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
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
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      if(formStateKey.currentState!.validate()){
                        String uid = await authenticationService.loginWithCredentials(mail, password);
                        setState(() {
                          if(uid == '') {
                            errorMessage = 'E-Mail or password was not valid';
                          }
                          else { 
                            Navigator.pop(context);

                            Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(index: 0,)));
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
                    child: const Text('Login', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      authenticationService.signInWithoutCredentials();
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home(index: 0)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: const Text('Go to Screen without Outh',
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 30),
                  Text(errorMessage, style: const TextStyle(color: Colors.red)),
                ],
              )),
        ));
  }
}

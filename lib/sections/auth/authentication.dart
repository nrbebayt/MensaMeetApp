import 'package:flutter/material.dart';
import 'package:mensa_meet_app/sections/auth/login.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Login(),
    );
  }
}


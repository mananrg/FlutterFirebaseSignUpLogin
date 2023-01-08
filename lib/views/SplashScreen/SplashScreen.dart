import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grequizapp/views/LoginScreen/LoginScreen.dart';
import 'package:grequizapp/views/MainScreen/MainScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTimer() {
    Timer(
      const Duration(seconds: 5),
      () async {
        SharedPreferences prefs =await SharedPreferences.getInstance();
        var email=prefs.getString("email");
        email==null?Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen())) :Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen()));
       /* Route newRoute = MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ):
        Route newRoute = MaterialPageRoute(
        builder: (context) => const LoginScreen(),
        );
        Navigator.pushReplacement(context, newRoute);*/
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: const [Text("SplashScreen"),],
      ),
    );
  }
}

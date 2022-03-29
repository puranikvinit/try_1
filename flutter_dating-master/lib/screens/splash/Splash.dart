import 'package:flutter/material.dart';
import 'package:folx_dating/auth/auth.dart';
import 'package:folx_dating/firebase/cloud_store.dart';
import 'package:folx_dating/screens/home/HomeScreen.dart';
import 'package:folx_dating/screens/signup/SignUpLanding.dart';
import 'package:folx_dating/styles/StringConstants.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (FireBase.auth.currentUser != null) {
      //refresh my user
      DatabaseService ds = DatabaseService();
      ds.snapshotMyUserData().then((value) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          )));
    } else {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpLandingScreen(),
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Image.asset(imagePath + "splash.jpg"));
  }
}

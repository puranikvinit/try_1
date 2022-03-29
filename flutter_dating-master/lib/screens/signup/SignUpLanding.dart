import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:folx_dating/screens/login/LoginParent.dart';
import 'package:folx_dating/screens/pages/PagingParent.dart';
import 'package:folx_dating/styles/ColorConstants.dart';
import 'package:folx_dating/styles/StringConstants.dart';

class SignUpLandingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpLandingScreen> {
  @override
  void initState() {
    print("SignupState");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath + "splash.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            padding: EdgeInsets.only(bottom: 48),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: RaisedButton(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut().whenComplete(() {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PagingParent()));
                        });
                      },
                      child: Text(
                        'Start Meeting Folx',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: hexToColor("#FF6B6B"),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginParent()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(21),
                    child: Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

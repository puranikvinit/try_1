import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:folx_dating/firebase/cloud_store.dart';
import 'package:folx_dating/models/User.dart';
import 'package:folx_dating/screens/home/HomeScreen.dart';
import 'package:folx_dating/screens/pages/pagelist/PhoneAuthentication.dart';
import 'package:folx_dating/screens/signup/SignUpLanding.dart';
import 'package:folx_dating/styles/ColorConstants.dart';

class LoginParent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginParentSt();
}

class _LoginParentSt extends State<LoginParent> {
  @override
  void initState() {
    print("LoginParent");
    // getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBg,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 68),
          child: PhoneAuthentication(FolxUser(), _loginAction, true),
        ),
      ),
    );
  }

  _loginAction() {
    print("_loginAction");
    DatabaseService ds = new DatabaseService();
    showProgress();
    ds.snapshotMyUserData().then((value) async {
      try {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            ModalRoute.withName("/Home"));
      } catch (e) {
        print("catching error, $e");
        showAlertDialog(context, "Login Failed. Please try again", () {
          FirebaseAuth.instance.signOut().whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SignUpLandingScreen()),
                ModalRoute.withName("/SignUp"));
          });
        }, null);
      }
    }).catchError((e) {
      print("catch error $e");
      showAlertDialog(context, "Login Failed. Please try again", () {
        FirebaseAuth.instance.signOut().whenComplete(() {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SignUpLandingScreen()),
              ModalRoute.withName("/SignUp"));
        });
      }, null);
    });
  }

  void showAlertDialog(
      BuildContext context, String titleTxt, Function yes, Function no) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(titleTxt),
              actions: [
                FlatButton(
                    onPressed: () {
                      yes();
                      Navigator.of(context).pop();
                    },
                    child: Text("OK")),
                // FlatButton(onPressed: no, child: Text("OK")),
              ],
            ),
        barrierDismissible: false);
  }

  void showProgress() {
    Theme(
      data: Theme.of(context).copyWith(accentColor: Colors.white),
      child: CircularProgressIndicator(
        backgroundColor: secondaryBg,
        semanticsLabel: "Uploading in progress",
      ),
    );
  }
}

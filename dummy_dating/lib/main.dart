//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_dating/screens/delete/delete_screen_page_1.dart';
import 'package:dummy_dating/screens/delete/delete_screen_page_2.dart';
import 'package:dummy_dating/screens/referrels/referals_screen.dart';
import 'package:dummy_dating/screens/subscriptions/subscription_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:random_string/random_string.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String referralCode = randomAlpha(6) + randomNumeric(3) + randomAlpha(1);
  await _firebaseAuth
      .createUserWithEmailAndPassword(
    email: 'xyz@gmail.com',
    password: 'Venkatneeta1',
  )
      .then(
    (value) {
      FirebaseFirestore.instance
          .collection('test_collection')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .set(
        {
          'referral code': referralCode,
          'history index': 0,
          'used referrals': [],
          'subscriber of': "None",
          'order id': null,
          'user name': _firebaseAuth.currentUser.uid,
        },
      );
    },
  );

  runApp(
    ScreenUtilInit(
      builder: () {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Dummy Dating",
          // home: Subscription(),
          home: ReferalsScreen(),
          // home: DeleteScreenPart1(),
          // home: DeleteScreenPart2(),
        );
      },
      designSize: Size(
        360,
        780,
      ),
      allowFontScaling: false,
    ),
  );
}

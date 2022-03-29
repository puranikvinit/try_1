//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';

class DeleteScreenPart2 extends StatefulWidget {
  const DeleteScreenPart2({Key key}) : super(key: key);

  @override
  State<DeleteScreenPart2> createState() => _DeleteScreenPart2State();
}

class _DeleteScreenPart2State extends State<DeleteScreenPart2> {
  List<bool> isSel = [false, false, false, false, false, false];
  TextEditingController feedbackController = TextEditingController();
  User firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(
          0xFF9649CB,
        ),
        leading: Container(
          child: Icon(
            Icons.close,
          ),
        ),
        title: Text(
          "Delete account",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 26.h,
            ),
            Container(
              child: Text(
                "Before you delete could you tell us",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 14.0,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 2.h,
              ),
              child: Text(
                "why?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ),
            Container(
              height: 31.h,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isSel[0] = !isSel[0];
                });
              },
              child: Container(
                height: 50.h,
                width: 311.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(
                      isSel[0] ? 0xFF9649CB : 0xFFF2F4F5,
                    ),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      10.r,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Icon(
                        Icons.watch_later,
                        color: Color(
                          0xFF6B9DFF,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 44.w,
                      ),
                      child: Text("Something is broken"),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 14.h,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isSel[1] = !isSel[1];
                });
              },
              child: Container(
                height: 50.h,
                width: 311.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(
                      isSel[1] ? 0xFF9649CB : 0xFFF2F4F5,
                    ),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      10.r,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Icon(
                        Icons.favorite_border,
                        color: Color(
                          0xFFD621A6,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 44.w,
                      ),
                      child: Text("Met someone special"),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 14.h,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isSel[2] = !isSel[2];
                });
              },
              child: Container(
                height: 50.h,
                width: 311.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(
                      isSel[2] ? 0xFF9649CB : 0xFFF2F4F5,
                    ),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      10.r,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Icon(
                        Icons.help_outline,
                        color: Color(
                          0xFF916BFF,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 44.w,
                      ),
                      child: Text("Confused, how it works"),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 14.h,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isSel[3] = !isSel[3];
                });
              },
              child: Container(
                height: 50.h,
                width: 311.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(
                      isSel[3] ? 0xFF9649CB : 0xFFF2F4F5,
                    ),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      10.r,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Icon(
                        Icons.free_breakfast,
                        color: Color(
                          0xFFE17A00,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 44.w,
                      ),
                      child: Text("Need a break"),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 14.h,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isSel[4] = !isSel[4];
                });
              },
              child: Container(
                height: 50.h,
                width: 311.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(
                      isSel[4] ? 0xFF9649CB : 0xFFF2F4F5,
                    ),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      10.r,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Icon(
                        Icons.thumb_down,
                        color: Color(
                          0xFFFF2727,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 44.w,
                      ),
                      child: Text("I don’t like this app"),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 14.h,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isSel[5] = !isSel[5];
                });
              },
              child: Container(
                height: 50.h,
                width: 311.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(
                      isSel[5] ? 0xFF9649CB : 0xFFF2F4F5,
                    ),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      10.r,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Icon(
                        Icons.edit,
                        color: Color(
                          0xFF13D2B0,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 44.w,
                      ),
                      child: Text("Others"),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 19.h,
            ),
            Container(
              height: 101.h,
              width: 311.w,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(
                    0xFFF2F4F5,
                  ),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    10.r,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(
                  8.0,
                ),
                child: TextFormField(
                  controller: feedbackController,
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                      hintText: "Feedback us", border: InputBorder.none),
                ),
              ),
            ),
            Container(
              height: 19.h,
            ),
            GestureDetector(
              onTap: () async {
                int check = 0;
                for (int i = 0; i < 6; i++) {
                  if (isSel[i] == false) check++;
                }
                if (check == 6) {
                  Toast.show(
                    "Please Select an Option!",
                    context,
                    duration: Toast.LENGTH_SHORT,
                    gravity: Toast.BOTTOM,
                  );
                } else {
                  //Delete acc logic
                  await firebaseUser.delete();
                  Toast.show(
                    "Account Deleted Successfully!",
                    context,
                    duration: Toast.LENGTH_SHORT,
                    gravity: Toast.BOTTOM,
                  );
                  Navigator.pop(context);
                }
              },
              child: Container(
                height: 52.h,
                width: 327.w,
                decoration: BoxDecoration(
                  color: Color(
                    0xFF9649CB,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      30.r,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Delete account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

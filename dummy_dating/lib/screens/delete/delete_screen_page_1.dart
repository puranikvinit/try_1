//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'package:dummy_dating/screens/delete/delete_screen_page_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeleteScreenPart1 extends StatefulWidget {
  const DeleteScreenPart1({Key key}) : super(key: key);

  @override
  State<DeleteScreenPart1> createState() => _DeleteScreenPart1State();
}

class _DeleteScreenPart1State extends State<DeleteScreenPart1> {
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
            fontSize: 20,
          ),
        ),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Container(
            height: 110.h,
          ),
          Icon(
            Icons.error_outline,
            color: Color(
              0xFFFF3131,
            ),
            size: 44.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 17.w,
              vertical: 16.h,
            ),
            child: Text(
              "If you delete the account, you will permenently loose your profile, messages, photos and matches",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            height: 328.h,
          ),
          GestureDetector(
            onTap: () {
              //Logic to Pause the acc.
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
                  "Pause my account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 18.h,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return DeleteScreenPart2();
                  },
                ),
              );
            },
            child: Container(
              height: 52.h,
              width: 327.w,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Color(
                    0xFFFF6B6B,
                  ),
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
                    color: Color(
                      0xFFFF6B6B,
                    ),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

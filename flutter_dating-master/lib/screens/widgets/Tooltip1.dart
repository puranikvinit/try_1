import 'dart:math';

import 'package:flutter/material.dart';
import 'package:folx_dating/styles/ColorConstants.dart';
import 'package:folx_dating/styles/StringConstants.dart';
import 'package:google_fonts/google_fonts.dart';

import 'IconAndTextWidget.dart';

class ToolTip1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Spacer(),
              TextIcon(
                Icons.arrow_left,//TODO: subdirectory_arrow_left_rounded
                'Explore profiles \naround the world',
                iconTransform: 90 * pi / 180,
                iconSize: 24,
              ),
              Spacer()
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 48,
              right: 48,
            ),
            child: Text(
              'Welcome to the best way to meet people!',
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Icon(
            Icons.arrow_upward,//TODO: arrow_upward_rounded
            color: secondaryBg,
            size: 48,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'Swipe up to like',
            style: getDefaultTextStyle()
                .copyWith(letterSpacing: 0.64, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 34,
          ),
          Text(
            'Swipe down to skip',
            style: getDefaultTextStyle()
                .copyWith(letterSpacing: 0.64, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 12,
          ),
          Icon(
            Icons.arrow_downward,//TODO: arrow_downward_rounded
            color: secondaryBg,
            size: 48,
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 120),
            child: Text(
              'Tap Anywhere To Continue',
              style: getDefaultTextStyle().copyWith(
                fontSize: 12,
                letterSpacing: 0.48,
              ),
            ),
          )
        ],
      ),
    );
  }
}

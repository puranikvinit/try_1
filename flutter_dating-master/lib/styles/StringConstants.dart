import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ColorConstants.dart';

final String imagePath = "assets/images/";

//styles
TextStyle getDefaultTextStyle() {
  return GoogleFonts.montserrat(
    textStyle: TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
  );
}

TextStyle getDefaultDarkTextStyle() {
  return GoogleFonts.montserrat(
    textStyle: TextStyle(
      color: darkFontColor,
      fontSize: 14,
    ),
  );
}

TextStyle getDefaultBoldTextStyle() {
  return GoogleFonts.montserrat(
    textStyle: TextStyle(
        color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
  );
}

TextStyle getDefaultDarkBoldTextStyle() {
  return GoogleFonts.montserrat(
    textStyle: TextStyle(
      color: darkFontColor,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  );
}

InputDecoration getDefaultInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: getDefaultTextStyle(),
    focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
  );
}

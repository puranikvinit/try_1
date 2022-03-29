import 'package:flutter/material.dart';

final Color primaryBg = Color(0xFF9649CB);
final Color secondaryBg = hexToColor("#FF6B6B");
final Color darkFontColor = hexToColor("#2C2C2C");

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

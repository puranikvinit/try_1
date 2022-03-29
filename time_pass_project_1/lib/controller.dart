//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'dart:async';

import 'package:get/get.dart';

class TimerController extends GetxController {
  var timer = 60.obs;
  var flag = true.obs;

  Future updateTimer() async {
    while (timer.value > 0) {
      if (flag.value == false) {
        timer.value = 60;
        break;
      }
      await Future.delayed(const Duration(seconds: 1), () {
        timer.value--;
      });
    }
  }
}
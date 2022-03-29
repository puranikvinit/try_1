//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_pass_project_1/controller.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Timer App",
    theme: ThemeData(primaryColor: Colors.black),
    home: const HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    TimerController timerController = Get.put(TimerController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timer"),
        centerTitle: true,
        backgroundColor:Colors.white10,
        foregroundColor: Colors.black,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => Text(
                timerController.timer.value.toString(),
                style: const TextStyle(fontSize: 80.0),
              ),
            ),
            RaisedButton(
              elevation: 0.0,
                onPressed: () {
                  timerController.flag.value = true;
                  timerController.updateTimer();
                },
                child: const Text("Start")),
            RaisedButton(
              elevation: 0.0,
                onPressed: () {
                  timerController.timer.value = 60;
                },
                child: const Text("Reset")),
            RaisedButton(
              elevation: 0.0,
                onPressed: () {
                  timerController.flag.value = false;
                },
                child: const Text("End"))
          ],
        ),
      ),
    );
  }
}

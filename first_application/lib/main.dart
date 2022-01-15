//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'My First App',
    home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          "My First Screen",
          style: TextStyle(color: Colors.redAccent,fontSize: 25.0),
        ),
      ),
      body: Material(
        color: Colors.black,
        child: Center(
          child: Text(
            "Hello World",
            textDirection: TextDirection.ltr,
            style: TextStyle(color: Colors.white,fontSize: 50.0),
          ),
        ),
      ),
    ),
  ));
}

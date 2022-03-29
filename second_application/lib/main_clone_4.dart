//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'package:flutter/material.dart';
import 'package:second_application/main_clone_3.dart';

void main() {
  runApp(MaterialApp(
    title: "My Third Application Continues",
    home: Scaffold(
      appBar: AppBar(
        title: Text("My Name is Puranik"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: getLongListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: ("Add Item"),
        onPressed: () {
          //action
        },
      ),
    ),
  ));
}

void showSnackBar(BuildContext context) {
  var sb = SnackBar(
    content: Text("You cannot add items into this list!"),
    action: SnackBarAction(label: "UNDO", onPressed: () {}),
  );
  ScaffoldMessenger.of(context).showSnackBar(sb);
}

class Homey extends StatefulWidget {
  const Homey({ Key? key }) : super(key: key);

  @override
  _HomeyState createState() => _HomeyState();
}

class _HomeyState extends State<Homey> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
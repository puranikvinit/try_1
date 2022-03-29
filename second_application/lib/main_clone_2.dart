//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: "My Third App",
    home: Scaffold(
      appBar: AppBar(
        title: Text("Exploring List View!"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: getListView(),
    ),
  ));
}

Widget getListView() {
  var listView = ListView(
    children: [
      ListTile(
        leading: Icon(Icons.access_alarm_sharp),
        title: Text("Alarm"),
        subtitle: Text("04:30"),
        trailing: Icon(Icons.add_comment_outlined),
      ),
      ListTile(
        leading: Icon(Icons.access_alarm_sharp),
        title: Text("Alarm"),
        subtitle: Text("05:30"),
        trailing: Icon(Icons.add_comment_outlined),
      )
    ],
  );

  return listView;
}

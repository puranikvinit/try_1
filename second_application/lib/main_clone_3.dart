//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: "My Third Application Continues",
    home: Scaffold(
      appBar: AppBar(
        title: Text("Exploring A Long List"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: getLongListView(),
    ),
  ));
}

List<String> getListElements() {
  var listEle = List<String>.generate(1000, (index) => "Item $index");
  return listEle;
}

Widget getLongListView() {
  var listEle = getListElements();
  var listView = ListView.builder(itemBuilder: (context, index) {
    return ListTile(
      trailing: Icon(Icons.arrow_forward),
      title: Text(listEle[index]),
    );
  });
  return listView;
}

//Here, at the end, you get a RangeError saying that index 1000 is not inclusive in the specified range...
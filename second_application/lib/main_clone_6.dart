//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "My 6th App",
    home: SIForm(),
    theme: ThemeData(accentColor: Colors.black, brightness: Brightness.dark, primaryColor: Colors.indigo),
  ));
}

class SIForm extends StatefulWidget {
  const SIForm({Key? key}) : super(key: key);

  @override
  _SIFormState createState() => _SIFormState();
}

class _SIFormState extends State<SIForm> {
  var _currencies = ['Rupees', 'Dollars', 'Pounds', 'Others'];
  var _currentValSel = '';

  Widget addImg() {
    AssetImage aimg = AssetImage('images/money.png');
    Image img = Image(image: aimg);
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      alignment: Alignment.topCenter,
      child: img,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Simple Interest Calculator"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          children: [
            addImg(),
            SizedBox(height: 70.0),
            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    label: Text("Principal"),
                    hintText: "Enter Principal Amt",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    label: Text("Rate of Interest"),
                    hintText: "Enter Rate of Interest",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 30.0, right: 10.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          label: Text("Term"),
                          hintText: "Enter Term of Borrow",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 30.0),
                    child: DropdownButton(
                        items: _currencies.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        value: 'Rupees',
                        onChanged: (String? newValue) {}),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50.0),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 30.0, right: 10.0),
                    child: RaisedButton(
                        color: Colors.black,
                        child: Text(
                          "Calculate",
                          style: TextStyle(color: Colors.white),
                        ),
                        elevation: 6.0,
                        onPressed: () {}),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 30.0),
                    child: RaisedButton(
                        color: Colors.black,
                        child: Text(
                          "Reset",
                          style: TextStyle(color: Colors.white),
                        ),
                        elevation: 6.0,
                        onPressed: () {}),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 160.0, right: 160.0),
              child: Text(
                "Interest: ",
                style: TextStyle(fontSize: 30.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}

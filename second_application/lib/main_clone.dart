//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Tip Calculator",
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tip Calculator",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Tipsy(),
    );
  }
}

class Tipsy extends StatefulWidget {
  @override
  State<Tipsy> createState() => _TipsyState();
}

class _TipsyState extends State<Tipsy> {
  final myCont1 = TextEditingController();

  final myCont2 = TextEditingController();

  final myCont3 = TextEditingController();

  double result = -1;

  void funcLogic() {
    double tot = double.parse(myCont1.text);
    double tipp = double.parse(myCont2.text);
    double npeep = double.parse(myCont3.text);

    setState(() {
      this.result = (tot + tot * tipp / 100) / npeep;
      this.result = double.parse(result.toStringAsFixed(2));
    });
  }

  void ansDisp(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text("Successfully Calculated"),
      content: Text("The Amount to be paid by each person is: Rs.${result}"),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Enter the Total Amount:",
          style: TextStyle(color: Colors.black),
        ),
        Container(
          padding: EdgeInsets.only(left: 175.0, right: 175.0),
          child: TextFormField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: myCont1,
          ),
        ),
        SizedBox(
          height: 50.0,
        ),
        Text(
          "Enter the Tip Percentage:",
          style: TextStyle(color: Colors.black),
        ),
        Container(
          padding: EdgeInsets.only(left: 175.0, right: 175.0),
          child: TextFormField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: myCont2,
          ),
        ),
        SizedBox(
          height: 50.0,
        ),
        Text(
          "Enter the Number of People:",
          style: TextStyle(color: Colors.black),
        ),
        Container(
          padding: EdgeInsets.only(left: 175.0, right: 175.0),
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: myCont3,
          ),
        ),
        SizedBox(
          height: 100.0,
        ),
        ElevatedButton(
            onPressed: () {
              funcLogic();
              if(result>-1) ansDisp(context);
            },
            child: Text("Calculate")),
        SizedBox(
          height: 40.0,
        ),
      ],
    );
  }
}

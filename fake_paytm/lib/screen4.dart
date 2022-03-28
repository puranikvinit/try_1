//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'package:flutter/material.dart';

class PaymentSuccess extends StatefulWidget {
  String recUpi;
  String recName;
  String amount;
  PaymentSuccess({Key key, this.recName, this.recUpi, this.amount})
      : super(key: key);

  @override
  _PaymentSuccessState createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  String rUpi;
  String rName;
  String amt;
  @override
  void initState() {
    rUpi = widget.recUpi;
    rName = widget.recName;
    amt = widget.amount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PayTm"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Paid Successfully!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40.0),
          ),
          Container(
            height: 100.0,
          ),
          Text(
            "Paid To: $rName",
            style: TextStyle(fontSize: 20.0),
          ),
          Container(
            height: 20.0,
          ),
          Text(
            "UPI: $rUpi",
            style: TextStyle(fontSize: 20.0),
          ),
          Container(
            height: 50.0,
          ),
          Text(
            "Amount: Rs. $amt",
            style: TextStyle(fontSize: 30.0),
          ),
        ],
      ),
    );
  }
}

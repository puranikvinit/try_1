//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';

class PaymentSuccess extends StatefulWidget {
  String recUpi;
  String recName;
  String amount;
  String phone;
  PaymentSuccess({Key key, this.recName, this.recUpi, this.amount, this.phone})
      : super(key: key);

  @override
  _PaymentSuccessState createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  String rUpi;
  String rName;
  String amt;
  String phno;
  @override
  void initState() {
    rUpi = widget.recUpi;
    rName = widget.recName;
    amt = widget.amount;
    phno = widget.phone;
    sendSuccessMsg(rName,amt,phno);
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

  sendSuccessMsg(String name, String amt, String phno) async {
    String _result =
        await sendSMS(message: "Rs.$amt to $rUpi", recipients: [phno])
            .catchError((onError) {
      print(onError);
    });
    print(_result);
  }
}

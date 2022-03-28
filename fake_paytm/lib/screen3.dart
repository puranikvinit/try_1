//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'package:fake_paytm/screen4.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  String recUpi;
  String recName;
  PaymentScreen({Key key, this.recUpi, this.recName}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String rUpi;
  String rName;
  @override
  void initState() {
    rUpi = widget.recUpi;
    rName = widget.recName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final amtInp = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("PayTm"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Enter Amount:",
            style: TextStyle(fontSize: 20.0),
          ),
          Container(height: MediaQuery.of(context).size.height * 0.03),
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.height * 0.09,
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: Center(
              child: TextFormField(
                controller: amtInp,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                ),
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
          Container(height: MediaQuery.of(context).size.height * 0.03),
          Container(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return PaymentSuccess(
                        recName: rName,
                        recUpi: rUpi,
                        amount: amtInp.text,
                      );
                    },
                  ),
                );
              },
              child: Text(
                "Pay",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

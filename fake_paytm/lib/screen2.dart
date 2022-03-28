//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'package:fake_paytm/screen3.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({Key key}) : super(key: key);

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;
  String scannedData;
  String receiverName = "";
  String receiverUpi = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PayTm"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(height: MediaQuery.of(context).size.height * 0.1),
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.6,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            Container(height: MediaQuery.of(context).size.height * 0.1),
            Container(
              child: result != null
                  ? Container(
                      child: GestureDetector(
                        onTap: () {
                          retrieveDetails();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return PaymentScreen(
                                  recUpi: receiverUpi,
                                  recName: receiverName,
                                );
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Pay Now",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    )
                  : CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(
      (scanData) {
        setState(
          () {
            result = scanData;
          },
        );
      },
    );
  }

  void retrieveDetails() {
    if (result != null) {
      scannedData = result.code;
      int paSt = -1, paEnd = -1, pnSt = -1, pnEnd = -1;
      for (int i = 0; i < scannedData.length; i++) {
        if (scannedData[i] == '=') {
          paSt = i + 1;
          break;
        }
      }
      for (int i = paSt; i < scannedData.length; i++) {
        if (scannedData[i] == '&') {
          paEnd = i - 1;
          break;
        }
      }
      for (int i = paSt; i <= paEnd; i++) {
        receiverUpi += scannedData[i];
      }
      print(receiverUpi);

      for (int i = paEnd; i < scannedData.length; i++) {
        if (scannedData[i] == '=') {
          pnSt = i + 1;
          break;
        }
      }
      for (int i = pnSt; i < scannedData.length; i++) {
        if (scannedData[i] == '&') {
          pnEnd = i - 1;
          break;
        }
      }
      for (int i = pnSt; i <= pnEnd; i++) {
        receiverName += scannedData[i];
      }
      if (receiverName.contains('%200')) {
        receiverName = receiverName.replaceAll('%200', ' ');
      }
      if (receiverName.contains('%20')) {
        receiverName = receiverName.replaceAll('%20', ' ');
      }
      print(receiverName);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

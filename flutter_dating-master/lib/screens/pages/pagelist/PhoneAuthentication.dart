import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:folx_dating/auth/auth.dart';
import 'package:folx_dating/auth/phone_auth.dart';
import 'package:folx_dating/firebase/cloud_store.dart';
import 'package:folx_dating/models/User.dart';
import 'package:folx_dating/styles/ColorConstants.dart';
import 'package:folx_dating/styles/StringConstants.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class PhoneAuthentication extends StatefulWidget {
  final FolxUser user;
  final VoidCallback parentPgAction;
  final bool isFromLogin;
  // final int currentPgSt;

  PhoneAuthentication(this.user, this.parentPgAction, this.isFromLogin);

  @override
  State<StatefulWidget> createState() {
    // if (currentPgSt == PHONE_NUMBER_SCREEN) {
    //   return _PhoneOtp();
    // } else {
    return _PhoneNumberState();
    // }
  }
}

class _PhoneNumberState extends State<PhoneAuthentication> {
  Map<int, String> _phCountryDict = {1 : '+91', 2: '+1'};
  int _value = 1;
  FolxUser user;

  String phoneNumber;
  String actualCode;
  String editedOtp;
  bool phVisiblity = true;

  @override
  void initState() {
    print("PhoneAuthentication");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final phoneAuthDataProvider =
        Provider.of<PhoneAuthDataProvider>(context, listen: false);

    phoneAuthDataProvider.setMethods(
      onStarted: onStarted,
      onError: onError,
      onFailed: onFailed,
      onVerified: onVerified,
      onCodeResent: onCodeResent,
      onAutoRetrievalTimeout: onAutoRetrievalTimeOut,
    );

    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Montserrat",
      ),
      home: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryBg,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: 48,
                    right: 48,
                  ),
                  child: Visibility(
                    visible: phVisiblity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Great to see you!",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "We need some information to help get your account set up.",
                          style: getDefaultTextStyle(),
                        ),
                        SizedBox(
                          height: 83,
                        ),
                        Row(
                          children: [
                            Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: hexToColor("#FF6B6B"),
                              ),
                              child: SizedBox(
                                width: 60,
                                child: DropdownButtonFormField(
                                  decoration:
                                      InputDecoration.collapsed(hintText: ''),
                                  iconEnabledColor: Colors.white,
                                  style: getDefaultTextStyle(),
                                  value: _value,
                                  items: [
                                    DropdownMenuItem(
                                      child: Text(
                                        _phCountryDict[_value],
                                      ),
                                      value: 1,
                                    ),
                                    DropdownMenuItem(
                                      child: Text(
                                        _phCountryDict[_value],
                                      ),
                                      value: 2,
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _value = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: TextFormField(
                              maxLines: 1,
                              minLines: 1,
                              maxLength: 13,
                              style: getDefaultTextStyle(),
                              controller: Provider.of<PhoneAuthDataProvider>(
                                      context,
                                      listen: false)
                                  .phoneNumberController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                counterText: "",
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                isCollapsed: true,
                                hintText: "Phone number",
                                hintStyle: getDefaultTextStyle(),
                              ),
                            )),
                            // RaisedButton(
                            //   onPressed: startPhoneAuth,
                            //   child: const Text('Start verification'),
                            // )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 48,
                    right: 48,
                  ),
                  child: Visibility(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Enter OTP",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "We sent a code to $phoneNumber to make sure we got it right.",
                          style: getDefaultTextStyle(),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                phVisiblity = !phVisiblity;
                              });
                            },
                            child: Text(
                              "Wrong number?",
                              style: getDefaultTextStyle().copyWith(
                                  color: secondaryBg,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 48,
                        ),
                        Wrap(children: [
                          PinCodeTextField(
                            appContext: context,
                            pastedTextStyle: getDefaultTextStyle(),
                            length: 6,
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 24,
                            ),
                            animationType: AnimationType.slide,
                            validator: (v) {
                              if (v.length != 6) {
                                return "Incorrect OTP";
                              }
                              return null;
                            },
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.underline,
                              fieldHeight: 32,
                              activeColor: Colors.white,
                              inactiveColor: hexToColor("#AAAAAA"),
                              fieldWidth: 30,
                            ),
                            animationDuration: Duration(milliseconds: 300),
                            backgroundColor: Colors.transparent,
                            enableActiveFill: false,
                            keyboardType: TextInputType.number,
                            onCompleted: (v) {},
                            onChanged: (value) {
                              print(value);
                              setState(() {
                                editedOtp = value;
                              });
                            },
                          ),
                        ]),
                        SizedBox(
                          width: 20,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              startPhoneAuth(phoneAuthDataProvider);
                            },
                            child: Text(
                              "Resend OTP",
                              style: getDefaultTextStyle().copyWith(
                                  color: secondaryBg,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                    visible: !phVisiblity,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Visibility(
                    visible: phVisiblity ||
                        editedOtp != null && editedOtp.isNotEmpty,
                    child: Row(
                      children: [
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(right: 24, bottom: 40),
                          child: FloatingActionButton(
                            child: Icon(Icons.arrow_forward),
                            backgroundColor: secondaryBg,
                            onPressed: () {
                              if (phVisiblity) {
                                setState(() {
                                  startPhoneAuth(phoneAuthDataProvider);
                                });
                              } else {
                                signIn(editedOtp);
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  onStarted() {
    print("PhoneAuth started");
  }

  onCodeResent() {
    print("OPT resent");
  }

  onVerified() async {
    print(
        "verified -> ${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
    await Future.delayed(Duration(seconds: 1));
    String userId = FireBase.auth.currentUser.uid;
    print(userId);
    widget.user.phoneNumber = phoneNumber;
    widget.parentPgAction();
  }

  onFailed() {
    print("PhoneAuth failed");
  }

  onError() {
    _showSnackBar(
        "PhoneAuth error ${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
    setState(() {
      phVisiblity = true;
    });
  }

  onAutoRetrievalTimeOut() {
    print("PhoneAuth autoretrieval timeout");
  }

  startPhoneAuth(PhoneAuthDataProvider phoneAuthDataProvider) async {
    phoneAuthDataProvider.loading = true;
    final CollectionReference folxUserCollection = FirebaseFirestore.instance.collection(appUserCollection);
    folxUserCollection.where('pn', isEqualTo: '${_phCountryDict[_value]}${phoneAuthDataProvider.phoneNumberController.text}').get().then((value) async {
      if(value.docs == null || value.docs.isEmpty || widget.isFromLogin) {
        bool validPhone = await phoneAuthDataProvider.instantiate(
          dialCode: _phCountryDict[_value],
          onCodeSent: () {
            phoneNumber = phoneAuthDataProvider.phone;
            setState(() {
              phVisiblity = false;
            });
          },
        );
        if (!validPhone) {
          phoneAuthDataProvider.loading = false;
          _showSnackBar("Oops! Number seems invaild");
          return;
        }
      } else {
        _showSnackBar('Phone number already exists.');
      }
      return ;
    }).catchError((error, stackTrace) => null);//onError
  }

  signIn(String code) {
    if (code.length != 6) {
      _showSnackBar("Invalid OTP");
    }
    Provider.of<PhoneAuthDataProvider>(context, listen: false)
        .verifyOTPAndLogin(smsCode: code);
  }

  _showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text('$text'),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  final scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: "scaffold-get-phone");
}

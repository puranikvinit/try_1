//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReferalsScreen extends StatefulWidget {
  const ReferalsScreen({Key key}) : super(key: key);

  @override
  State<ReferalsScreen> createState() => ReferalsScreenState();
}

class ReferalsScreenState extends State<ReferalsScreen>
    with TickerProviderStateMixin {
  TabController defaultTabController;
  TextEditingController refCode = TextEditingController();
  String referCode;
  String userName;
  User firebaseUser = FirebaseAuth.instance.currentUser;
  List listUsedReferrals;

  updateSubStatus(String subOf, String orderId) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: "xyz@gmail.com",
      password: 'Venkatneeta1',
    );
    User f1 = FirebaseAuth.instance.currentUser;

    var response = await FirebaseFirestore.instance
        .collection('test_collection')
        .doc(f1.uid)
        .get();

    String refer = response.data()["referral code"];
    List histList = response.data()["used referrals"];
    int histInd = response.data()["history index"];

    await FirebaseFirestore.instance
        .collection('test_collection')
        .doc(f1.uid)
        .update(
      {
        'referral code': refer,
        'history index': histInd,
        'used referrals': histList,
        'subscriber of': subOf,
        'order id': orderId,
      },
    );
  }

  retrieveReferralCode() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: "xyz@gmail.com",
      password: 'Venkatneeta1',
    );

    var response = await FirebaseFirestore.instance
        .collection('test_collection')
        .doc(firebaseUser.uid)
        .get();

    referCode = response.data()["referral code"];

    setState(() {});
  }

  referralHistoryListRetrieve() async {
    var response = await FirebaseFirestore.instance
        .collection('test_collection')
        .doc(firebaseUser.uid)
        .get();

    listUsedReferrals = response.data()["used referrals"];
  }

  updateHistory(String inpCode) async {
    var response1 = await FirebaseFirestore.instance
        .collection('test_collection')
        .doc(firebaseUser.uid)
        .get();

    var response2 = await FirebaseFirestore.instance
        .collection('test_collection')
        .doc(userName)
        .get();

    int histIndUpd1 = response1.data()["history index"] + 1;
    int histIndUpd2 = response2.data()["history index"] + 1;

    String timeOfUse =
        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ~ ${DateTime.now().hour}:${DateTime.now().minute}';

    Map inpMap = {
      'code used': inpCode,
      'time of use': timeOfUse,
      'used user name': userName,
    };

    listUsedReferrals = response1.data()["used referrals"];
    listUsedReferrals.add(inpMap);

    await FirebaseFirestore.instance
        .collection('test_collection')
        .doc(firebaseUser.uid)
        .update(
      {
        'referral code': referCode,
        'history index': histIndUpd1,
        'used referrals': listUsedReferrals,
      },
    );

    await FirebaseFirestore.instance
        .collection('test_collection')
        .doc(userName)
        .update(
      {
        'history index': histIndUpd2,
      },
    );

    await referralHistoryListRetrieve();
    setState(() {});
  }

  Widget retrieveReferralContainer() {
    if (referCode == null) {
      return CircularProgressIndicator();
    } else {
      return Container(
        height: 54.h,
        width: 320.w,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFFCDCDCD),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(
              10.r,
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 10.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DottedBorder(
                dashPattern: [5],
                borderType: BorderType.RRect,
                radius: Radius.circular(
                  10.r,
                ),
                color: Color(0xFF2EC14F),
                child: Container(
                  width: 168.w,
                  child: Center(
                    child: Text(
                      "Referrel Code : $referCode",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(text: referCode),
                  );
                  Toast.show(
                    "Copied to ClipBoard!",
                    context,
                    duration: Toast.LENGTH_SHORT,
                    gravity: Toast.BOTTOM,
                  );
                },
                child: Container(
                  width: 58.w,
                  decoration: BoxDecoration(
                    color: Color(0xFF2EC14F),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        10.r,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "COPY",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await Share.share(referCode);
                },
                child: Container(
                  child: Icon(Icons.share),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<bool> checkValidReferralCode(String inpCode) async {
    bool isValid = false;
    var docList =
        await FirebaseFirestore.instance.collection('test_collection').get();
    docList.docs.forEach(
      (element) {
        if (element.data()["referral code"] == inpCode &&
            element.data()["user name"] != firebaseUser.uid) {
          isValid = true;
          userName = element.data()["user name"];
        }
      },
    );

    return isValid;
  }

  Widget dashedDivider(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 10.0;
        final dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(
            dashCount,
            (_) {
              return SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFAAAAAA80),
                  ),
                ),
              );
            },
          ),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }

  Widget historyListView() {
    if (listUsedReferrals.length == 0) {
      return Container(
        child: Text("No Codes used yet..."),
      );
    } else {
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: listUsedReferrals.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(listUsedReferrals[index]["code used"]),
            subtitle: Text(listUsedReferrals[index]["time of use"]),
            trailing: Text(listUsedReferrals[index]["used user name"]),
          );
        },
      );
    }
  }

  Future<int> calcPrice(int amt) async {
    var response = await FirebaseFirestore.instance
        .collection('test_collection')
        .doc(firebaseUser.uid)
        .get();

    int factor = response.data()["history index"];

    return amt - (factor * 5000);
  }

  @override
  void initState() {
    defaultTabController = TabController(length: 2, vsync: this);
    retrieveReferralCode();
    referralHistoryListRetrieve();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Refer and earn",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            size: 24.w,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF9649CB),
                Color(0xFF4C0080),
              ],
            ),
          ),
        ),
        elevation: 0.0,
      ),
      body: Center(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF9649CB),
                    Color(0xFF4C0080),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Container(height: 29.h),
                Container(
                  height: 101.h,
                  child: TabBarView(
                    controller: defaultTabController,
                    children: [
                      Container(
                        height: 101.h,
                        width: 101.w,
                        child:
                            Image.asset("assets/images/refer_earn_invites.png"),
                      ),
                      Container(
                        height: 101.h,
                        width: 101.w,
                        child:
                            Image.asset("assets/images/refer_earn_history.png"),
                      ),
                    ],
                  ),
                ),
                Container(height: 33.h),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.r),
                        topRight: Radius.circular(25.r),
                      ),
                      color: Color(0xFFF9F9F9),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.r),
                        topRight: Radius.circular(25.r),
                      ),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            Container(
                              height: 42.h,
                              width: 338.w,
                              margin: EdgeInsets.only(top: 10.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25.r),
                                ),
                                color: Color(0xFFEEF1FA),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(4.w),
                                child: TabBar(
                                  controller: defaultTabController,
                                  indicator: BoxDecoration(
                                    color: Color(0xFFFF6B6B),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(25.r),
                                    ),
                                  ),
                                  tabs: [
                                    Tab(
                                      child: Text(
                                        "Invites",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Text(
                                        "Referral Points",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 494.h,
                              child: TabBarView(
                                physics: BouncingScrollPhysics(),
                                controller: defaultTabController,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(height: 36.h),
                                      Container(
                                        child: Text(
                                          "Refer Friends & Earn Upto 5000",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(height: 10.h),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 34.w,
                                        ),
                                        child: Text(
                                          "Share this code with friend. You get Rs.50 when your friends joins. Your friend gets Rs.50",
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w200,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Container(height: 40.h),
                                      retrieveReferralContainer(),
                                      Container(height: 40.h),
                                      dashedDivider(context),
                                      Container(height: 40.h),
                                      Container(
                                        child: Text(
                                          "Have Referrel Code?",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(height: 15.h),
                                      Container(
                                        height: 42.h,
                                        width: 301.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              25.r,
                                            ),
                                          ),
                                          color: Color(0xFFEEF1FA),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 132.w,
                                              padding: EdgeInsets.only(
                                                left: 19.w,
                                              ),
                                              child: TextFormField(
                                                controller: refCode,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "Enter Refer Code",
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    //verify if referral code is correct or not
                                                    if (await checkValidReferralCode(
                                                            refCode.text) ==
                                                        false) {
                                                      Toast.show(
                                                        "Invalid Referral Code!",
                                                        context,
                                                        duration:
                                                            Toast.LENGTH_SHORT,
                                                        gravity: Toast.BOTTOM,
                                                      );
                                                    } else {
                                                      Toast.show(
                                                        "Applied Referral Code!",
                                                        context,
                                                        duration:
                                                            Toast.LENGTH_SHORT,
                                                        gravity: Toast.BOTTOM,
                                                      );
                                                      updateHistory(
                                                          refCode.text);
                                                    }
                                                    refCode.text = '';
                                                  },
                                                  child: Container(
                                                    height: 34.h,
                                                    width: 89.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(
                                                          22.r,
                                                        ),
                                                      ),
                                                      color: Color(0xFFFF6B6B),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "Apply",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(width: 5.w),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(height: 45.0),
                                      Container(
                                        child: Text(
                                          "Referral History",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: listUsedReferrals == null
                                            ? CircularProgressIndicator()
                                            : historyListView(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

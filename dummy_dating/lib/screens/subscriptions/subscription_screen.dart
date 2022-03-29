//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'dart:convert';

import 'package:dummy_dating/screens/referrels/referals_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class Subscription extends StatefulWidget {
  const Subscription({Key key}) : super(key: key);

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription>
    with SingleTickerProviderStateMixin {
  final _pageController = PageController();
  TabController _defaultTabController;
  final _currentPageNotifier = ValueNotifier<int>(0);
  var _razorpay;
  String orderId;

  int amtKey = 29900;
  int amtPlus = 49900;
  int amtElite = 29900;
  int amtCombo1 = 29900;
  int amtCombo2 = 29900;

  ReferalsScreenState referalsScreen = ReferalsScreenState();

  buildPageView() {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      child: PageView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: 6,
          controller: _pageController,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: Column(
                children: [
                  Container(
                    height: 36.h,
                    child: Image.asset("assets/images/avatar.png"),
                  ),
                  Container(
                    height: 18.h,
                  ),
                  Text(
                    "Get free match every week",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          },
          onPageChanged: (int index) {
            _currentPageNotifier.value = index;
          }),
    );
  }

  generateOrderId(int amount) async {
    var authn = 'Basic ' +
        base64Encode(
          utf8.encode(
            'rzp_test_dFa7R8fzZYsgVn:aYem9aZjWzdFjRtKyjjEnDpg',
          ),
        );

    var headers = {
      'content-type': 'application/json',
      'Authorization': authn,
    };

    var data =
        '{"amount": $amount,"currency": "INR","receipt": "receipt#R1","payment_capture": 1}';

    var res = await http.post('https://api.razorpay.com/v1/orders',
        headers: headers, body: data);
    if (res.statusCode != 200)
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    print('ORDER ID response => ${res.body}');

    orderId = json.decode(res.body)['id'].toString();
  }

  buildCircleIndicator() {
    return CirclePageIndicator(
      selectedDotColor: Color(0xFFFF6B6B),
      dotColor: Color(0xFFC4C4C4),
      itemCount: 6,
      currentPageNotifier: _currentPageNotifier,
    );
  }

  @override
  void initState() {
    _defaultTabController = TabController(length: 2, vsync: this);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await referalsScreen.updateSubStatus(
        "Folx Key", response.orderId.toString());
    print(response.orderId);
    Toast.show(
      "Subscribed Successfully!",
      context,
      duration: Toast.LENGTH_SHORT,
      gravity: Toast.BOTTOM,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Toast.show(
      "Transaction Failure!",
      context,
      duration: Toast.LENGTH_SHORT,
      gravity: Toast.BOTTOM,
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Subscription",
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
          onPressed: () {
            Navigator.pop(context);
          },
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
                Container(
                  height: 35.h,
                ),
                buildPageView(),
                Container(
                  height: 27.h,
                ),
                buildCircleIndicator(),
                Container(
                  height: 17.h,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.r),
                        topRight: Radius.circular(25.r),
                      ),
                      color: Color(0xFFF9F9F9),
                    ),
                    child: TabBarView(
                      controller: _defaultTabController,
                      physics: BouncingScrollPhysics(),
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                setState(() async {
                                  amtKey =
                                      await referalsScreen.calcPrice(29900);
                                });
                                await generateOrderId(amtKey);
                                var folxKeyOptions = {
                                  'key': 'rzp_test_dFa7R8fzZYsgVn',
                                  'order_id': orderId,
                                  'amount': amtKey,
                                  'name': 'Flox Subscription',
                                  'description': 'Flox Key',
                                  'prefill': {
                                    'contact': '8888888888',
                                    'email': 'test@razorpay.com'
                                  },
                                  "theme": {"color": "#9649CB"},
                                  "timeout": 300,
                                };
                                _razorpay.open(folxKeyOptions);
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: 22.h,
                                ),
                                height: 137.h,
                                width: 316.w,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFFF6B6B),
                                      Color(0xFFFF6BF0),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.r),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: 17.w,
                                        top: 11.h,
                                      ),
                                      child: Text(
                                        "Folx Key",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: 17.w,
                                        top: 9.h,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Rs. $amtKey",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "/ month",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 18.h,
                                        left: 11.w,
                                        right: 11.w,
                                      ),
                                      height: 40.h,
                                      width: 294.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.r),
                                        ),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Get smart pick every ",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Text(
                                                  "Tuesday",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Icon(
                                              Icons.check_circle,
                                              color: Color(0xFF9649CB),
                                              size: 22.h,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                setState(() async {
                                  amtPlus =
                                      await referalsScreen.calcPrice(49900);
                                });
                                await generateOrderId(amtPlus);
                                var folxPlusOptions = {
                                  'key': 'rzp_test_dFa7R8fzZYsgVn',
                                  'order_id': orderId,
                                  'amount': amtPlus,
                                  'name': 'Flox Subscription',
                                  'description': 'Flox Plus',
                                  'prefill': {
                                    'contact': '8888888888',
                                    'email': 'test@razorpay.com'
                                  },
                                  "theme": {"color": "#9649CB"},
                                  "timeout": 300,
                                };
                                _razorpay.open(folxPlusOptions);
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 20.h),
                                height: 137.h,
                                width: 316.w,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFFFDE6B),
                                      Color(0xFFFF6B86),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.r),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: 17.w,
                                        top: 11.h,
                                      ),
                                      child: Text(
                                        "Folx Plus",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: 17.w,
                                        top: 9.h,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Rs. $amtPlus",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "/ month",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 18.h,
                                        left: 11.w,
                                        right: 11.w,
                                      ),
                                      height: 40.h,
                                      width: 294.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.r),
                                        ),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Get smart pick every ",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Text(
                                                  "Tuesday & Friday",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Icon(
                                              Icons.check_circle,
                                              color: Color(0xFF9649CB),
                                              size: 22.h,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: 51.h,
                                left: 31.w,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "What is Smart Pick?",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Container(
                                    height: 10.h,
                                  ),
                                  Text(
                                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w200,
                                      color: Color(0xFF484848),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                setState(() async {
                                  amtElite =
                                      await referalsScreen.calcPrice(29900);
                                });
                                await generateOrderId(amtElite);
                                var folxEliteOptions = {
                                  'key': 'rzp_test_dFa7R8fzZYsgVn',
                                  'order_id': orderId,
                                  'amount': amtElite,
                                  'name': 'Flox Subscription',
                                  'description': 'Flox Elite',
                                  'prefill': {
                                    'contact': '8888888888',
                                    'email': 'test@razorpay.com'
                                  },
                                  "theme": {"color": "#9649CB"},
                                  "timeout": 300,
                                };
                                _razorpay.open(folxEliteOptions);
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 22.h),
                                height: 137.h,
                                width: 316.w,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF0085FF),
                                      Color(0xFF00FFC2),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.r),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: 17.w,
                                        top: 11.h,
                                      ),
                                      child: Text(
                                        "Folx Elite",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: 17.w,
                                        top: 9.h,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Rs. $amtElite",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "/ month",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    setState(() async {
                                  amtCombo1 =
                                      await referalsScreen.calcPrice(29900);
                                });
                                    await generateOrderId(amtCombo1);
                                    var combo1Options = {
                                      'key': 'rzp_test_dFa7R8fzZYsgVn',
                                      'order_id': orderId,
                                      'amount': amtCombo1,
                                      'name': 'Flox Subscription',
                                      'description': 'Flox Combo 1',
                                      'prefill': {
                                        'contact': '8888888888',
                                        'email': 'test@razorpay.com'
                                      },
                                      "theme": {"color": "#9649CB"},
                                      "timeout": 300,
                                    };
                                    _razorpay.open(combo1Options);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: 20.h,
                                      left: 22.w,
                                    ),
                                    height: 137.h,
                                    width: 150.w,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFFFCD4E),
                                          Color(0xFFE57C00),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.r),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: 6.h,
                                          ),
                                          child: Text(
                                            "Combo 1",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: 32.h,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Rs. $amtCombo1",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                "/ month",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: 20.h,
                                            left: 16.w,
                                            right: 16.w,
                                          ),
                                          height: 20.h,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                10.r,
                                              ),
                                            ),
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              left: 10.w,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Key + Elite",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.check_circle,
                                                  color: Color(0xFF9649CB),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    setState(() async {
                                  amtCombo2 =
                                      await referalsScreen.calcPrice(29900);
                                });
                                    await generateOrderId(amtCombo2);
                                    var combo2Options = {
                                      'key': 'rzp_test_dFa7R8fzZYsgVn',
                                      'order_id': orderId,
                                      'amount': amtCombo2,
                                      'name': 'Flox Subscription',
                                      'description': 'Flox Combo 2',
                                      'prefill': {
                                        'contact': '8888888888',
                                        'email': 'test@razorpay.com'
                                      },
                                      "theme": {"color": "#9649CB"},
                                      "timeout": 300,
                                    };
                                    _razorpay.open(combo2Options);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: 20.h,
                                      left: 22.w,
                                    ),
                                    height: 137.h,
                                    width: 150.w,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFFFCD4E),
                                          Color(0xFFE57C00),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.r),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: 6.h,
                                          ),
                                          child: Text(
                                            "Combo 2",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: 32.h,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Rs. $amtCombo2",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                "/ month",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: 20.h,
                                            left: 16.w,
                                            right: 16.w,
                                          ),
                                          height: 20.h,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                10.r,
                                              ),
                                            ),
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              left: 10.w,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Plus + Elite",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.check_circle,
                                                  color: Color(0xFF9649CB),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
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

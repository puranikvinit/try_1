import 'package:flutter/material.dart';
import 'package:folx_dating/models/User.dart';
import 'package:folx_dating/screens/home/HomeScreen.dart';
import 'package:folx_dating/screens/pages/PagingList.dart';
import 'package:folx_dating/styles/ColorConstants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PagingParent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PagingParentSt();
}

const PHONE_NUMBER_SCREEN = 0;
const OTP_SCREEN = 1;
const EMAIL_SCREEN = 2;
const NAME_SCREEN = 3;
const GENDER_SCREEN = 4;
const PHOTOS_SCREEN = 5;

class _PagingParentSt extends State<PagingParent> {
  final user = FolxUser();
  int currentPageSt = PHONE_NUMBER_SCREEN;
  final _pgController = PageController(viewportFraction: 1.0);

  @override
  void initState() {
    print("Paging");
    user.init();
    getLocation();
    super.initState();
  }

  _updatePage() {
    nextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBg,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 68),
            child: SmoothPageIndicator(
              controller: _pgController,
              count: 4,
              effect: ScaleEffect(
                dotWidth: 4,
                dotHeight: 4,
                scale: 3,
                spacing: 17,
                dotColor: Colors.white,
                activeDotColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                top: 48,
              ),
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _pgController,
                onPageChanged: (pgIndex) {
                  //page changed happened.
                },
                children: getPagingScreens(user, _updatePage),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pgController.dispose();
    super.dispose();
  }

  void nextPage() {
    int nexPgIndex = _pgController.page.toInt() + 1;
    print(nexPgIndex);
    if (nexPgIndex > 3) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          ModalRoute.withName("/Home"));
    } else {
      _pgController.animateToPage(_pgController.page.toInt() + 1,
          duration: Duration(milliseconds: 400), curve: Curves.easeIn);
    }
  }

  void previousPage() {
    _pgController.animateToPage(_pgController.page.toInt() - 1,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  Future<void> getLocation() async {
    if (user.position == null) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      user.position = position;
      print(position.longitude);
      print(position.latitude);
    }
  }
}

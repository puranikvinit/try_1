import 'package:flutter/material.dart';
import 'package:folx_dating/bloc/db_b_loc.dart';
import 'package:folx_dating/firebase/cloud_store.dart';
import 'package:folx_dating/models/User.dart';
import 'package:folx_dating/screens/home/tabs/MessageListScreen.dart';
import 'package:folx_dating/screens/home/tabs/ProfileScreen.dart';
import 'package:folx_dating/screens/home/tabs/SwipeScreen.dart';
import 'package:folx_dating/screens/widgets/Tooltip1.dart';
import 'package:folx_dating/screens/widgets/Tooltip2.dart';
import 'package:folx_dating/styles/ColorConstants.dart';

import '../../CONSTANTS.dart';
import 'tabs/SettingScreen.dart';

class HomeScreen extends StatefulWidget {
  final FolxUser folxUser = new FolxUser();
  final FolxBloc bloc = FolxBloc();

  @override
  State<StatefulWidget> createState() => _HomeSt();
}

class _HomeSt extends State<HomeScreen> {
  bool isFirstTimeAppOpen = false;
  bool isTooltip1Visible = false;
  bool isTooltip2Visible = false;
  final folxTabs = new TabBar(
    physics: NeverScrollableScrollPhysics(),
    tabs: <Tab>[
      new Tab(icon: new Icon(Icons.location_on)),//location_pin
      new Tab(icon: new Icon(Icons.chat)),
      new Tab(icon: new Icon(Icons.person)),//person_rounded
      new Tab(icon: new Icon(Icons.settings)),
    ],
  );

  @override
  void initState() {
    print("HomeScreen");
    getFirstTimePref();
    _getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: primaryBg,
        accentColor: secondaryBg,
      ),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                folxTabs,
              ],
            ),
          ),
          body: Stack(
            children: [
              TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  SwipeScreen(),
                  MessageListScreen(),
                  ProfileScreen(),
                  SettingScreen()
                ],
              ),
              Visibility(
                visible: isTooltip1Visible,
                child: GestureDetector(
                  onTap: setFirstTimePref,
                  child: ToolTip1(),
                ),
              ),
              Visibility(
                visible: isTooltip2Visible,
                child: GestureDetector(
                  onTap: setFirstTimePref,
                  child: ToolTip2(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getCurrentUser() async {
    DatabaseService().snapshotMyUserData().then((value) {
      widget.folxUser.phoneNumber = value.get(phNumber);
      widget.folxUser.emailId = value.get(emailId);
      widget.folxUser.userName = value.get(userName);
      widget.folxUser.userGender = value.get(userGender);
      widget.folxUser.userAge = value.get(userAge);
      widget.folxUser.userImageUrls = value.get(userImageUrls);
      widget.folxUser.shareLastSeen = value.get(shareLastSeen);
      widget.folxUser.userWork = new Work();
      widget.folxUser.userWork.university = value.get(university);
      widget.folxUser.userWork.company = value.get(company);
      widget.folxUser.userWork.profession = value.get(profession);
      // user.userCoverImageUrl = value.get(coverImg);
    });
  }

  void getFirstTimePref() async {
    final Future<bool> isFirstTime =
        widget.bloc.getBooleanPref(FIRST_LAUNCH, true);
    isFirstTime.then((value) {
      if (value) {
        isTooltip1Visible = true;
        isTooltip2Visible = false;
      }
      setState(() {
        isFirstTimeAppOpen = value;
      });
    });
  }

  void setFirstTimePref() {
    if (isTooltip1Visible) {
      isTooltip1Visible = false;
      isTooltip2Visible = true;
      setState(() {});
    } else {
      if (isFirstTimeAppOpen) {
        widget.bloc.setBooleanPref(FIRST_LAUNCH, "0");
      }
      setState(() {
        isTooltip2Visible = false;
        isFirstTimeAppOpen = false;
      });
    }
  }
}

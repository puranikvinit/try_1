import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:folx_dating/firebase/cloud_store.dart';
import 'package:folx_dating/models/User.dart';
import 'package:folx_dating/screenUtils/utils.dart';
import 'package:folx_dating/screens/widgets/IconAndTextWidget.dart';
import 'package:folx_dating/styles/ColorConstants.dart';
import 'package:folx_dating/styles/StringConstants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../ProfileDetails.dart';

class SwipeScreen extends StatefulWidget {
  final DatabaseService _ds = DatabaseService();

  @override
  State<StatefulWidget> createState() => _SwipeSt();
}

class _SwipeSt extends State<SwipeScreen> {
  FolxUser myUser = FolxUser();
  // UserMatchingPreferences userMatchingPreferences = UserMatchingPreferences();
  PageController mainSwipeController = PageController(viewportFraction: 1.0);
  List<QueryDocumentSnapshot> swipeList = new List();
  Position lastPos = new Position(longitude: 88.3795263, latitude: 22.815021);
  final _pgController = PageController(viewportFraction: 1.0);

  @override
  void initState() {
    super.initState();
    getUsersForSwipe();
    // widget._ds.updateMyselfWhenDocChange();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        swipeList.isNotEmpty
            ? PageView.builder(
                // Changes begin here
                physics: NeverScrollableScrollPhysics(),
                controller: mainSwipeController,
                reverse: true,
                scrollDirection: Axis.vertical,
                itemCount: swipeList.length,
                itemBuilder: (context, position) {
                  FolxUser user =
                      widget._ds.getFolxUserFromElement(swipeList[position]);
                  return GestureDetector(
                    onPanEnd: (details) {
                      if (details.velocity.pixelsPerSecond.dy < -700) {
                        onLike(user);
                      } else if (details.velocity.pixelsPerSecond.dy > 700) {
                        widget._ds.dislike(myUser, user.id, onDislike);
                      }
                    },
                    child: Container(
                      child: Center(
                        child: MergeSemantics(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Card(
                              child: Stack(
                                children: [
                                  PageView.builder(
                                      controller: _pgController,
                                      itemCount: user.userImageUrls.length,
                                      onPageChanged: (pageIndex) {},
                                      itemBuilder: (context, position) {
                                        return Container(
                                          child: InkWell(
                                            onTap: () =>
                                                openProfileScreen(user),
                                            child: Image(
                                              image: NetworkImage(
                                                user.userImageUrls[position],
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          margin: EdgeInsets.only(bottom: 100),
                                        );
                                      }),
                                  Column(
                                    children: [
                                      user.userImageUrls != null &&
                                              user.userImageUrls.isNotEmpty
                                          ? Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Align(
                                                alignment: Alignment.topCenter,
                                                child: SmoothPageIndicator(
                                                  controller: _pgController,
                                                  count:
                                                      user.userImageUrls.length,
                                                  effect: ScaleEffect(
                                                    dotWidth: 4,
                                                    dotHeight: 4,
                                                    scale: 3,
                                                    spacing: 17,
                                                    dotColor: Colors.white,
                                                    activeDotColor:
                                                        Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Spacer(),
                                      Spacer(),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 40),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.black12.withOpacity(0.4),
                                        padding: EdgeInsets.only(
                                          left: 20,
                                          bottom: 20,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${user.userName}, ${user.userAge}',
                                              style: getDefaultBoldTextStyle()
                                                  .copyWith(
                                                fontSize: 34,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            TextIcon(Icons.location_on,//TODO: location_pin
                                                '${getDistance(user.position.latitude, user.position.longitude)}'),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            TextIcon(Icons.school,
                                                "${user.userWork.university}"),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            TextIcon(Icons.work,
                                                "${user.userWork.profession} at ${user.userWork.company}"),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 25),
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              FlatButton.icon(
                                                  onPressed: () {
                                                    widget._ds.dislike(myUser,
                                                        user.id, onDislike);
                                                  },
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: Colors.grey,
                                                  ),
                                                  label: Text('')),
                                              FlatButton.icon(
                                                onPressed: () {
                                                  onLike(user);
                                                },
                                                icon: Icon(
                                                  Icons.favorite,
                                                  color: secondaryBg,
                                                ),
                                                label: Text(''),
                                              ),
                                              FlatButton.icon(
                                                onPressed: () {
                                                  mainSwipeController
                                                      .previousPage(
                                                    duration: Duration(
                                                        milliseconds: 400),
                                                    curve: Curves.easeInOutQuad,
                                                  );
                                                },
                                                label: Text(''),
                                                icon: Transform.rotate(
                                                  angle: 180 * pi / 180,
                                                  child: Container(
                                                    child: Icon(
                                                      Icons
                                                          .arrow_right,//TODO: subdirectory_arrow_right_outlined
                                                      color: primaryBg,
                                                    ),
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
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                })
            : Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(48),
                      child: Text(
                        'That\'s all Folx!. It seems like there\'s no one new matching your preferences! \n\nPlease check-in some other time',
                        style: getDefaultDarkTextStyle()
                            .copyWith(fontSize: 24, color: primaryBg),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              )
      ]),
    );
  }

  void getUsersForSwipe() async {
    if (myUser == null ||
        myUser.matchingPreferences == null ||
        myUser.matchingPreferences.isNotSet()) {
      print("getting values from cloud");
      await getCurrentUserMatchingPref();
    }
  }

  Future getCurrentUserMatchingPref() async {
    await widget._ds.getMyUser().then((value) {
      myUser = value;
      refreshSwipeList();
    });
  }

  void refreshSwipeList() {
    if (myUser.matchingPreferences == null ||
        myUser.matchingPreferences.isNotSet()) {
    } else {
      widget._ds
          .getUsersBasedOnPref(
              myUser.matchingPreferences, myUser.recommendations)
          .then((value) {
        if (value.isNotEmpty) {
          swipeList.addAll(value);
          setState(() {});
          widget._ds.updateRecommendations(swipeList);
        }
      });
    }
  }

  String getDistance(double lat1, double lat2) {
    int distance =
        calculateDistance(lastPos.latitude, lastPos.longitude, lat1, lat2)
            .round();
    if (distance <= 1) {
      return 'Less than a Km away';
    } else {
      return '$distance Kms away';
    }
  }

  openProfileScreen(FolxUser user) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileDetailScreen(
            user,
            onLike: onLike,
          ),
        ));
  }

  void onLike(FolxUser user) {
    widget._ds.like(myUser, user.id, nextPage);
  }

  void onDislike() {
    nextPage();
  }

  void nextPage() {
    if (mainSwipeController.page.round() + 1 < swipeList.length) {
      mainSwipeController.nextPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInCirc,
      );
    } else {
      swipeList.clear();
      setState(() {});
    }
  }
}

import 'dart:math';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:folx_dating/models/Restaurant.dart';
import 'package:folx_dating/models/User.dart';
import 'package:folx_dating/network/zomato.dart';
import 'package:folx_dating/styles/ColorConstants.dart';
import 'package:folx_dating/styles/StringConstants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProfileDetailScreen extends StatefulWidget {
  final FolxUser user;
  final bool showShrinkFab;
  final Function(FolxUser) onLike;
  ProfileDetailScreen(this.user, {this.showShrinkFab = true, this.onLike});
  @override
  State<StatefulWidget> createState() => _ProfileDetSt();
}

class _ProfileDetSt extends State<ProfileDetailScreen> {
  final _pgController = PageController(viewportFraction: 1.0);
  List<Restaurant> _restList = new List();
  List<String> _icebreakerQues = new List();
  List<String> _icebreakerAns = new List();

  @override
  void initState() {
    super.initState();
    _getRest();
    widget.user.mapIceBreakers.forEach((key, value) {
      _icebreakerQues.add(key);
      _icebreakerAns.add(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
              controller: _pgController,
              itemCount: widget.user.userImageUrls.length,
              onPageChanged: (pageIndex) {},
              itemBuilder: (context, position) {
                return Container(
                  child: Image(
                    image: NetworkImage(
                      widget.user.userImageUrls[position],
                    ),
                    fit: BoxFit.cover,
                  ),
                  margin: EdgeInsets.only(bottom: 100),
                );
              }),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.48,
              left: 20,
            ),
            child: SmoothPageIndicator(
              controller: _pgController,
              count: widget.user.userImageUrls.length,
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
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.4,
            builder: (context, scrollContainer) {
              return ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: Container(
                  padding: EdgeInsets.only(
                    top: 16,
                    left: 28,
                  ),
                  color: Colors.white,
                  child: ListView(
                    controller: scrollContainer,
                    shrinkWrap: true,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          color: hexToColor("#AAAAAA"),
                          height: 4,
                          width: 50,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      getProfileWidget(widget.user),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '${widget.user.userName}\'s Icebreakers',
                        style: getDefaultDarkBoldTextStyle().copyWith(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 150,
                        width: MediaQuery.of(context).size.width + 100,
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            return Card(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _icebreakerQues[index],
                                      style: getDefaultDarkTextStyle().copyWith(
                                          color: hexToColor('#808080'),
                                          fontSize: 12),
                                    ),
                                    Container(
                                      width: 200,
                                      margin: EdgeInsets.symmetric(
                                        vertical: 25,
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        _icebreakerAns[index],
                                        style: getDefaultDarkBoldTextStyle()
                                            .copyWith(fontSize: 20),
                                        overflow: TextOverflow.fade,
                                        textAlign: TextAlign.justify,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.user.mapIceBreakers.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              width: 20,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Text(
                        '${widget.user.userName}\'s Favourite Restaurants',
                        style: getDefaultDarkBoldTextStyle().copyWith(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 150,
                        width: MediaQuery.of(context).size.width + 100,
                        child: StaggeredGridView.countBuilder(
                          scrollDirection: Axis.horizontal,
                          crossAxisCount: 4,
                          shrinkWrap: true,
                          itemCount: _restList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var rest = _restList[index];
                            return Container(
                              child: Row(
                                children: [
                                  rest.imageUrl == null || rest.imageUrl.isEmpty
                                      ? Icon(
                                          Icons.restaurant,
                                          color: secondaryBg,
                                        )
                                      : Image(
                                          image: NetworkImage(rest.imageUrl),
                                          fit: BoxFit.cover,
                                          width: 48,
                                          height: 48,
                                        ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        rest.restName,
                                        style: getDefaultDarkBoldTextStyle(),
                                        overflow: TextOverflow.clip,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        rest.locality,
                                        style: getDefaultDarkTextStyle(),
                                        overflow: TextOverflow.fade,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          staggeredTileBuilder: (int index) =>
                              new StaggeredTile.count(
                            2,
                            max(_restList[index].restName.length,
                                        _restList[index].locality.length) >
                                    10
                                ? 10
                                : 6,
                          ),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                        ),
                      ), // grid items end here
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '${widget.user.userName}\'s Photos',
                        style: getDefaultDarkBoldTextStyle().copyWith(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 150,
                        width: MediaQuery.of(context).size.width + 100,
                        child: ListView.builder(
                          itemCount: widget.user.userImageUrls.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.only(right: 10),
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    widget.user.userImageUrls[index]),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Visibility(
            visible: widget.showShrinkFab,
            child: Positioned(
              bottom: 40,
              right: 16,
              child: Column(
                children: [
                  Container(
                    child: FittedBox(
                      child: FloatingActionButton(
                        heroTag: "close",
                        elevation: 10,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,//close_fullscreen_sharp
                          color: Colors.black87,
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                    height: 70,
                    width: 70,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: FittedBox(
                      child: FloatingActionButton(
                        heroTag: "favorite",
                        elevation: 5,
                        onPressed: () {
                          widget.onLike(widget.user);
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.favorite,
                          color: Colors.white,
                        ),
                        backgroundColor: secondaryBg,
                      ),
                    ),
                    height: 70,
                    width: 70,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _getRest() async {
    var zomatoCall = new ZomatoNetwork();
    for (String id in widget.user.matchingPreferences.prefRestaurants) {
      zomatoCall
          .getRestList(id)
          .then((value) => _restList.add(value))
          .whenComplete(() => setState(() {}));
    }
  }
}

Widget getProfileWidget(FolxUser user) {
  return Row(
    children: [
      CircularProfileAvatar(
        null,
        child: Image(
          image: NetworkImage(user.userCoverImageUrl == null
              ? user.userImageUrls.first
              : user.userCoverImageUrl),
          fit: BoxFit.cover,
        ),
        borderColor: secondaryBg,
        borderWidth: 2,
        radius: 42,
      ),
      SizedBox(
        width: 16,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${user.userName}, ${user.userAge}',
            style: getDefaultDarkBoldTextStyle().copyWith(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 13,
          ),
          ButtonTheme(
            materialTapTargetSize: MaterialTapTargetSize
                .shrinkWrap, //limits the touch area to the button area
            minWidth: 0, //wraps child's width
            height: 0, //wraps child's height
            child: FlatButton.icon(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              icon: Icon(
                Icons.school,
                size: 16,
              ),
              label: Text(
                '${user.userWork.university}',
                style: getDefaultDarkTextStyle().copyWith(
                  fontSize: 12,
                  letterSpacing: 0.12,
                ),
              ),
              onPressed: null,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          ButtonTheme(
            padding: EdgeInsets.zero,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //limits the touch area to the button area
            minWidth: 0,
            //wraps child's width
            height: 0,
            //wraps child's height
            child: FlatButton.icon(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              icon: Icon(
                Icons.work,
                size: 16,
              ),
              label: Text(
                '${user.userWork.profession} at ${user.userWork.company}',
                style: getDefaultDarkTextStyle().copyWith(
                  fontSize: 12,
                  letterSpacing: 0.12,
                ),
              ),
              onPressed: null,
            ),
          ),
        ],
      )
    ],
  );
}

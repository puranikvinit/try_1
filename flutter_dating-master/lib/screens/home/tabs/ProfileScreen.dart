import 'dart:typed_data';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:folx_dating/auth/auth.dart';
import 'package:folx_dating/firebase/cloud_store.dart';
import 'package:folx_dating/models/Restaurant.dart';
import 'package:folx_dating/models/User.dart';
import 'package:folx_dating/network/zomato.dart';
import 'package:folx_dating/screens/home/ProfileDetails.dart';
import 'package:folx_dating/screens/ice_breaker_detail.dart';
import 'package:folx_dating/screens/ice_breaker_list.dart';
import 'package:folx_dating/screens/widgets/select_zomato_rest.dart';
import 'package:folx_dating/styles/ColorConstants.dart';
import 'package:folx_dating/styles/StringConstants.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileSt();
}

class _ProfileSt extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  Function eq = const ListEquality().equals;
  List<Asset> images = List<Asset>();
  FolxUser _folxUser = FolxUser();
  List<String> _icebreakerQues = new List();
  List<String> _icebreakerAns = new List();
  int currAsset = 0;
  DatabaseService _ds = DatabaseService();
  TabController _tabController;

  TabBar profileTabs;

  bool _isDataLoaded = false;

  void onIceBreakerChange(Map<String, String> updatedIceBreakers) {
    if (updatedIceBreakers.isNotEmpty) {
      print(updatedIceBreakers);
      _icebreakerQues.clear();
      _icebreakerAns.clear();
      _folxUser.mapIceBreakers = updatedIceBreakers;
      _folxUser.mapIceBreakers.forEach((key, value) {
        _icebreakerQues.add(key);
        _icebreakerAns.add(value);
      });
      // print("setState line 51");
      setState(() {});
    }
  }

  @override
  void initState() {
    print("ProfileScreen");
    super.initState();
    _ds.updateMyselfWhenDocChange(
        icebreakerListCallback: onIceBreakerChange,
        userCoverImg: onCoverImageChange);
    _tabController = new TabController(length: 2, vsync: this);
    profileTabs = new TabBar(
      indicatorPadding: EdgeInsets.zero,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: Colors.white,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white, width: 3.0),
        ),
      ),
      controller: _tabController,
      labelStyle: getDefaultTextStyle()
          .copyWith(fontSize: 16, fontWeight: FontWeight.w600),
      physics: NeverScrollableScrollPhysics(),
      tabs: <Tab>[
        new Tab(
          text: 'Edit',
        ),
        new Tab(
          text: 'View',
        ),
      ],
    );
  }

  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
      currAsset = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDataLoaded) {
      _getCurrentUser();
    }
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: profileTabs,
        elevation: 10,
      ),
      backgroundColor: Colors.white,
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: SingleChildScrollView(
              child: _isDataLoaded
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //this is the upper part of profile
                        DottedBorder(
                          radius: Radius.circular(8),
                          borderType: BorderType.RRect,
                          color: hexToColor("#AAAAAA"),
                          dashPattern: [8, 8],
                          strokeWidth: 2,
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 18, left: 24, right: 24, bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Add An Icebreaker',
                                  style: getDefaultDarkBoldTextStyle().copyWith(
                                      color: secondaryBg, fontSize: 20),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                    'Trouble starting convos? Share an interesting quirk about you!',
                                    style: getDefaultDarkTextStyle()),
                                SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    Spacer(),
                                    InkWell(
                                      onTap: navigateToIceBreaker,
                                      child: Text(
                                        'GET STARTED',
                                        style: getDefaultDarkBoldTextStyle()
                                            .copyWith(
                                                color: secondaryBg,
                                                fontSize: 16),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProfileAvatar(
                              null,
                              child: _folxUser.userCoverImageUrl == null ||
                                      _folxUser.userCoverImageUrl.isEmpty
                                  ? Image(
                                      image: AssetImage(
                                          imagePath + "img_placeholder.png"),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      _folxUser.userCoverImageUrl,
                                      width: 300,
                                      height: 300,
                                      fit: BoxFit.cover,
                                    ),
                              borderColor: secondaryBg,
                              borderWidth: 2,
                              radius: 42,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(
                                      '${_folxUser.userName}, ${_folxUser.userAge}'
                                          .toUpperCase(),
                                      style: getDefaultDarkBoldTextStyle()
                                          .copyWith(
                                        fontSize: 20,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  ButtonTheme(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    //limits the touch area to the button area
                                    minWidth: 0,
                                    //wraps child's width
                                    height: 0,
                                    //wraps child's height
                                    child: FlatButton.icon(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      icon: Icon(
                                        Icons.school,
                                        size: 16,
                                      ),
                                      label: Text(
                                        _folxUser.userWork.university,
                                        style:
                                            getDefaultDarkTextStyle().copyWith(
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
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    //limits the touch area to the button area
                                    minWidth: 0,
                                    //wraps child's width
                                    height: 0,
                                    //wraps child's height
                                    child: FlatButton.icon(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      icon: Icon(
                                        Icons.work,
                                        size: 16,
                                      ),
                                      label: Text(
                                        '${_folxUser.userWork.profession} at ${_folxUser.userWork.company}',
                                        style:
                                            getDefaultDarkTextStyle().copyWith(
                                          fontSize: 12,
                                          letterSpacing: 0.12,
                                        ),
                                      ),
                                      onPressed: null,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          'Your Photos (${_folxUser.userImageUrls.length + images.length}/6)',
                          style: getDefaultDarkBoldTextStyle(),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        GridView.count(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          children: List.generate(6, (index) {
                            String assetUrl = _folxUser.userImageUrls != null &&
                                    index < _folxUser.userImageUrls.length
                                ? _folxUser.userImageUrls[index]
                                : null;
                            Asset asset;
                            if ((assetUrl == null || assetUrl.isEmpty) &&
                                currAsset < images.length) {
                              asset = images[currAsset++];
                            }
                            // print(
                            //     "asset ${asset != null ? asset.identifier : null} assetUrl $assetUrl");
                            return assetUrl == null && asset == null
                                ? Card(
                                    shape: RoundedRectangleBorder(
                                      side: index == 0
                                          ? new BorderSide(
                                              color: secondaryBg, width: 3.0)
                                          : BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.0)),
                                    ),
                                    child: Container(
                                      child: Transform.scale(
                                        scale: 0.5,
                                        child: FittedBox(
                                          child: FloatingActionButton(
                                            heroTag: index,
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.add,
                                              color: secondaryBg,
                                              size: 24,
                                            ),
                                            onPressed: () {
                                              loadAssets();
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    color: hexToColor("#E6E6E6"),
                                  )
                                : asset == null
                                    ? Container(
                                        decoration: index == 0
                                            ? BoxDecoration(
                                                border: Border.all(
                                                    width: 3,
                                                    color: secondaryBg))
                                            : null,
                                        margin: EdgeInsets.all(3),
                                        child: Image.network(
                                          assetUrl,
                                          width: 300,
                                          height: 300,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(
                                        decoration: index == 0
                                            ? BoxDecoration(
                                                border: Border.all(
                                                    width: 3,
                                                    color: secondaryBg))
                                            : null,
                                        margin: EdgeInsets.all(3),
                                        child: AssetThumb(
                                          asset: asset,
                                          width: 300,
                                          height: 300,
                                        ),
                                      );
                          }),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Text(
                          'Your Icebreakers (${_folxUser.mapIceBreakers.length})',
                          style: getDefaultDarkBoldTextStyle(),
                        ),
                        Container(
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _folxUser.mapIceBreakers.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14,
                                      horizontal: 16,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          children: [
                                            Text(
                                              _icebreakerQues[index],
                                              style: getDefaultDarkTextStyle()
                                                  .copyWith(
                                                color: hexToColor("#808080"),
                                                fontSize: 12,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 8, left: 4),
                                              child: Text(
                                                _icebreakerAns[index],
                                                style: getDefaultDarkTextStyle()
                                                    .copyWith(
                                                        fontSize: 16,
                                                        color: hexToColor(
                                                            "#4A4A4A")),
                                              ),
                                            )
                                          ],
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                        )),
                                        InkWell(
                                          child: Icon(
                                            Icons.edit,
                                            color: secondaryBg,
                                          ),
                                          onTap: () async {
                                            final result = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        IceBreakerDetail(
                                                          _icebreakerQues[
                                                              index],
                                                          defaultAns:
                                                              _icebreakerAns[
                                                                  index],
                                                        )));
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FlatButton.icon(
                          onPressed: () async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => IceBreakerList()));
                            if (result != null) {
                              // print("setState line 422");
                              setState(() {});
                            }
                          },
                          icon: Icon(
                            Icons.add,
                            color: secondaryBg,
                          ),
                          label: Text('Add New'),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Text(
                          'Your Favourite Restaurants',
                          style: getDefaultDarkBoldTextStyle(),
                        ),
                        Container(
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _restList.length,
                            itemBuilder: (context, index) {
                              var rest = _restList[index];
                              return ListTile(
                                leading: rest.imageUrl == null ||
                                        rest.imageUrl.isEmpty
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
                                title: Text(
                                  rest.restName,
                                  style: getDefaultDarkBoldTextStyle(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  rest.locality,
                                  style: getDefaultDarkTextStyle().copyWith(
                                    color: hexToColor("#808080"),
                                    fontSize: 12,
                                  ),
                                ),
                                trailing: InkWell(
                                  onTap: () {
                                    // print("setState line 473");
                                    setState(() {
                                      _restList.remove(rest);
                                      DatabaseService ds =
                                          new DatabaseService();
                                      ds.deleteMyRestaurant(rest.id);
                                    });
                                  },
                                  child: Icon(
                                    Icons.clear,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        FlatButton.icon(
                          onPressed: () async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChooseRestaurantScreen(
                                            _folxUser.position)));
                            print("waiting for result");
                            if (result != null) {
                              var newResList = result as List<Restaurant>;
                              if (eq(newResList, _restList)) {
                                print('list is same');
                              } else {
                                _restList.addAll(newResList);
                                // print("setState line 505");
                                setState(() {});
                                DatabaseService ds = new DatabaseService();
                                ds.addNewRestaurants(
                                    newResList.map((e) => e.id).toList());
                              }
                            }
                          },
                          icon: Icon(
                            Icons.add,
                            color: secondaryBg,
                          ),
                          label: Text('Add New'),
                        ),
                      ],
                    )
                  : Center(
                      child: Theme(
                        data:
                            Theme.of(context).copyWith(accentColor: primaryBg),
                        child: CircularProgressIndicator(
                          backgroundColor: secondaryBg,
                          semanticsLabel: "Refreshing User Details...",
                        ),
                      ),
                    ),
            ),
          ),
          ProfileDetailScreen(
            _folxUser,
            showShrinkFab: false,
          )
        ],
      ),
    );
  }

  void _getCurrentUser() async {
    await _ds.getMyUser().then((value) => _folxUser = value).whenComplete(() {
      if (_folxUser.matchingPreferences != null &&
          _folxUser.matchingPreferences.prefRestaurants != null &&
          _folxUser.matchingPreferences.prefRestaurants.isNotEmpty) {
        _getRest();
      }
    });
    _folxUser.mapIceBreakers.forEach((key, value) {
      _icebreakerQues.add(key);
      _icebreakerAns.add(value);
    });
    // print("setState line 553");
    setState(() {
      _isDataLoaded = true;
    });
  }

  List<Restaurant> _restList = new List();
  Future<void> _getRest() async {
    var zomatoCall = new ZomatoNetwork();
    for (String id in _folxUser.matchingPreferences.prefRestaurants) {
      await zomatoCall
          .getRestList(id)
          .then((value) => _restList.add(value))
          .whenComplete(() => setState(() {}));
    }
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = '';
    int max = _folxUser.userImageUrls == null || _folxUser.userImageUrls.isEmpty
        ? 6
        : 6 - _folxUser.userImageUrls.length - images.length;
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: max,
        enableCamera: false,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#9649CB",
          actionBarTitle: "Folx",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    if (resultList.isNotEmpty) {
      resultList.asMap().forEach((index, element) {
        var index = images
            .indexWhere((asset) => asset.identifier == element.identifier);
        if (index == -1) {
          saveImages(element, 7 + index);
        }
      });
    }
    // print("setState line 603");
    setState(() {
      images = resultList;
    });
  }

  Future saveImages(asset, int index) async {
    String userId = FireBase.auth.currentUser.uid;
    try {
      String fileName = "$index";
      ByteData byteData = await asset.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();
      StorageReference ref =
          FirebaseStorage.instance.ref().child("$userId/$fileName");
      StorageUploadTask uploadTask = ref.putData(imageData);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      taskSnapshot.ref.getDownloadURL().then((value) {
        DatabaseService ds = new DatabaseService();
        ds.addNewImage(value);
      });
    } catch (e) {}
  }

  void navigateToIceBreaker() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => IceBreakerList()));
  }

  onCoverImageChange(String newImageUrl) {
    if (_folxUser.userCoverImageUrl != newImageUrl &&
        newImageUrl != null &&
        newImageUrl.isNotEmpty) {
      _folxUser.userCoverImageUrl = newImageUrl;
      setState(() {});
    }
  }
}

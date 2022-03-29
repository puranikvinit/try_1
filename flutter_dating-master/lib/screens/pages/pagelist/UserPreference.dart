import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:folx_dating/auth/auth.dart';
import 'package:folx_dating/firebase/cloud_store.dart';
import 'package:folx_dating/models/Restaurant.dart';
import 'package:folx_dating/models/User.dart';
import 'package:folx_dating/screens/signup/SignUpLanding.dart';
import 'package:folx_dating/styles/BackgroundStyles.dart';
import 'package:folx_dating/styles/ColorConstants.dart';
import 'package:folx_dating/styles/StringConstants.dart';

class UserPreference extends StatefulWidget {
  final FolxUser user;
  final VoidCallback action;

  final dio = Dio(BaseOptions(
    baseUrl: 'https://developers.zomato.com/api/v2.1/search',
    headers: {
      'user-key': DotEnv().env['ZOMATO_API_KEY'],
      'Accept': 'application/json',
    },
  ));

  UserPreference(this.user, this.action);

  @override
  State<StatefulWidget> createState() => _UserGenderPref();
}

class _UserGenderPref extends State<UserPreference> {
  bool isGenderPrefVisible = true;
  bool isDateSpotPrefVisible = false;

  bool isManSelected = false;
  bool isWomanSelected = false;
  bool isNonBinSelected = false;

  bool isSkipTextVisible = false;
  bool isFabVisible = true;

  bool isUserDetailsCompleted = false;
  bool _isSearchVisible = true;

  bool isLoadVisiblity = false;

  String _restName;

  List<Restaurant> _restList = new List();
  List _responseRestList = new List();

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  void setFabVisibility() {
    setState(() {
      UserMatchingPreferences userMatchingPreferences =
          widget.user.matchingPreferences;
      if (isGenderPrefVisible) {
        if (userMatchingPreferences.prefGender != null) {
          isFabVisible = true;
        } else {
          isFabVisible = false;
        }
      }

      if (isDateSpotPrefVisible) {
        isFabVisible = isUserDetailsCompleted;
      }
    });
  }

  void setSkipVisibility() {
    setState(() {
      if (isDateSpotPrefVisible) isSkipTextVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primaryBg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 48, right: 48),
              child: Visibility(
                visible: isGenderPrefVisible,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Who’d you like to get matched with?",
                      style: getDefaultBoldTextStyle(),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        color: isWomanSelected ? secondaryBg : Colors.white,
                        padding: EdgeInsets.only(left: 36, top: 12, bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onPressed: () {
                          setState(() {
                            isWomanSelected = !isWomanSelected;
                          });
                        },
                        child: Row(
                          children: [
                            svg(
                                femaleAsset,
                                isWomanSelected
                                    ? Colors.white
                                    : hexToColor("#4A4A4A")),
                            SizedBox(
                              width: 50,
                            ),
                            Text(
                              'Women',
                              style: getDefaultBoldTextStyle().copyWith(
                                  color: isWomanSelected
                                      ? Colors.white
                                      : hexToColor("#4A4A4A"),
                                  fontSize: 20,
                                  letterSpacing: 0.6),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        color: isManSelected ? secondaryBg : Colors.white,
                        padding: EdgeInsets.only(left: 36, top: 12, bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onPressed: () {
                          setState(() {
                            isManSelected = !isManSelected;
                          });
                        },
                        child: Row(children: [
                          svg(
                              maleAsset,
                              isManSelected
                                  ? Colors.white
                                  : hexToColor("#4A4A4A")),
                          SizedBox(
                            width: 45,
                          ),
                          Text(
                            'Men',
                            style: getDefaultBoldTextStyle().copyWith(
                                color: isManSelected
                                    ? Colors.white
                                    : hexToColor("#4A4A4A"),
                                fontSize: 20,
                                letterSpacing: 0.6),
                          ),
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        color: isNonBinSelected ? secondaryBg : Colors.white,
                        padding: EdgeInsets.only(left: 36, top: 12, bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onPressed: () {
                          setState(() {
                            isNonBinSelected = !isNonBinSelected;
                          });
                        },
                        child: Row(children: [
                          svg(
                              femaleAsset,
                              isNonBinSelected
                                  ? Colors.white
                                  : hexToColor("#4A4A4A")),
                          svg(
                              maleAsset,
                              isNonBinSelected
                                  ? Colors.white
                                  : hexToColor("#4A4A4A")),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            'Gender X',
                            style: getDefaultBoldTextStyle().copyWith(
                                color: isNonBinSelected
                                    ? Colors.white
                                    : hexToColor("#4A4A4A"),
                                fontSize: 20,
                                letterSpacing: 0.6),
                          ),
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 48, right: 48),
              child: Visibility(
                visible: isDateSpotPrefVisible,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Add your 3 favourite date spots",
                      style: getDefaultBoldTextStyle(),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16),
                      height: (_restList.length * 100).toDouble(),
                      child: ListView.builder(
                        itemCount: _restList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: double.infinity,
                              child: DottedBorder(
                                color: hexToColor("#AAAAAA"),
                                child: Center(
                                  child: FlatButton.icon(
                                    icon: Icon(
                                      Icons.restaurant,
                                      color: secondaryBg,
                                    ),
                                    color: Colors.transparent,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    onPressed: null,
                                    label: Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _restList[index].restName,
                                            style: getDefaultBoldTextStyle()
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    letterSpacing: 0.14),
                                          ),
                                          Text(
                                            _restList[index].locality,
                                            style: getDefaultBoldTextStyle()
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    letterSpacing: 0.14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Visibility(
                      visible: _isSearchVisible,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            primaryColor: Colors.white,
                            hintColor: Colors.white,
                            iconTheme: IconThemeData(color: Colors.white)),
                        child: TextFormField(
                          onChanged: (text) {
                            _restName = text;
                          },
                          style: getDefaultTextStyle().copyWith(
                            decorationColor: Colors.white,
                          ),
                          textInputAction: TextInputAction.search,
                          onFieldSubmitted: (value) {
                            _searchRestaurant();
                            // _clearRestaurantList();
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.restaurant),
                            hintText: "Enter Restaurant Name",
                            border: OutlineInputBorder(),
                            filled: true,
                            suffixIcon: IconButton(
                              onPressed: () => _searchRestaurant(),
                              icon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Visibility(
                      visible: isLoadVisiblity,
                      child: Center(
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(accentColor: Colors.white),
                          child: CircularProgressIndicator(
                            backgroundColor: secondaryBg,
                            semanticsLabel: "Searching ...",
                          ),
                        ),
                      ),
                    ),
                    (_responseRestList == null || _responseRestList.length == 0)
                        ? Text('')
                        : Visibility(
                            visible: _isSearchVisible,
                            child: SizedBox(
                              height: 300,
                              child: ListView(
                                children: _responseRestList.map((rest) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    color: secondaryBg,
                                    child: ListTile(
                                      onTap: () {
                                        String item =
                                            rest['restaurant']['name'];
                                        String id = rest['restaurant']['id'];
                                        String locality = rest['restaurant']
                                            ['location']['locality'];
                                        var restaurant = Restaurant(id, item,
                                            locality: locality);
                                        if (!_restList.contains(restaurant)) {
                                          _restList.add(restaurant);
                                        }
                                        _refreshList();
                                      },
                                      title: Text(
                                        rest['restaurant']['name'],
                                        style: getDefaultTextStyle(),
                                      ),
                                      subtitle: Text(
                                        rest['restaurant']['location']
                                            ['locality'],
                                        style: getDefaultTextStyle()
                                            .copyWith(fontSize: 12),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Row(
              children: [
                Spacer(),
                Visibility(
                  visible: isSkipTextVisible,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 32),
                    child: InkWell(
                      onTap: () {
                        // if (isDateSpotPrefVisible) {
                        //   createUser();
                        // }
                        _clearRestaurantList();
                      },
                      child: Text(
                        "Skip for now",
                        style: getDefaultTextStyle().copyWith(
                          color: hexToColor("#AAAAAA"),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Visibility(
                  visible: isFabVisible,
                  child: Container(
                    margin: EdgeInsets.only(right: 24, bottom: 40),
                    child: FloatingActionButton(
                      child: isUserDetailsCompleted
                          ? Icon(Icons.check)
                          : Icon(Icons.arrow_forward),
                      backgroundColor: secondaryBg,
                      onPressed: () {
                        if (isGenderPrefVisible) {
                          if (isManSelected &&
                              isWomanSelected &&
                              isNonBinSelected) {
                            widget.user.matchingPreferences.prefGender =
                                GenderPref.MAN__WOMAN__NON_BINARY;
                          } else if (isManSelected &&
                              isWomanSelected &&
                              !isNonBinSelected) {
                            widget.user.matchingPreferences.prefGender =
                                GenderPref.MAN__WOMAN;
                          } else if (isManSelected &&
                              isNonBinSelected &&
                              !isWomanSelected) {
                            widget.user.matchingPreferences.prefGender =
                                GenderPref.MAN__NON_BINARY;
                          } else if (isNonBinSelected &&
                              isWomanSelected &&
                              !isManSelected) {
                            widget.user.matchingPreferences.prefGender =
                                GenderPref.WOMAN__NON_BINARY;
                          } else if (isNonBinSelected) {
                            widget.user.matchingPreferences.prefGender =
                                GenderPref.NON_BINARY;
                          } else if (isManSelected) {
                            widget.user.matchingPreferences.prefGender =
                                GenderPref.MAN;
                          } else if (isWomanSelected) {
                            widget.user.matchingPreferences.prefGender =
                                GenderPref.WOMAN;
                          } else {
                            widget.user.matchingPreferences.prefGender =
                                GenderPref.NONE;
                          }
                          // print(widget.user.matchingPreferences.prefGender);
                        }
                        if (isDateSpotPrefVisible) {
                          createUser();
                        }
                        setState(() {
                          if (isGenderPrefVisible) {
                            isGenderPrefVisible = false;
                            isDateSpotPrefVisible = true;
                          }
                        });
                        setFabVisibility();
                        setSkipVisibility();
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void createUser() async {
    String uid = FireBase.auth.currentUser.uid;
    if (uid == null) {
      widget.user.reset();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Data mismatched. Please try again"),
      ));
      await FirebaseAuth.instance.signOut().whenComplete(() {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignUpLandingScreen()),
            ModalRoute.withName("/SignUp"));
      });
    } else {
      return await DatabaseService(firebaseUid: uid)
          .createCurrentUser(widget.user)
          .whenComplete(() {
        widget.action();
        print("action completed");
      });
    }
  }

  void _searchRestaurant() async {
    var pos = widget.user.position;
    setState(() {
      isLoadVisiblity = true;
    });

    final response = await widget.dio.get('', queryParameters: {
      'q': _restName,
      'lat': pos != null ? pos.latitude : null,
      'lon': pos != null ? pos.longitude : null,
      'count': 20
    });

    // print(response);
    setState(() {
      isLoadVisiblity = false;
      _responseRestList = response.data['restaurants'];
    });
  }

  void _clearRestaurantList() {
    setState(() {
      _isSearchVisible = true;
      _restList.clear();
    });
  }

  void _refreshList() {
    if (_restList.length == 3) {
      _isSearchVisible = false;
      isUserDetailsCompleted = true;
      widget.user.matchingPreferences.prefRestaurants = new List();
      _restList.forEach((element) {
        widget.user.matchingPreferences.prefRestaurants.add(element.id);
      });

      setFabVisibility();
    }
    setState(() {});
  }
}

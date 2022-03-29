import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:folx_dating/bloc/db_b_loc.dart';
import 'package:folx_dating/firebase/cloud_store.dart';
import 'package:folx_dating/models/User.dart';
import 'package:folx_dating/screens/signup/SignUpLanding.dart';
import 'package:folx_dating/styles/ColorConstants.dart';
import 'package:folx_dating/styles/StringConstants.dart';

class SettingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingSt();
}

class _SettingSt extends State<SettingScreen> {
  var isMenSelected = false;
  var isWomenSelected = false;
  var isNonBinSelected = false;
  var isLastSeenOn = false;
  var isDataChanged = false;

  FolxUser _folxUser;
  bool _isDataLoaded = false;

  @override
  void initState() {
    print("Setting");
    super.initState();
  }

  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDataLoaded) {
      _getCurrentUser();
    }
    if (isDataChanged) {
      updateMyUserPreferences();
      isDataChanged = false;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isDataLoaded
          ? Container(
              margin: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 42,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Matching Preferences',
                      style: getDefaultDarkBoldTextStyle(),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    /*Card(
                      elevation: 3,
                      shadowColor: hexToColor("#0000001F"),
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 16,
                          top: 10,
                          right: 15,
                          bottom: 10,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Maximum Distance',
                                  style: getDefaultDarkBoldTextStyle().copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '${_folxUser.matchingPreferences.maxDistance.round()} km',
                                  style: getDefaultDarkTextStyle().copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SliderTheme(
                              data: SliderThemeData().copyWith(
                                thumbColor: secondaryBg,
                                activeTrackColor: primaryBg,
                                inactiveTrackColor: Colors.grey,
                              ),
                              child: Slider(
                                min: 1,
                                max: 50,
                                value: _folxUser.matchingPreferences.maxDistance
                                    .roundToDouble(),
                                inactiveColor: hexToColor("#F4F4F4"),
                                onChanged: (value) {
                                  setState(() {
                                    _folxUser.matchingPreferences.maxDistance =
                                        value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),*/
                    SizedBox(
                      height: 12,
                    ),
                    Card(
                      elevation: 3,
                      shadowColor: hexToColor("#0000001F"),
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 16,
                          top: 10,
                          right: 15,
                          bottom: 10,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Age Range',
                                  style: getDefaultDarkBoldTextStyle().copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '${_folxUser.matchingPreferences.ageLowerLimit.round()}-${_folxUser.matchingPreferences.ageUpperLimit.round()}',
                                  style: getDefaultDarkTextStyle().copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SliderTheme(
                              data: SliderThemeData().copyWith(
                                thumbColor: secondaryBg,
                                activeTrackColor: primaryBg,
                                inactiveTrackColor: Colors.grey,
                              ),
                              child: RangeSlider(
                                min: 18,
                                max: 50,
                                values: RangeValues(
                                  _folxUser.matchingPreferences.ageLowerLimit
                                      .roundToDouble(),
                                  _folxUser.matchingPreferences.ageUpperLimit
                                      .roundToDouble(),
                                ),
                                inactiveColor: hexToColor("#F4F4F4"),
                                onChanged: (values) {
                                  setState(() {
                                    _folxUser.matchingPreferences
                                        .ageLowerLimit = values.start;
                                    _folxUser.matchingPreferences
                                        .ageUpperLimit = values.end;
                                    isDataChanged = true;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Card(
                      elevation: 3,
                      shadowColor: hexToColor("#0000001F"),
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 16,
                          top: 10,
                          right: 15,
                          bottom: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Show Me',
                              style: getDefaultDarkBoldTextStyle().copyWith(
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Men',
                                  style: getDefaultDarkTextStyle().copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                                Spacer(),
                                Switch(
                                  value: isMenSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      isMenSelected = value;
                                      isDataChanged = true;
                                    });
                                  },
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Women',
                                  style: getDefaultDarkTextStyle().copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                                Spacer(),
                                Switch(
                                  value: isWomenSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      isWomenSelected = value;
                                      isDataChanged = true;
                                    });
                                  },
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Gender X',
                                  style: getDefaultDarkTextStyle().copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                                Spacer(),
                                Switch(
                                  value: isNonBinSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      isNonBinSelected = value;
                                      isDataChanged = true;
                                    });
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Text(
                      'Privacy',
                      style: getDefaultDarkBoldTextStyle(),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Card(
                      elevation: 3,
                      shadowColor: hexToColor("#0000001F"),
                      child: Container(
                          padding: EdgeInsets.only(
                            left: 16,
                            top: 10,
                            right: 15,
                            bottom: 10,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Share your last seen',
                                style: getDefaultDarkBoldTextStyle(),
                              ),
                              Spacer(),
                              Switch(
                                value: _folxUser.shareLastSeen,
                                onChanged: (value) {
                                  setState(() {
                                    _folxUser.shareLastSeen = value;
                                    isDataChanged = true;
                                  });
                                },
                              )
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'If turned off, you won’t be able to see other people’s last seen either.',
                      style: getDefaultDarkTextStyle().copyWith(
                        fontSize: 10,
                        color: hexToColor("#808080"),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: RaisedButton.icon(
                          padding: EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 12,
                          ),
                          color: Colors.white,
                          icon: Icon(Icons.person_outline),//TODO: logout
                          label: Text(
                            'Logout',
                            style: getDefaultDarkBoldTextStyle(),
                          ),
                          onPressed: () async {
                            final FolxBloc bloc = FolxBloc();
                            bloc.deleteAll();
                            await FirebaseAuth.instance
                                .signOut()
                                .whenComplete(() {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SignUpLandingScreen()),
                                  ModalRoute.withName("/SignUp"));
                            });
                          }),
                    )
                  ],
                ),
              ),
            )
          : Center(
              child: Theme(
                data: Theme.of(context).copyWith(accentColor: primaryBg),
                child: CircularProgressIndicator(
                  backgroundColor: secondaryBg,
                  semanticsLabel: "Refreshing...",
                ),
              ),
            ),
    );
  }

  void _getCurrentUser() async {
    DatabaseService().snapshotMyUserData().then((value) {
      FolxUser user = FolxUser();
      user.matchingPreferences = UserMatchingPreferences();
      user.matchingPreferences.maxDistance =
          (value.get(maxDistance) as num).toDouble();
      user.matchingPreferences.ageLowerLimit =
          (value.get(ageLowerLimit) as num).toDouble();
      user.matchingPreferences.ageUpperLimit =
          (value.get(ageUpperLimit) as num).toDouble();

      GenderPref genderPref = getGenderPref(value.get(prefGender));
      user.matchingPreferences.prefGender = genderPref;
      user.shareLastSeen = value.get(shareLastSeen);
      if (user.shareLastSeen == null) {
        user.shareLastSeen = true;
      }

      isMenSelected = [
        GenderPref.MAN__WOMAN__NON_BINARY,
        GenderPref.MAN,
        GenderPref.MAN__NON_BINARY,
        GenderPref.MAN__WOMAN
      ].contains(genderPref);
      isWomenSelected = [
        GenderPref.MAN__WOMAN__NON_BINARY,
        GenderPref.WOMAN,
        GenderPref.WOMAN__NON_BINARY,
        GenderPref.MAN__WOMAN
      ].contains(genderPref);
      isNonBinSelected = [
        GenderPref.MAN__WOMAN__NON_BINARY,
        GenderPref.NON_BINARY,
        GenderPref.MAN__NON_BINARY,
        GenderPref.WOMAN__NON_BINARY
      ].contains(genderPref);

      setState(() {
        _folxUser = user;
        _isDataLoaded = true;
      });
    });
  }

  void updateMyUserPreferences() {
    if (isMenSelected && isWomenSelected && isNonBinSelected) {
      _folxUser.matchingPreferences.prefGender =
          GenderPref.MAN__WOMAN__NON_BINARY;
    } else if (isMenSelected && isWomenSelected && !isNonBinSelected) {
      _folxUser.matchingPreferences.prefGender = GenderPref.MAN__WOMAN;
    } else if (isMenSelected && isNonBinSelected && !isWomenSelected) {
      _folxUser.matchingPreferences.prefGender = GenderPref.MAN__NON_BINARY;
    } else if (isNonBinSelected && isWomenSelected && !isMenSelected) {
      _folxUser.matchingPreferences.prefGender = GenderPref.WOMAN__NON_BINARY;
    } else if (isNonBinSelected) {
      _folxUser.matchingPreferences.prefGender = GenderPref.NON_BINARY;
    } else if (isMenSelected) {
      _folxUser.matchingPreferences.prefGender = GenderPref.MAN;
    } else if (isWomenSelected) {
      _folxUser.matchingPreferences.prefGender = GenderPref.WOMAN;
    } else {
      _folxUser.matchingPreferences.prefGender = GenderPref.NONE;
    }
    DatabaseService().updateMyUserPreferences(_folxUser);
  }
}

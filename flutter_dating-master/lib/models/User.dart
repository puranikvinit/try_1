import 'dart:collection';

import 'package:folx_dating/models/Restaurant.dart';
import 'package:geolocator/geolocator.dart';

import '../CONSTANTS.dart';

class FolxUser {
  String id;
  String phoneNumber;
  String emailId;
  String userName;
  String userGender;
  String dob;
  int userAge;
  Work userWork;
  List userImageUrls;
  String userCoverImageUrl;
  UserMatchingPreferences matchingPreferences;
  bool shareLastSeen = true;
  Position position;
  Map<String, String> recommendations = new HashMap();
  List<String> likedBy = List.empty();
  Map<String, String> matchmap = new HashMap();
  Map<String, String> mapIceBreakers = new HashMap();

  FolxUser(
      {this.id,
      this.phoneNumber,
      this.emailId,
      this.userName,
      this.userGender,
      this.userAge,
      this.userWork,
      this.userImageUrls,
      this.userCoverImageUrl,
      this.matchingPreferences,
      this.position,
      this.shareLastSeen});

  void init() {
    recommendations["dummy"] = "dummy";
    likedBy = ["dummy"];
    matchmap["dummy"] = "dummy";
    mapIceBreakers["dummy"] = "dummy";
    this.userWork = new Work();
    this.matchingPreferences = new UserMatchingPreferences();
  }

  @override
  String toString() {
    return "pn -$phoneNumber, $emailId, un -$userName, sex -$userGender, age -$userAge, work-$userWork, img -$userImageUrls, $matchingPreferences";
  }

  void reset() {
    phoneNumber = "";
    emailId = "";
    userName = "";
    userGender = "";
    userAge = 18;
    userWork = new Work();
    userImageUrls.clear();
    matchingPreferences = new UserMatchingPreferences();
    shareLastSeen = true;
  }

  factory FolxUser.fromDatabaseJson(Map<String, dynamic> data) {
    Work work = Work();
    UserMatchingPreferences matchingPreferences = UserMatchingPreferences();

    work.profession = data[USER_PROFESSION];
    work.company = data[USER_COMPANY];
    work.university = data[USER_EDUCATION];

    // matchingPreferences.prefRestaurants = jsonDecode(data[USER_PREF_REST]);
    matchingPreferences.ageLowerLimit = data[USER_PREF_AGE_LOWER_LIMIT];
    matchingPreferences.ageUpperLimit = data[USER_PREF_AGE_UPPER_LIMIT];
    matchingPreferences.maxDistance = data[USER_PREF_DISTANCE];
    matchingPreferences.prefGender = getGenderPref(data[USER_PREF_GENDER]);

    FolxUser folxUser = FolxUser(
        id: data[USER_ID],
        phoneNumber: data[PHONE_NUMBER],
        emailId: data[EMAIL],
        userName: data[USERNAME],
        userGender: data[USER_GENDER],
        userAge: data[USER_AGE],
        // userImageUrls: data[USER_IMAGE_URLS],
        userCoverImageUrl: data[USER_COVER_IMAGE_URL],
        userWork: work,
        matchingPreferences: matchingPreferences,
        shareLastSeen: data[SHARE_LAST_SEEN] == 1);

    return folxUser;
  }

  Map<String, dynamic> toDatabaseJson() => {
        //This will be used to convert FolxUser objects that
        //are to be stored into the datbase in a form of JSON
        USER_ID: this.id,
        PHONE_NUMBER: this.phoneNumber,
        EMAIL: this.emailId,
        USERNAME: this.userName,
        USER_GENDER: this.userGender,
        USER_AGE: this.userAge,
        USER_IMAGE_URLS: this.userImageUrls.toString(),
        USER_COVER_IMAGE_URL:
            (this.userImageUrls != null && this.userImageUrls.isNotEmpty)
                ? this.userImageUrls[0]
                : this.userCoverImageUrl != null
                    ? this.userCoverImageUrl
                    : null,
        USER_PROFESSION: this.userWork.profession,
        USER_COMPANY: this.userWork.company,
        USER_EDUCATION: this.userWork.university,
        USER_PREF_REST: this
            .matchingPreferences
            .prefRestaurants
            .toString(), //jsonEncode(this.matchingPreferences.prefRestaurants),
        USER_PREF_AGE_LOWER_LIMIT: this.matchingPreferences.ageLowerLimit,
        USER_PREF_AGE_UPPER_LIMIT: this.matchingPreferences.ageUpperLimit,
        USER_PREF_DISTANCE: this.matchingPreferences.maxDistance,
        USER_PREF_GENDER: getGenderPrefInt(this.matchingPreferences.prefGender),
        SHARE_LAST_SEEN:
            this.shareLastSeen == null || this.shareLastSeen == true ? 1 : 0,
      };
}

class Work {
  String profession = "";
  String company = "";
  String university = "";

  @override
  String toString() {
    return "$profession, $company, $university";
  }
}

class UserMatchingPreferences {
  GenderPref prefGender;
  List<String> prefRestaurants;
  double maxDistance = 2;
  double ageLowerLimit = 18;
  double ageUpperLimit = 30;

  @override
  String toString() {
    return "${prefGender.toString()}, $prefRestaurants, $maxDistance, $ageLowerLimit, $ageUpperLimit";
  }

  bool isNotSet() {
    return prefRestaurants == null && prefGender == null;
  }
}

GenderPref getGenderPref(int choice) {
  GenderPref userCh = GenderPref.NONE;
  switch (choice) {
    case 1:
      userCh = GenderPref.MAN; //men
      break;
    case 2:
      userCh = GenderPref.WOMAN; //women
      break;
    case 3:
      userCh = GenderPref.NON_BINARY; //non binary
      break;
    case 4:
      userCh = GenderPref.MAN__WOMAN; //men+women
      break;
    case 5:
      userCh = GenderPref.MAN__NON_BINARY; //men+non_binary
      break;
    case 6:
      userCh = GenderPref.WOMAN__NON_BINARY; //women+non_binary
      break;
    case 7:
      userCh = GenderPref.MAN__WOMAN__NON_BINARY; //all
      break;
  }
  return userCh;
}

int getGenderPrefInt(GenderPref choice) {
  switch (choice) {
    case GenderPref.MAN:
      return 1; //men
      break;
    case GenderPref.WOMAN:
      return 2; //women
      break;
    case GenderPref.NON_BINARY:
      return 3; //non binary
      break;
    case GenderPref.MAN__WOMAN:
      return 4; //men+women
      break;
    case GenderPref.MAN__NON_BINARY:
      return 5; //men+non_binary
      break;
    case GenderPref.WOMAN__NON_BINARY:
      return 6; //women+non_binary
      break;
    case GenderPref.MAN__WOMAN__NON_BINARY:
      return 7; //all
      break;
    default:
      return -1;
  }
}

enum GenderPref {
  MAN,
  WOMAN,
  NON_BINARY,
  MAN__WOMAN,
  MAN__NON_BINARY,
  WOMAN__NON_BINARY,
  MAN__WOMAN__NON_BINARY,
  NONE
}

HashMap<String, String> getRestMap(List<Restaurant> prefRestaurants) {
  HashMap<String, String> map = new HashMap<String, String>();
  prefRestaurants.forEach((rest) {
    map[rest.id] = rest.restName;
  });
  return map;
}

List<Restaurant> getRestList(HashMap<String, String> restMap) {
  List<Restaurant> rest = new List();
  restMap.forEach((key, value) {
    rest.add(Restaurant(key, value));
  });
  return rest;
}

const String LIKE = "like";
const String UN_LIKE = "unlike";
const String NOT_SEEN = "none";

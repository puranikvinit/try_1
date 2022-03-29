import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:folx_dating/auth/auth.dart';
import 'package:folx_dating/models/MessageList.dart';
import 'package:folx_dating/models/User.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';

class DatabaseService {
  final String firebaseUid;
  final String myFirebaseUid = FireBase.auth.currentUser.uid;

  DatabaseService({this.firebaseUid});

  final databaseReference = FirebaseFirestore.instance;

  //folx user
  final CollectionReference folxUserCollection =
      FirebaseFirestore.instance.collection(appUserCollection);

  final CollectionReference folxGeoCollection =
      FirebaseFirestore.instance.collection(appGeoCollection);

  final CollectionReference folxRoomCollection =
      FirebaseFirestore.instance.collection(roomCollection);

  final Query folxRoomCollectionGroup =
      FirebaseFirestore.instance.collectionGroup(latestMsgGrp);

  Future createCurrentUser(FolxUser folxUser) async {
    // print('createUser : $folxUser');
    // _addGeoPoint(folxUser);
    return await folxUserCollection.doc(myFirebaseUid).set({
      phNumber: folxUser.phoneNumber,
      emailId: folxUser.emailId,
      userName: folxUser.userName,
      userGender: folxUser.userGender,
      dob: folxUser.dob,
      userAge: folxUser.userAge,
      userImageUrls: folxUser.userImageUrls,
      shareLastSeen: folxUser.shareLastSeen,
      university: folxUser.userWork.university,
      company: folxUser.userWork.company,
      profession: folxUser.userWork.profession,
      coverImg: folxUser.userImageUrls == null || folxUser.userImageUrls.isEmpty
          ? ""
          : folxUser.userImageUrls[0],
      prefRestaurants: folxUser.matchingPreferences.prefRestaurants,
      maxDistance: folxUser.matchingPreferences.maxDistance,
      ageLowerLimit: folxUser.matchingPreferences.ageLowerLimit,
      ageUpperLimit: folxUser.matchingPreferences.ageUpperLimit,
      prefGender: getGenderPrefInt(folxUser.matchingPreferences.prefGender),
      geoPoint:
          GeoPoint(folxUser.position.latitude, folxUser.position.longitude),
      recommendations: folxUser.recommendations,
      matches: folxUser.matchmap,
      likeBy: folxUser.likedBy,
      ice_breaker: folxUser.mapIceBreakers
    });
  }

/*
  Future<void> _addGeoPoint(FolxUser folxUser) async {
    Geoflutterfire geo = Geoflutterfire();
    GeoFirePoint geoFirePoint = geo.point(
        latitude: folxUser.position.latitude,
        longitude: folxUser.position.longitude);

    folxGeoCollection.add({
      position: geoFirePoint.data,
      userId: firebaseUid,
      userGender: folxUser.userGender,
      userAge: folxUser.userAge
    });
  }*/

  Future<DocumentSnapshot> snapshotMyUserData() async {
    String userId = FireBase.auth.currentUser.uid;
    print("current user id $userId");
    Stream<DocumentSnapshot> dShot = folxUserCollection.doc(userId).snapshots();
    return dShot.first;
  }

  Future<FolxUser> getMyUser() async {
    DocumentSnapshot value = await snapshotMyUserData();
    FolxUser user = new FolxUser();
    user.id = myFirebaseUid;
    user.phoneNumber = value.get(phNumber);
    user.emailId = value.get(emailId);
    user.userName = value.get(userName);
    user.userGender = value.get(userGender);
    user.dob = value.get(dob);
    user.userAge = value.get(userAge);
    user.userImageUrls = value.get(userImageUrls);
    user.shareLastSeen = value.get(shareLastSeen);
    user.userCoverImageUrl = value.get(coverImg);
    if ((user.userCoverImageUrl == null || user.userCoverImageUrl.isEmpty) &&
        (user.userImageUrls != null && user.userImageUrls.isNotEmpty)) {
      user.userCoverImageUrl = user.userImageUrls.first;
    }
    user.recommendations =
        new Map<String, String>.from(value.get(recommendations));
    user.matchmap = new Map<String, String>.from(value.get(matches));
    user.likedBy = new List<String>.from(value.get(likeBy));

    user.mapIceBreakers = new Map<String, String>.from(value.get(ice_breaker));
    user.mapIceBreakers.remove("dummy");

    user.userWork = new Work();
    user.userWork.university = value.get(university);
    user.userWork.company = value.get(company);
    user.userWork.profession = value.get(profession);
    var position = value.get(geoPoint) as GeoPoint;
    user.position =
        Position(latitude: position.latitude, longitude: position.longitude);

    UserMatchingPreferences userMatchingPreferences = UserMatchingPreferences();
    userMatchingPreferences.prefRestaurants =
        (value.get(prefRestaurants) as List)?.map((e) => e as String)?.toList();
    userMatchingPreferences.prefGender =
        getGenderPref(value.get(prefGender) as num);
    userMatchingPreferences.ageLowerLimit =
        (value.get(ageLowerLimit) as num).toDouble();
    userMatchingPreferences.ageUpperLimit =
        (value.get(ageUpperLimit) as num).toDouble();
    user.matchingPreferences = userMatchingPreferences;

    return user;
  }

  Future<List<QueryDocumentSnapshot>> getUsersBasedOnPref(
      UserMatchingPreferences userMatchingPreferences,
      Map<String, String> recommendations) async {
    var str = userMatchingPreferences.prefGender;
    var prefGenderTypes =
        str.toString().substring(str.toString().indexOf('.') + 1).split('__');
    var docList = List<QueryDocumentSnapshot>();
    await folxUserCollection
        .where('$prefRestaurants',
            arrayContainsAny: userMatchingPreferences.prefRestaurants)
        .where('$userAge',
            isGreaterThanOrEqualTo: userMatchingPreferences.ageLowerLimit)
        .where('$userAge',
            isLessThanOrEqualTo: userMatchingPreferences.ageUpperLimit)
        .get()
        .then((document) {
      var doc;
      List<String> seenUserList = new List();
      if (recommendations.isNotEmpty) {
        recommendations.remove("dummy");
        if (recommendations.length > 1) {
          recommendations.forEach((key, value) {
            if (value == LIKE || value == UN_LIKE) {
              seenUserList.add(key);
            }
          });
          doc = document.docs.where((element) =>
              !seenUserList.contains(element.id) &&
              element.id != myFirebaseUid);
        }
      } else {
        doc = document.docs.where((element) =>
            prefGenderTypes.contains(element.get(userGender)) &&
            element.id != myFirebaseUid);
      }
      docList = doc == null ? docList : doc.toList();
    });
    return docList;
  }

  void getListOfUserMatchingPref(
      UserMatchingPreferences preferences, Position position) {
    // BehaviorSubject<double> radius =
    //     BehaviorSubject.seeded(preferences.maxDistance);
  }

  void getRestMatchingUsers() {
    folxUserCollection
        .where('$prefRestaurants', arrayContainsAny: ['', ''])
        .get()
        .then((document) {
          print(document.size);
        });
  }

  void query(Position ps, UserMatchingPreferences preferences) {
    Geoflutterfire geo = Geoflutterfire();

    GeoFirePoint center =
        geo.point(latitude: ps.latitude, longitude: ps.longitude);
    geo.collection(collectionRef: folxGeoCollection).within(
        center: center, radius: preferences.maxDistance, field: position);
  }

  FolxUser getFolxUserFromElement(DocumentSnapshot value) {
    FolxUser user = FolxUser();
    UserMatchingPreferences userMatchingPreferences = UserMatchingPreferences();
    userMatchingPreferences.prefRestaurants =
        (value.get(prefRestaurants) as List)?.map((e) => e as String)?.toList();
    /*userMatchingPreferences.prefGender =
        getGenderPref(value.get(prefGender) as num);
    userMatchingPreferences.ageLowerLimit =
        (value.get(ageLowerLimit) as num).toDouble();
    userMatchingPreferences.ageUpperLimit =
        (value.get(ageUpperLimit) as num).toDouble();
    user.matchingPreferences = userMatchingPreferences;*/
    // user.phoneNumber = value.get(phNumber);
    // user.emailId = value.get(emailId);
    user.id = value.id;
    user.userName = value.get(userName);
    user.userGender = value.get(userGender);
    // user.dob = value.get(dob);
    user.userAge = value.get(userAge);
    user.userImageUrls = value.get(userImageUrls);
    // user.shareLastSeen = value.get(shareLastSeen);
    user.userWork = new Work();
    user.userWork.university = value.get(university);
    user.userWork.company = value.get(company);
    user.userWork.profession = value.get(profession);
    // user.userCoverImageUrl = value.get(coverImg);
    // user.shareLastSeen = value.get(shareLastSeen);
    var position = value.get(geoPoint) as GeoPoint;

    user.position =
        Position(latitude: position.latitude, longitude: position.longitude);
    user.mapIceBreakers = new Map<String, String>.from(value.get(ice_breaker));
    user.mapIceBreakers.remove("dummy");
    //
    // if (user.shareLastSeen == null) {
    //   user.shareLastSeen = true;
    // }
    return user;
  }

  void like(FolxUser myUser, String _2ndUserId, Function callback) {
    if (myUser.likedBy != null && myUser.likedBy.contains(_2ndUserId)) {
      //the user has liked me already and i did a like on the user
      //so its a match
      //create a room id with and add it to match list

      if (myUser.matchmap == null) {
        myUser.matchmap = new HashMap<String, String>();
      }

      if (!myUser.matchmap.containsKey(_2ndUserId)) {
        folxRoomCollection.add({
          participant1: myUser.id,
          participant2: _2ndUserId,
        }).then((value) async {
          String commondRoomid = value.id;
          myUser.matchmap[_2ndUserId] = commondRoomid;
          await folxUserCollection
              .doc(_2ndUserId)
              .update({"$matches.$myFirebaseUid": commondRoomid});
          await folxUserCollection
              .doc(myFirebaseUid)
              .update({'$matches.$_2ndUserId': commondRoomid});
          callback();
        });
      } else {
        callback();
      }
    } else {
      // i have liked the other user, so just add my like by into his list and
      // add the user intoo my list.

      if (myUser.recommendations == null) {
        myUser.recommendations = new HashMap<String, String>();
      }
      myUser.recommendations[_2ndUserId] = LIKE;
      folxUserCollection
          .doc(myFirebaseUid)
          .update({'$recommendations.$_2ndUserId': LIKE});
      folxUserCollection.doc(_2ndUserId).update({
        likeBy: FieldValue.arrayUnion([myUser.id])
      });
      callback();
    }
  }

  void dislike(FolxUser myUser, String _2ndUserId, void Function() onDislike) {
    if (myUser.recommendations == null) {
      myUser.recommendations = new HashMap<String, String>();
    }
    myUser.recommendations[_2ndUserId] = UN_LIKE;
    folxUserCollection
        .doc(myFirebaseUid)
        .update({'$recommendations.$_2ndUserId': UN_LIKE});
    onDislike();
  }

  Future<List<MessageList>> getMessageList() async {
    Map<String, MessageList> msgListMap = new HashMap();
    await folxUserCollection.doc(myFirebaseUid).get().then((value) async {
      var matchesMap = new Map<String, String>.from(value.get(matches));
      var reverseMap = matchesMap.map((k, v) => MapEntry(v, k));
      matchesMap.remove("dummy");
      if (matchesMap.isEmpty) {
        print("No matches found");
        return;
      }

      // print('${matchesMap.values.toList()}');
      //matchMap is a map of userId -> RoomId
      //reverseMap is a map of RoomId -> userId
      //msgListMap is a map of userid -> lastMsgs
      await folxRoomCollectionGroup
          .where(doc_id, whereIn: matchesMap.values.toList())
          .get()
          .then((value) {
        value.docs.forEach((element) {
          var timeStamp = element.get(sent_at) as Timestamp;
          msgListMap[reverseMap[element.get(doc_id)]] = MessageList(
              lastMsg: element.get(msg),
              lastMsgTime: timeStamp.millisecondsSinceEpoch,
              roomId: element.get(doc_id));
          print(element.data());
        });
      });

      await folxUserCollection
          .where(FieldPath.documentId, whereIn: matchesMap.keys.toList())
          .get()
          .then((value) {
        value.docs.forEach((element) {
          List imgs = element.get(userImageUrls);

          String userImg = "";
          if (imgs != null && imgs.isNotEmpty) {
            userImg = imgs[0];
          }
          var msgList = msgListMap[element.id];
          msgList.avatarUrl = userImg;
          msgList.userName = element.get(userName);
          msgListMap[element.id] = msgList;
        });
      });
    });
    return msgListMap.values.toList();
  }

  getConversationMessages(String roomId) async {
    return folxRoomCollection
        .doc(roomId)
        .collection("chats")
        .orderBy(sent_at, descending: true)
        .snapshots();
  }

  addMessage(String chatRoomId, chatMessageData) {
    folxRoomCollection
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  void updateRecommendations(List<QueryDocumentSnapshot> swipeList) {
    swipeList.forEach((element) {
      folxUserCollection
          .doc(myFirebaseUid)
          .update({'$recommendations.${element.id}': NOT_SEEN});
    });
  }

  void updateMyselfWhenDocChange({
    Function(Map<String, String>) icebreakerListCallback,
    Function(String) userCoverImg,
  }) {
    folxUserCollection.doc(myFirebaseUid).snapshots().listen((querySnapshot) {
      // var value =
      //     new Map<String, String>.from(querySnapshot.get(recommendations));
      if (icebreakerListCallback != null) {
        var mapIceBreakers =
            new Map<String, String>.from(querySnapshot.get(ice_breaker));
        mapIceBreakers.remove("dummy");
        icebreakerListCallback(mapIceBreakers);
      }

      if (userCoverImg != null) {
        List imageList = querySnapshot.get(userImageUrls);
        if (imageList != null && imageList.isNotEmpty) {
          userCoverImg(imageList.first);
        }
      }

      // print(value);
    });
  }

  void addMyIceBreaker(String ques, String response) {
    folxUserCollection
        .doc(myFirebaseUid)
        .update({'$ice_breaker.$ques': response});
  }

  void addNewImage(imageUrl) {
    folxUserCollection.doc(myFirebaseUid).update({
      userImageUrls: FieldValue.arrayUnion([imageUrl])
    });
  }

  void deleteMyRestaurant(String restId) {
    folxUserCollection.doc(myFirebaseUid).update({
      prefRestaurants: FieldValue.arrayRemove([restId])
    });
  }

  void addNewRestaurants(List restId) {
    folxUserCollection
        .doc(myFirebaseUid)
        .update({prefRestaurants: FieldValue.arrayUnion(restId)});
  }

  void updateMyUserPreferences(FolxUser folxUser) {
    folxUserCollection.doc(myFirebaseUid).update({
      ageLowerLimit: folxUser.matchingPreferences.ageLowerLimit,
      ageUpperLimit: folxUser.matchingPreferences.ageUpperLimit,
      shareLastSeen: folxUser.shareLastSeen,
      prefGender: getGenderPrefInt(folxUser.matchingPreferences.prefGender),
    });
  }
}

const String appUserCollection = "folx_users";

const String userId = "uid";
const String phNumber = "pn";
const String emailId = "eml";
const String userName = "un";
const String userGender = "sex";
const String dob = "dob";
const String userAge = "age";
const String userImageUrls = "imgs";
const String shareLastSeen = "ls";
const String university = "edu";
const String company = "comp";
const String profession = "pro";
const String coverImg = "cover";
const String prefRestaurants = "pRes";
const String maxDistance = "mxD";
const String ageLowerLimit = "llAge";
const String ageUpperLimit = "ulAge";
const String geoPoint = "loc";
const String prefGender = "pSex";
const String ice_breaker = "ib";
// const String likedArray = "likeArr";
// const String dislikedArray = "disArr";
// const String matchIds = "matchArr";
const String recommendations = "rc";
const String matches = "match";
const String likeBy = "likeBy";

const String appGeoCollection = "folx_geo";
const String position = "ps";

const String roomCollection = "rooms";
const String participant1 = "p1";
const String participant2 = "p2";
const String messages = "msg";
const String text = "txt";

const String latestMsgGrp = "latest_msg";
const String summary = "summary";
const String msg = "msg";
const String doc_id = "doc_id";
const String sent_at = "sent_at";
const String sent_by = "sent_by";

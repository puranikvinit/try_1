import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:folx_dating/auth/auth.dart';
import 'package:folx_dating/models/User.dart';
import 'package:folx_dating/styles/BackgroundStyles.dart';
import 'package:folx_dating/styles/ColorConstants.dart';
import 'package:folx_dating/styles/StringConstants.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class UserProperty extends StatefulWidget {
  final FolxUser user;
  final VoidCallback callback;

  UserProperty(this.user, this.callback);

  @override
  State<StatefulWidget> createState() => _UserGender();
}

class _UserGender extends State<UserProperty> {
  bool isGenderInputVisible = true;
  bool isWorkInputVisible = false;
  bool isPictureInputVisible = false;

  bool isManSelected = false;
  bool isWomanSelected = false;
  bool isNonBinSelected = false;

  bool isSkipTextVisible = false;
  bool isFabVisible = true;

  bool isUploading = false;

  List<Asset> images = List<Asset>();

  List<String> imageUrls = List<String>();

  String _error = "";

  // firebase_storage.FirebaseStorage storage =
  //     firebase_storage.FirebaseStorage.instance;

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    print("_userGender");
    super.initState();
  }

  void setFabVisibility() {
    setState(() {
      Work userWork = widget.user.userWork;
      if (isWorkInputVisible) {
        print("setFabVisibility ->");
        print(userWork);
        if (userWork.profession.isNotEmpty &&
            userWork.company.isNotEmpty &&
            userWork.university.isNotEmpty) {
          isFabVisible = true;
        } else {
          isFabVisible = false;
        }
      }

      if (isPictureInputVisible) {
        if (images.length > 0) {
          isFabVisible = !isUploading;
        } else {
          isFabVisible = false;
        }
      }
    });
  }

  void setSkipVisibility() {
    setState(() {
      if (isWorkInputVisible) isSkipTextVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primaryBg,
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 48,
              right: 48,
            ),
            child: Visibility(
              visible: isGenderInputVisible,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Choose your Gender Identity",
                    style: getDefaultBoldTextStyle(),
                  ),
                  SizedBox(
                    height: 24,
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
                          isManSelected = true;
                          isWomanSelected = false;
                          isNonBinSelected = false;
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
                          'Man',
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
                      color: isWomanSelected ? secondaryBg : Colors.white,
                      padding: EdgeInsets.only(left: 36, top: 12, bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onPressed: () {
                        setState(() {
                          isManSelected = false;
                          isWomanSelected = true;
                          isNonBinSelected = false;
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
                            'Woman',
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
                      color: isNonBinSelected ? secondaryBg : Colors.white,
                      padding: EdgeInsets.only(left: 36, top: 12, bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onPressed: () {
                        setState(() {
                          isManSelected = false;
                          isWomanSelected = false;
                          isNonBinSelected = true;
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
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 48, right: 48),
            child: Visibility(
              visible: isWorkInputVisible,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "What do you do for work?",
                    style: getDefaultBoldTextStyle(),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextField(
                      onChanged: (text) {
                        widget.user.userWork.profession = text;
                        setFabVisibility();
                      },
                      style: getDefaultTextStyle(),
                      decoration:
                          getDefaultInputDecoration("Profession").copyWith(
                        isCollapsed: true,
                        contentPadding: EdgeInsets.all(4),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextField(
                      onChanged: (text) {
                        widget.user.userWork.company = text;
                        setFabVisibility();
                      },
                      style: getDefaultTextStyle(),
                      decoration: getDefaultInputDecoration("Company").copyWith(
                        isCollapsed: true,
                        contentPadding: EdgeInsets.all(4),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextField(
                      onChanged: (text) {
                        widget.user.userWork.university = text;
                        setFabVisibility();
                      },
                      style: getDefaultTextStyle(),
                      decoration:
                          getDefaultInputDecoration("University").copyWith(
                        isCollapsed: true,
                        contentPadding: EdgeInsets.all(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 48, right: 48),
            child: Visibility(
              visible: isPictureInputVisible,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Show off your best pictures!",
                    style: getDefaultBoldTextStyle(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    children: List.generate(6, (index) {
                      Asset asset =
                          index < images.length ? images[index] : null;
                      return asset == null
                          ? Container(
                              margin: EdgeInsets.all(3),
                              width: 300,
                              height: 300,
                              child: Card(
                                child: Image(
                                  image: AssetImage(
                                      imagePath + "img_placeholder.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
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
                    height: 10,
                  ),
                  Text(
                    _error,
                    style: getDefaultTextStyle().copyWith(
                      fontSize: 12,
                      letterSpacing: 0.14,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      Visibility(
                        visible: !isUploading,
                        child: FloatingActionButton(
                          child: Icon(Icons.add_a_photo),
                          backgroundColor: secondaryBg,
                          onPressed: isUploading ? null : loadAssets,
                        ),
                      ),
                      Visibility(
                        visible: isUploading,
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(accentColor: Colors.white),
                          child: CircularProgressIndicator(
                            backgroundColor: secondaryBg,
                            semanticsLabel: "Uploading in progress",
                          ),
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      Text(
                        'Add multiple images in order',
                        style: getDefaultTextStyle(),
                      ),
                      Spacer()
                    ],
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Spacer(),
                Visibility(
                  visible: isSkipTextVisible,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 32),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (isWorkInputVisible) {
                            isWorkInputVisible = false;
                            isPictureInputVisible = true;
                          } else if (isPictureInputVisible) {
                            checkUploadStatus();
                          }
                        });
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
                      child: Icon(Icons.arrow_forward),
                      backgroundColor: secondaryBg,
                      onPressed: () {
                        setState(() {
                          if (isManSelected ||
                              isWomanSelected ||
                              isNonBinSelected) {
                            if (isGenderInputVisible) {
                              isGenderInputVisible = false;
                              isFabVisible = false;
                              isWorkInputVisible = true;
                            } else if (isWorkInputVisible) {
                              isWorkInputVisible = false;
                              isPictureInputVisible = true;
                            } else if (isPictureInputVisible) {
                              saveImages();
                            }
                          }
                        });
                        setFabVisibility();
                        setSkipVisibility();
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList = List<Asset>();
    String error = '';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 6,
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

    setState(() {
      images = resultList;
      setFabVisibility();
      _error = error;
    });
  }

  void showLoader() {
    setState(() {
      isUploading = true;
    });
  }

  void hideLoader() {
    setState(() {
      isUploading = false;
    });
  }

  void checkUploadStatus() {
    if (imageUrls.length == images.length) {
      print(widget.user);
      widget.user.userGender = isManSelected
          ? "MAN"
          : isWomanSelected
              ? "WOMAN"
              : "NBN";
      widget.user.userImageUrls = imageUrls;
      widget.callback();
    }
  }

  Future saveImages() async {
    if (images.isEmpty) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Upload at least one image"),
      ));
      return;
    }
    int total = images.length;
    String userId = FireBase.auth.currentUser.uid;
    showLoader();
    try {
      for (int i = 0; i < total; i++) {
        Asset asset = images[i];
        String fileName = "${i + 1}";
        ByteData byteData = await asset.getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        StorageReference ref =
            FirebaseStorage.instance.ref().child("$userId/$fileName");
        StorageUploadTask uploadTask = ref.putData(imageData);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        taskSnapshot.ref.getDownloadURL().then((value) {
          print("Done: $value");
          imageUrls.add(value);
          checkUploadStatus();
        });
      }
    } catch (e) {
      hideLoader();
    }
  }
}

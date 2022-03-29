import 'package:flutter/material.dart';
import 'package:folx_dating/models/User.dart';
import 'package:folx_dating/screens/pages/pagelist/PhoneAuthentication.dart';
import 'package:folx_dating/screens/pages/pagelist/UserDetail.dart';
import 'package:folx_dating/screens/pages/pagelist/UserPreference.dart';
import 'package:folx_dating/screens/pages/pagelist/UserProperty.dart';

List<Widget> getPagingScreens(FolxUser user, VoidCallback action) {
  return [
    PhoneAuthentication(user, action, false),
    UserDetail(user, action),
    UserProperty(user, action),
    UserPreference(user, action),
  ];
}

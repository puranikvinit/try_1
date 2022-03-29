import 'package:folx_dating/dao/folxUserDbDao.dart';
import 'package:folx_dating/models/User.dart';

class FolxRepository {
  final folxDao = FolxDao();

  Future getAllFolxUsers({String query}) => folxDao.getUsers(query: query);

  Future insertUser(FolxUser folxUser) => folxDao.createFolxUser(folxUser);

  Future updateUser(FolxUser folxUser) => folxDao.updateUser(folxUser);

  Future deleteUserById(int id) => folxDao.deleteUser(id);

  //We are not going to use this in the demo
  Future deleteAllUsers() => folxDao.deleteAllUsers();

  Future getPref(String pref) => folxDao.getPref(pref);

  setPref(String prefName, String value) => folxDao.setPref(prefName, value);

  void deleteAll() => folxDao.deleteAll();
}

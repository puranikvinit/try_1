import 'dart:async';

import 'package:folx_dating/models/User.dart';
import 'package:folx_dating/repo/FolxRepo.dart';

class FolxBloc {
  //Get instance of the Repository
  final _folxRepository = FolxRepository();

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  final _folxController = StreamController<List<FolxUser>>.broadcast();

  get folxs => _folxController.stream;

  FolxBloc();

  getFolxs({String query}) async {
    //sink is a way of adding data reactively to the stream
    //by registering a new event
    _folxController.sink
        .add(await _folxRepository.getAllFolxUsers(query: query));
  }

  addFolx(FolxUser folxUser) async {
    await _folxRepository.insertUser(folxUser);
    getFolxs();
  }

  updateFolx(FolxUser folxUser) async {
    await _folxRepository.updateUser(folxUser);
    getFolxs();
  }

  deleteFolxById(int id) async {
    _folxRepository.deleteUserById(id);
    getFolxs();
  }

  dispose() {
    _folxController.close();
  }

  Future<bool> getBooleanPref(String prefName, bool def) async {
    try {
      var result = await _folxRepository.getPref(prefName);
      return result.first.row[0] == '1';
    } catch (e) {
      return def;
    }
  }

  deleteAll() async {
    _folxRepository.deleteAll();
  }

  setBooleanPref(String prefName, String value) async {
    await _folxRepository.setPref(prefName, value);
  }
}

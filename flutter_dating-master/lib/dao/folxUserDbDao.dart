import 'dart:async';

import 'package:folx_dating/db/folx%20db.dart';
import 'package:folx_dating/models/User.dart';

import '../CONSTANTS.dart';

class FolxDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createFolxUser(FolxUser folxUser) async {
    final db = await dbProvider.database;
    print(folxUser.toDatabaseJson());
    var result = db.insert(FOLX_TABLE, folxUser.toDatabaseJson());
    return result;
  }

  //Searches if query string was passed
  //where cols 'description LIKE ?'
  //where args ["%$query%"]
  Future<List<FolxUser>> getUsers(
      {List<String> columns,
      String query,
      String whereCols,
      String whereArgs}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(FOLX_TABLE,
            columns: columns, where: whereCols, whereArgs: [whereArgs]);
    } else {
      result = await db.query(FOLX_TABLE, columns: columns);
    }

    List<FolxUser> users = result.isNotEmpty
        ? result.map((item) => FolxUser.fromDatabaseJson(item)).toList()
        : [];
    return users;
  }

  //Update FolxUser record
  Future<int> updateUser(FolxUser folxUser) async {
    final db = await dbProvider.database;

    var result = await db.update(FOLX_TABLE, folxUser.toDatabaseJson(),
        where: "id = ?", whereArgs: [folxUser.id]);

    return result;
  }

  //Delete folxUser records
  Future<int> deleteUser(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(FOLX_TABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  //We are not going to use this in the demo
  Future deleteAllUsers() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      FOLX_TABLE,
    );

    return result;
  }

  Future<dynamic> getPref(prefName) async {
    final db = await dbProvider.database;
    var result = await db.rawQuery(
        'SELECT $PREF_VALUE from $PREF_TABLE where $PREF_NAME = \'$prefName\'');
    return result;
  }

  setPref(String prefName, String value) async {
    final db = await dbProvider.database;
    var result =
        db.insert(PREF_TABLE, {PREF_NAME: prefName, PREF_VALUE: value});

    return result;
  }

  deleteAll() async {
    final db = await dbProvider.database;
    await db.delete(FOLX_TABLE);
    await db.delete(PREF_TABLE);
    // await db.delete(FOLX_TABLE);
  }
}

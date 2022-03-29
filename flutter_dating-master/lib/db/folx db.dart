import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../CONSTANTS.dart';

final FOLX_TABLE = 'folx_table';
final PREF_TABLE = 'pref_table';
final VIEW_TABLE = 'view_table';
final dbInstName = 'folx.db';

final dbVersion = 2;

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbInstName);
    var database = await openDatabase(path,
        version: dbVersion, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) async {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database database, int version) async {
    await database.execute(createUserTableQuery);
    await database.execute(prefTableQuery);
    await database.execute(usersDisplayedQuery);
  }

  String createUserTableQuery = "CREATE TABLE $FOLX_TABLE ("
      "$USER_ID TEXT PRIMARY KEY, "
      "$PHONE_NUMBER TEXT, "
      "$EMAIL TEXT, "
      "$USERNAME TEXT, "
      "$USER_GENDER TEXT, "
      "$USER_AGE INTEGER, "
      "$USER_IMAGE_URLS TEXT, "
      "$USER_COVER_IMAGE_URL TEXT, "
      "$USER_PROFESSION TEXT, "
      "$USER_COMPANY TEXT, "
      "$USER_EDUCATION TEXT, "
      "$USER_PREF_REST TEXT, "
      "$USER_PREF_AGE_LOWER_LIMIT REAL, "
      "$USER_PREF_AGE_UPPER_LIMIT REAL, "
      "$USER_PREF_DISTANCE REAL, "
      "$USER_PREF_GENDER INTEGER, "
      "$SHARE_LAST_SEEN INTEGER "
      ")";

  String prefTableQuery = "CREATE TABLE $PREF_TABLE ("
      "$PREF_NAME TEXT PRIMARY KEY, "
      "$PREF_VALUE TEXT "
      ")";

  String usersDisplayedQuery = "CREATE TABLE $VIEW_TABLE ("
      "$USER_ID TEXT PRIMARY KEY, "
      "$VIEWED_ACTON INTEGER "
      ")";
}

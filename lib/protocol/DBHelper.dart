
import 'package:giphy_flutter/model/GifObject.dart';
import 'package:giphy_flutter/model/Image.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

enum DbAction {
  GetAllFavoutires,
  GetAllFavouritesIds,
  AddToFavourites,
  RemoveFromFavourites
}

class DBHelper {

  static const String dbName = 'localDB';
  static const String favouriteTable = 'FavouriteGifs';

  static DBHelper _instance;

  Database _database;

  DBHelper._internal();

  static Future<DBHelper> get() async {
    if(_instance == null) {
      _instance = DBHelper._internal();
      await _instance._initDB();
    }
    return _instance;
  }

  _initDB() async {
    // open the database
    var databasesPath = await getDatabasesPath();
    final path = join(databasesPath, '$dbName.db');

    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE $favouriteTable (id TEXT PRIMARY KEY, type TEXT, url TEXT, width TEXT, height TEXT)');
        });
  }

  Future<List<GifObject>> getAllGifs() {
    return _database.rawQuery('SELECT * FROM $favouriteTable').then((rows) {

      return rows.map((m) => GifObject(m['id'], m['type'], '',
          Images(null, Image(m['url'], m['width'], m['height'])))).toList();

    });
  }

  Future<List<String>> getAllFavouriteGifsIds() {
    return _database.rawQuery('SELECT id FROM $favouriteTable').then((list) {
      return list.map((map) {
        return map.values?.first as String;
      }).toList();
    });
  }

  Future<int> addToFavourites(GifObject gif) {
    if(gif != null) {
      
      return _database.rawInsert('INSERT OR REPLACE INTO $favouriteTable VALUES(?, ?, ?, ?, ?)', [
        gif.id,
        gif.type,
        gif.images.fixedWidth.url ?? '',
        gif.images.fixedWidth.width ?? '0',
        gif.images.fixedWidth.height ?? '0'
      ]);
      
    } else {
      return Future.value(0);
    }
  }

  Future<int> removeFromFavourites(String gifId) {
    return _database.rawDelete('DELETE FROM $favouriteTable WHERE id = ?', [gifId]);
  }
}
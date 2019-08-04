

import 'package:giphy_flutter/model/GifObject.dart';
import 'package:giphy_flutter/protocol/DBHelper.dart';

import 'IDataLoader.dart';

class DBLoader implements IDataLoader {

  @override
  Future<PagedData<GifObject>> getGifs(int page, int perPage, String query) {
    return DBHelper.get().then((db) {
      return db.getAllGifs().then((list) {

        return PagedData(0, list.length, list);
      });
    });
  }
}
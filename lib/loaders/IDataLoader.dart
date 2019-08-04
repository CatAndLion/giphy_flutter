
import 'dart:collection';

import 'package:giphy_flutter/model/GifObject.dart';

class PagedData<T> {
  final int page;
  final int total;
  final UnmodifiableListView<T> data;

  PagedData(this.page, this.total, Iterable<T> data) :
        this.data = data != null ? UnmodifiableListView(data) : null;
}

class IDataLoader {

  Future<PagedData<GifObject>> getGifs(int page, int perPage, String query) {
    return Future.value(PagedData(0, 0, []));
  }
}
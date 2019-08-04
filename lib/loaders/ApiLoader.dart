
import 'package:giphy_flutter/model/GifObject.dart';
import 'package:giphy_flutter/protocol/Giphy.dart';
import 'package:giphy_flutter/protocol/Responses.dart';

import 'IDataLoader.dart';


class ApiLoader implements IDataLoader {

  @override
  Future<PagedData<GifObject>> getGifs(int page, int perPage, String query) {

    Future<GifListResponse> response = (query?.isEmpty ?? true) ?
      Giphy.api.getTrendingGifs(perPage, page * perPage) :
      Giphy.api.searchGifs(query, perPage, page * perPage);

    return response.then((r) => PagedData(page, r.pagination.total, r.data));
  }
  
}
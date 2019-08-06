import 'package:async/async.dart';
import 'package:giphy_flutter/bloc/BaseListBloc.dart';
import 'package:giphy_flutter/bloc/ListEvent.dart';
import 'package:giphy_flutter/bloc/ListState.dart';
import 'package:giphy_flutter/loaders/IDataLoader.dart';
import 'package:giphy_flutter/model/GifObject.dart';
import 'package:giphy_flutter/protocol/DBHelper.dart';
import 'package:giphy_flutter/util/Pair.dart';
import 'package:rxdart/rxdart.dart';

enum DBResponseType {
  List, Added, Removed
}

class GifListBloc extends BaseListBloc<GifObject> {

  final IDataLoader provider;

  List<String> ids;

  final _idsController = PublishSubject<Pair<DBResponseType, List<String>>>();
  final _itemController = PublishSubject<Pair<DBResponseType, String>>();

  Stream<dynamic> get countStream => StreamGroup.merge([idsStream, itemStream]).map((_) => ids.length);

  Stream<Pair<DBResponseType, List<String>>> get idsStream => _idsController.doOnData((data) {
    switch(data.left) {
      case DBResponseType.List: {
        ids = data.right ?? [];
        break;
      }
      default: break;
    }
  });

  Stream<Pair<DBResponseType, String>> get itemStream => _itemController.doOnData((data) {
    switch(data.left) {
      case DBResponseType.Added:
        if(!ids.contains(data.right)) {
          ids.add(data.right);
        }
        break;
      case DBResponseType.Removed:
        ids.remove(data.right);
        break;
      default: break;
    }
  });

  GifListBloc(this.provider) {
    updateIds();
  }

  @override
  Future<PagedData<GifObject>> loadData(ListEvent event) {
    return provider.getGifs(event.page, event.perPage, event.query);
  }

  @override
  ListState<GifObject> get initialState => ListState.empty();

  String get prefix => this.runtimeType.toString();

  bool isFavourite(String id) {
    return ids?.contains(id) ?? false;
  }

  void addToFavourites(GifObject gif) {
    final id = gif.id;
    _itemController.sink.addStream(DBHelper.get().then((db) => db.addToFavourites(gif)).asStream()
        .map((res) {
          return Pair(DBResponseType.Added, id);
        }));
  }

  void removeFromFavourites(final String id) {
    _itemController.sink.addStream(DBHelper.get().then((db) => db.removeFromFavourites(id)).asStream()
        .map((res) {
          return Pair(DBResponseType.Removed, id);
        }));
  }

  void updateIds() {
    _idsController.sink.addStream(DBHelper.get().then((db) => db.getAllFavouriteGifsIds()).asStream()
        .map((list) {
          return Pair(DBResponseType.List, list);
        }));
  }

  @override
  void dispose() {
    _idsController.close();
    _itemController.close();
    super.dispose();
  }
}
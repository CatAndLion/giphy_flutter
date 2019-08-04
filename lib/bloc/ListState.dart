
import 'package:giphy_flutter/bloc/ListEvent.dart';
import 'package:giphy_flutter/loaders/IDataLoader.dart';

class ListState<T> extends PagedData<T> {

  final bool isLoading;
  final String query;

  ListState._internal(this.isLoading, this.query, int page, int total, Iterable<T> data) : super(page, total, data);

  ListState.empty() : this._internal(false, "", 0, 0, null);

  ListState<T> loading(String query, int page) {
    final first = page == 1;
    return ListState._internal(true, query, page, !first ? total : 0, !first ? data : null);
  }

  ListState<T> complete({ Iterable<T> data, int total }) {
    var list = this.data != null ? List.of(this.data) : null;
    if(data != null) {
      if (list == null) {
        list = List.of(data);
      } else {
        list.addAll(data);
      }
    }
    return ListState._internal(false, query, page, total ?? this.total, list);
  }

  bool contains(ListEvent event) {
    return event == null || (event.page == page && event.page > 0 &&
        event.query == query);
  }

  bool get isEmpty => data == null && total == 0;
  int get size => data?.length ?? 0;
}
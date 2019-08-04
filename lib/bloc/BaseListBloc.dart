import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:giphy_flutter/bloc/ListEvent.dart';
import 'package:giphy_flutter/bloc/ListState.dart';
import 'package:giphy_flutter/loaders/IDataLoader.dart';
import 'package:giphy_flutter/util/Pair.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/transformers.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';
import 'package:http/http.dart' as http;

enum ErrorType {
  Data, Server, Connection
}

abstract class BaseListBloc<D> extends Bloc<ListEvent, ListState<D>> {

  Future<PagedData<D>> loadData(ListEvent event);
  ListState<D> get initialState;
  String get prefix;

  final _exceptionStream = PublishSubject<Exception>();
  final _errorStream = PublishSubject<Pair<ErrorType, String>>();
  Pair<ErrorType, String> _currentError;

  int get nextPage => currentState.page + 1;

  bool get canLoad => currentState.size < currentState.total;

  bool get hasData => !currentState.isEmpty && currentState.size > 0;

  bool get isLoading => currentState.isLoading;

  ErrorType get currentError => _currentError?.left;
  String get currentErrorText => _currentError?.right;

  BaseListBloc() {

    _exceptionStream.forEach((exception) {
      print('Exception: ${exception.runtimeType.toString()}');

      if(exception is http.ClientException) {
        _currentError = Pair(ErrorType.Server, 'Server error');

      } else if(exception is SocketException) {
        _currentError = Pair(ErrorType.Connection, 'Connection error');

      } else {
        _currentError = Pair(ErrorType.Data, 'Data error: ${exception.runtimeType.toString()}');
      }

      _errorStream.add(_currentError);
    });
  }

  @override
  Stream<ListState<D>> transform(Stream<ListEvent> events,
      Stream<ListState<D>> next(ListEvent event)) {

    var transformed = events
        .transform(DebounceStreamTransformer((event) {
          //pause if event with search query
          bool searchEvent = event.query != currentState.query;
          return TimerStream(event, Duration(milliseconds: searchEvent ? 1000 : 0));
        }))
        .where((event) {
          //filter events
          return event != null && (!currentState.contains(event) || currentError != null);
        })
        .distinct((prev, next) {
          //remove equal event
          return currentError == null && prev.page == next.page && prev.query == next.query;
        });

    return super.transform(transformed, next);
  }

  @override
  Stream<ListState<D>> mapEventToState(ListEvent event) async* {

    _currentError = null;

    print('<$prefix> loading page = ${event.page}');
    yield currentState.loading(event.query, event.page);

    try {
      PagedData<D> results = await loadData(event);

      print('<$prefix> loaded page = ${event.page} length = ${results.data.length}');
      yield currentState.complete(data: results.data, total: results.total);

    } catch (exception) {
      onError(exception, null);
      yield currentState.complete();
    }
  }

  void addErrorListener(Function(Pair<ErrorType, String>) listener) {
    _errorStream.listen(listener);
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    if(error is Exception) {
      _exceptionStream.add(error);
    }
  }

  @override
  void dispose() {
    _exceptionStream.close();
    _errorStream.close();
    super.dispose();
  }
}
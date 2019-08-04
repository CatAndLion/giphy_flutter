
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Responses.dart';
import 'BaseRequest.dart';
import 'Requests.dart';

typedef T JsonBuilder<T>(dynamic json);

class Giphy {

  static Giphy _api;
  static Giphy get api => Giphy();

  static const String apiKey = 'Djkyz5ftgpIQjoTGb9K4aOoYgP0NyLu9';
  static const String url = 'https://api.giphy.com/v1/gifs';

  factory Giphy() {
    return _api ?? Giphy._internal();
  }

  Giphy._internal() {
    _api = this;
  }

  Future<http.Response> _getHttpResponse(BaseRequest request) {
    String s = '$url/${request.mode}?apikey=$apiKey${request.prefix}';
    return http.get(s);
  }

  Future<GifListResponse> getTrendingGifs(int limit, int offset) async {

    http.Response response = await _getHttpResponse(GifTrendingRequest(limit, offset));

    if(response.statusCode == 200) {

      return GifListResponse.fromJson(jsonDecode(response.body));

    } else {

      throw http.ClientException('Request error');
    }
  }

  Future<GifListResponse> searchGifs(String query, int limit, int offset) async {

    http.Response response = await _getHttpResponse(GifSearchRequest(limit, offset, query));
    if(response.statusCode == 200) {

      return GifListResponse.fromJson(jsonDecode(response.body));

    } else {

      throw http.ClientException('Request error');
    }
  }
}
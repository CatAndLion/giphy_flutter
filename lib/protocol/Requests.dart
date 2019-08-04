
import 'BaseRequest.dart';

class GifTrendingRequest extends BaseRequest {

  final int limit;
  final int offset;
  final String rating = 'PG';

  GifTrendingRequest(this.limit, this.offset);

  @override
  get mode => 'trending';

  @override
  get prefix => '&limit=${limit > 0 ? limit : 0}&offset=${offset >= 0 ? offset : 0}&rating=$rating';
}

class GifSearchRequest extends BaseRequest {

  final int limit;
  final int offset;
  final String query;
  final String rating = 'PG';

  GifSearchRequest(this.limit, this.offset, this.query);

  @override
  get mode => 'search';

  @override
  get prefix => '&limit=${limit > 0 ? limit : 0}&offset=${offset >= 0 ? offset : 0}&rating=$rating&q=$query';

}
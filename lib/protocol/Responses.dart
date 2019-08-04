import 'package:json_annotation/json_annotation.dart';
import 'package:giphy_flutter/model/GifObject.dart';
import 'package:giphy_flutter/model/PageObject.dart';

part 'Responses.g.dart';

@JsonSerializable(createToJson: false)
class GifListResponse {

  final PageObject pagination;
  final List<GifObject> data;

  GifListResponse(this.pagination, this.data);

  factory GifListResponse.fromJson(Map<String, dynamic> json) => _$GifListResponseFromJson(json);
}
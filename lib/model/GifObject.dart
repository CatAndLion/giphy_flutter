
import 'package:json_annotation/json_annotation.dart';
import 'package:giphy_flutter/model/Image.dart';


part 'GifObject.g.dart';

@JsonSerializable(createToJson: false)
class GifObject {
  String id;
  String type;
  @JsonKey(name: 'embed_url')
  String embedUrl;
  Images images;

  GifObject(this.id, this.type, this.embedUrl, this.images);

  factory GifObject.fromJson(Map<String, dynamic> json) => _$GifObjectFromJson(json);
}
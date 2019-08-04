import 'package:json_annotation/json_annotation.dart';

part 'Image.g.dart';

@JsonSerializable(createToJson: false)
class Images {
  final Image original;
  @JsonKey(name: 'fixed_width')
  final Image fixedWidth;

  Images(this.original, this.fixedWidth);

  factory Images.fromJson(Map<String, dynamic> json) => _$ImagesFromJson(json);
}

@JsonSerializable(createToJson: false)
class Image {
  final String url;
  final String width;
  final String height;

  Image(this.url, this.width, this.height);

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
}
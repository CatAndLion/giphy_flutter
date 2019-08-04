// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Images _$ImagesFromJson(Map<String, dynamic> json) {
  return Images(
    json['original'] == null
        ? null
        : Image.fromJson(json['original'] as Map<String, dynamic>),
    json['fixed_width'] == null
        ? null
        : Image.fromJson(json['fixed_width'] as Map<String, dynamic>),
  );
}

Image _$ImageFromJson(Map<String, dynamic> json) {
  return Image(
    json['url'] as String,
    json['width'] as String,
    json['height'] as String,
  );
}

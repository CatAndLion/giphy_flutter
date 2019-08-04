// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GifObject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GifObject _$GifObjectFromJson(Map<String, dynamic> json) {
  return GifObject(
    json['id'] as String,
    json['type'] as String,
    json['embed_url'] as String,
    json['images'] == null
        ? null
        : Images.fromJson(json['images'] as Map<String, dynamic>),
  );
}

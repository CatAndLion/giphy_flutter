// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GifListResponse _$GifListResponseFromJson(Map<String, dynamic> json) {
  return GifListResponse(
    json['pagination'] == null
        ? null
        : PageObject.fromJson(json['pagination'] as Map<String, dynamic>),
    (json['data'] as List)
        ?.map((e) =>
            e == null ? null : GifObject.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

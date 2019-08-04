import 'package:json_annotation/json_annotation.dart';

part 'PageObject.g.dart';

@JsonSerializable(createToJson: false)
class PageObject {
  int offset;
  @JsonKey(name: 'total_count')
  int total;
  int count;

  PageObject(this.offset, this.total, this.count);

  factory PageObject.fromJson(Map<String, dynamic> json) => _$PageObjectFromJson(json);
}
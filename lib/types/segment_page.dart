import 'package:json_annotation/json_annotation.dart';

import 'modification.dart';

part 'segment_page.g.dart';

@JsonSerializable()
class SegmentPage {
  int? id;
  String? name;
  int? segmentCount;
  Modification? created;
  Modification? updated;

  SegmentPage({
    this.id,
    this.name,
    this.segmentCount,
    this.created,
    this.updated,
  });

  factory SegmentPage.fromJson(Map<String, dynamic> json) => _$SegmentPageFromJson(json);

  Map<String, dynamic> toJson() => _$SegmentPageToJson(this);
}

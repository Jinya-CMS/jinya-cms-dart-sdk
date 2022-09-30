import 'package:json_annotation/json_annotation.dart';

import 'file.dart';
import 'gallery.dart';

part 'segment.g.dart';

enum SegmentType {
  file,
  gallery,
  html
}

@JsonSerializable()
class Segment {
  int? position;
  int? id;
  Gallery? gallery;
  File? file;
  String? target;
  String? html;
  String? action;

  Segment({
    this.position,
    this.id,
    this.gallery,
    this.file,
    this.target,
    this.html,
    this.action,
  });

  factory Segment.fromJson(Map<String, dynamic> json) => _$SegmentFromJson(json);

  Map<String, dynamic> toJson() => _$SegmentToJson(this);
}

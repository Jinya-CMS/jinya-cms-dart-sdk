import 'package:json_annotation/json_annotation.dart';

import 'modification.dart';

part 'gallery.g.dart';

@JsonEnum()
enum Orientation {
  @JsonValue('horizontal')
  horizontal,
  @JsonValue('vertical')
  vertical,
}

@JsonEnum()
enum Type {
  @JsonValue('sequence')
  sequence,
  @JsonValue('masonry')
  masonry,
}

@JsonSerializable()
class Gallery {
  int? id;
  String? name;
  String? description;
  Orientation? orientation;
  Type? type;
  Modification? updated;
  Modification? created;

  Gallery({
    this.id,
    this.name,
    this.description,
    this.orientation,
    this.type,
  });

  factory Gallery.fromJson(Map<String, dynamic> json) => _$GalleryFromJson(json);

  Map<String, dynamic> toJson() => _$GalleryToJson(this);
}

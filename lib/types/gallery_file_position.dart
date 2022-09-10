import 'package:jinya_cms/types/file.dart';
import 'package:jinya_cms/types/gallery.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gallery_file_position.g.dart';

@JsonSerializable()
class GalleryFilePosition {
  Gallery? gallery;
  File? file;
  int? id;
  int? position;

  GalleryFilePosition({
    this.gallery,
    this.file,
    this.id,
    this.position,
  });

  factory GalleryFilePosition.fromJson(Map<String, dynamic> json) => _$GalleryFilePositionFromJson(json);

  Map<String, dynamic> toJson() => _$GalleryFilePositionToJson(this);
}

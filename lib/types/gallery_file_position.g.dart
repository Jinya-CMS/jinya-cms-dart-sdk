// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_file_position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GalleryFilePosition _$GalleryFilePositionFromJson(Map<String, dynamic> json) =>
    GalleryFilePosition(
      gallery: json['gallery'] == null
          ? null
          : Gallery.fromJson(json['gallery'] as Map<String, dynamic>),
      file: json['file'] == null
          ? null
          : File.fromJson(json['file'] as Map<String, dynamic>),
      id: json['id'] as int?,
      position: json['position'] as int?,
    );

Map<String, dynamic> _$GalleryFilePositionToJson(
        GalleryFilePosition instance) =>
    <String, dynamic>{
      'gallery': instance.gallery,
      'file': instance.file,
      'id': instance.id,
      'position': instance.position,
    };

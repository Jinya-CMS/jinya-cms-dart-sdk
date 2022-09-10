// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'segment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Segment _$SegmentFromJson(Map<String, dynamic> json) => Segment(
      position: json['position'] as int?,
      id: json['id'] as int?,
      gallery: json['gallery'] == null
          ? null
          : Gallery.fromJson(json['gallery'] as Map<String, dynamic>),
      file: json['file'] == null
          ? null
          : File.fromJson(json['file'] as Map<String, dynamic>),
      target: json['target'] as String?,
      html: json['html'] as String?,
      action: json['action'] as String?,
    );

Map<String, dynamic> _$SegmentToJson(Segment instance) => <String, dynamic>{
      'position': instance.position,
      'id': instance.id,
      'gallery': instance.gallery,
      'file': instance.file,
      'target': instance.target,
      'html': instance.html,
      'action': instance.action,
    };

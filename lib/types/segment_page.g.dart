// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'segment_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SegmentPage _$SegmentPageFromJson(Map<String, dynamic> json) => SegmentPage(
      id: json['id'] as int?,
      name: json['name'] as String?,
      segmentCount: json['segmentCount'] as int?,
      created: json['created'] == null
          ? null
          : Modification.fromJson(json['created'] as Map<String, dynamic>),
      updated: json['updated'] == null
          ? null
          : Modification.fromJson(json['updated'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SegmentPageToJson(SegmentPage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'segmentCount': instance.segmentCount,
      'created': instance.created,
      'updated': instance.updated,
    };

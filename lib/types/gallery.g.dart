// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gallery _$GalleryFromJson(Map<String, dynamic> json) => Gallery(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      orientation:
          $enumDecodeNullable(_$OrientationEnumMap, json['orientation']),
      type: $enumDecodeNullable(_$TypeEnumMap, json['type']),
    )
      ..updated = json['updated'] == null
          ? null
          : Modification.fromJson(json['updated'] as Map<String, dynamic>)
      ..created = json['created'] == null
          ? null
          : Modification.fromJson(json['created'] as Map<String, dynamic>);

Map<String, dynamic> _$GalleryToJson(Gallery instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'orientation': _$OrientationEnumMap[instance.orientation],
      'type': _$TypeEnumMap[instance.type],
      'updated': instance.updated,
      'created': instance.created,
    };

const _$OrientationEnumMap = {
  Orientation.horizontal: 'horizontal',
  Orientation.vertical: 'vertical',
};

const _$TypeEnumMap = {
  Type.sequence: 'sequence',
  Type.masonry: 'masonry',
};

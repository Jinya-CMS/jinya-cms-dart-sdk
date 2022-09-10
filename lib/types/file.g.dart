// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

File _$FileFromJson(Map<String, dynamic> json) => File(
      id: json['id'] as int?,
      name: json['name'] as String?,
      path: json['path'] as String?,
      type: json['type'] as String?,
    )
      ..updated = json['updated'] == null
          ? null
          : Modification.fromJson(json['updated'] as Map<String, dynamic>)
      ..created = json['created'] == null
          ? null
          : Modification.fromJson(json['created'] as Map<String, dynamic>);

Map<String, dynamic> _$FileToJson(File instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'path': instance.path,
      'type': instance.type,
      'updated': instance.updated,
      'created': instance.created,
    };

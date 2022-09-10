// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimplePage _$SimplePageFromJson(Map<String, dynamic> json) => SimplePage(
      id: json['id'] as int?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      created: json['created'] == null
          ? null
          : Modification.fromJson(json['created'] as Map<String, dynamic>),
      updated: json['updated'] == null
          ? null
          : Modification.fromJson(json['updated'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SimplePageToJson(SimplePage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'created': instance.created,
      'updated': instance.updated,
    };

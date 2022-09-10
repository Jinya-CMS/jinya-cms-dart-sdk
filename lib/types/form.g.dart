// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Form _$FormFromJson(Map<String, dynamic> json) => Form(
      id: json['id'] as int?,
      description: json['description'] as String?,
      title: json['title'] as String?,
      toAddress: json['toAddress'] as String?,
      created: json['created'] == null
          ? null
          : Modification.fromJson(json['created'] as Map<String, dynamic>),
      updated: json['updated'] == null
          ? null
          : Modification.fromJson(json['updated'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FormToJson(Form instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'title': instance.title,
      'toAddress': instance.toAddress,
      'created': instance.created,
      'updated': instance.updated,
    };

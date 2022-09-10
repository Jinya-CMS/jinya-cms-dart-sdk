// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Menu _$MenuFromJson(Map<String, dynamic> json) => Menu(
      name: json['name'] as String?,
      id: json['id'] as int?,
      logo: json['logo'] == null
          ? null
          : File.fromJson(json['logo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MenuToJson(Menu instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'logo': instance.logo,
    };

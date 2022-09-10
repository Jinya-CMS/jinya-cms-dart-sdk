// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_key.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiKey _$ApiKeyFromJson(Map<String, dynamic> json) => ApiKey(
      key: json['key'] as String?,
      remoteAddress: json['remoteAddress'] as String?,
      validSince: json['validSince'] == null
          ? null
          : DateTime.parse(json['validSince'] as String),
      userAgent: json['userAgent'] as String?,
    );

Map<String, dynamic> _$ApiKeyToJson(ApiKey instance) => <String, dynamic>{
      'key': instance.key,
      'remoteAddress': instance.remoteAddress,
      'validSince': instance.validSince?.toIso8601String(),
      'userAgent': instance.userAgent,
    };

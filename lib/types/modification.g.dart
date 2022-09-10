// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModifiedBy _$ModifiedByFromJson(Map<String, dynamic> json) => ModifiedBy(
      artistName: json['artistName'] as String?,
      email: json['email'] as String?,
      profilePicture: json['profilePicture'] as String?,
    );

Map<String, dynamic> _$ModifiedByToJson(ModifiedBy instance) =>
    <String, dynamic>{
      'artistName': instance.artistName,
      'email': instance.email,
      'profilePicture': instance.profilePicture,
    };

Modification _$ModificationFromJson(Map<String, dynamic> json) => Modification(
      by: json['by'] == null
          ? null
          : ModifiedBy.fromJson(json['by'] as Map<String, dynamic>),
      at: json['at'] == null ? null : DateTime.parse(json['at'] as String),
    );

Map<String, dynamic> _$ModificationToJson(Modification instance) =>
    <String, dynamic>{
      'by': instance.by,
      'at': instance.at?.toIso8601String(),
    };

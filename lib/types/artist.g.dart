// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Artist _$ArtistFromJson(Map<String, dynamic> json) => Artist(
      id: json['id'] as int?,
      artistName: json['artistName'] as String?,
      email: json['email'] as String?,
      profilePicture: json['profilePicture'] as String?,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
      enabled: json['enabled'] as bool?,
    )
      ..aboutMe = json['aboutMe'] as String?
      ..colorScheme =
          $enumDecodeNullable(_$ColorSchemeEnumMap, json['colorScheme']);

Map<String, dynamic> _$ArtistToJson(Artist instance) => <String, dynamic>{
      'id': instance.id,
      'artistName': instance.artistName,
      'email': instance.email,
      'profilePicture': instance.profilePicture,
      'aboutMe': instance.aboutMe,
      'roles': instance.roles,
      'colorScheme': _$ColorSchemeEnumMap[instance.colorScheme],
      'enabled': instance.enabled,
    };

const _$ColorSchemeEnumMap = {
  ColorScheme.dark: 'dark',
  ColorScheme.light: 'light',
  ColorScheme.auto: 'auto',
};

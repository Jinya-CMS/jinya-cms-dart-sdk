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
    );

Map<String, dynamic> _$ArtistToJson(Artist instance) => <String, dynamic>{
      'id': instance.id,
      'artistName': instance.artistName,
      'email': instance.email,
      'profilePicture': instance.profilePicture,
      'roles': instance.roles,
    };

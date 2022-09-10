// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginData _$LoginDataFromJson(Map<String, dynamic> json) => LoginData(
      apiKey: json['apiKey'] as String?,
      deviceCode: json['deviceCode'] as String?,
      roles: (json['roles'] as List<dynamic>?)?.map((e) => e as String),
    );

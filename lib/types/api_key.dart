import 'package:json_annotation/json_annotation.dart';

part 'api_key.g.dart';

@JsonSerializable()
class ApiKey {
  ApiKey({
    this.key,
    this.remoteAddress,
    this.validSince,
    this.userAgent,
  });

  String? key;
  String? remoteAddress;
  DateTime? validSince;
  String? userAgent;

  factory ApiKey.fromJson(Map<String, dynamic> json) => _$ApiKeyFromJson(json);

  Map<String, dynamic> toJson() => _$ApiKeyToJson(this);
}

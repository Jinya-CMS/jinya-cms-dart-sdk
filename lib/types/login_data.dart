import 'package:json_annotation/json_annotation.dart';

part 'login_data.g.dart';

@JsonSerializable(createToJson: false)
class LoginData {
  String? apiKey;
  String? deviceCode;
  Iterable<String>? roles;

  LoginData({
    this.apiKey,
    this.deviceCode,
    this.roles,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => _$LoginDataFromJson(json);
}

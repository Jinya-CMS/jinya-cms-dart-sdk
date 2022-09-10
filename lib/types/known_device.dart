import 'package:json_annotation/json_annotation.dart';

part 'known_device.g.dart';

@JsonSerializable(createToJson: false)
class KnownDevice {
  String? remoteAddress;
  String? userAgent;
  String? key;

  KnownDevice({
    this.key,
    this.remoteAddress,
    this.userAgent,
  });

  factory KnownDevice.fromJson(Map<String, dynamic> json) => _$KnownDeviceFromJson(json);
}

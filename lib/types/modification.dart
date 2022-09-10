import 'package:json_annotation/json_annotation.dart';

part 'modification.g.dart';

@JsonSerializable()
class ModifiedBy {
  ModifiedBy({
    this.artistName,
    this.email,
    this.profilePicture,
  });

  String? artistName;
  String? email;
  String? profilePicture;

  factory ModifiedBy.fromJson(Map<String, dynamic> json) => _$ModifiedByFromJson(json);
}

@JsonSerializable()
class Modification {
  Modification({
    this.by,
    this.at,
  });

  ModifiedBy? by;
  DateTime? at;

  factory Modification.fromJson(Map<String, dynamic> json) => _$ModificationFromJson(json);
}

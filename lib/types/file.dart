import 'package:jinya_cms_api/types/modification.dart';
import 'package:json_annotation/json_annotation.dart';

part 'file.g.dart';

@JsonSerializable()
class File {
  int? id;
  String? name;
  String? path;
  String? type;
  Modification? updated;
  Modification? created;

  File({
    this.id,
    this.name,
    this.path,
    this.type,
  });

  factory File.fromJson(Map<String, dynamic> json) => _$FileFromJson(json);

  Map<String, dynamic> toJson() => _$FileToJson(this);
}
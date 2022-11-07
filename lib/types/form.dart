import 'package:jinya_cms_api/types/modification.dart';
import 'package:json_annotation/json_annotation.dart';

part 'form.g.dart';

@JsonSerializable()
class Form {
  int? id;
  String? description;
  String? title;
  String? toAddress;
  Modification? created;
  Modification? updated;

  Form({
    this.id,
    this.description,
    this.title,
    this.toAddress,
    this.created,
    this.updated,
  });

  factory Form.fromJson(Map<String, dynamic> json) => _$FormFromJson(json);

  Map<String, dynamic> toJson() => _$FormToJson(this);
}

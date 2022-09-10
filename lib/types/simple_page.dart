import 'package:json_annotation/json_annotation.dart';

import 'modification.dart';

part 'simple_page.g.dart';

@JsonSerializable()
class SimplePage {
  int? id;
  String? title;
  String? content;
  Modification? created;
  Modification? updated;

  SimplePage({
    this.id,
    this.title,
    this.content,
    this.created,
    this.updated,
  });

  factory SimplePage.fromJson(Map<String, dynamic> json) => _$SimplePageFromJson(json);

  Map<String, dynamic> toJson() => _$SimplePageToJson(this);
}

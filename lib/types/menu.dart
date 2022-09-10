import 'package:json_annotation/json_annotation.dart';

import 'file.dart';

part 'menu.g.dart';

@JsonSerializable()
class Menu {
  String? name;
  int? id;
  File? logo;

  Menu({
    this.name,
    this.id,
    this.logo,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);
}

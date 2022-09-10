import 'package:json_annotation/json_annotation.dart';

part 'form_item.g.dart';

@JsonSerializable()
class FormItem {
  String? type;
  Iterable<String>? options;
  Iterable<String>? spamFilter;
  String? label;
  String? placeholder;
  String? helpText;
  int? position;
  int? id;
  bool? isRequired;
  bool? isFromAddress;
  bool? isSubject;

  FormItem({
    this.type,
    this.options,
    this.spamFilter,
    this.label,
    this.placeholder,
    this.helpText,
    this.position,
    this.id,
    this.isRequired,
    this.isFromAddress,
    this.isSubject,
  });

  factory FormItem.fromJson(Map<String, dynamic> json) => _$FormItemFromJson(json);

  Map<String, dynamic> toJson() => _$FormItemToJson(this);
}

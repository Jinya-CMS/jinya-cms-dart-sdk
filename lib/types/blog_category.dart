import 'package:json_annotation/json_annotation.dart';

part 'blog_category.g.dart';

@JsonSerializable()
class BlogCategory {
  int? id;
  String? name;
  String? description;
  BlogCategory? parent;
  bool? webhookEnabled;
  String? webhookUrl;

  BlogCategory({
    this.id,
    this.name,
    this.description,
    this.parent,
    this.webhookEnabled,
    this.webhookUrl,
  });

  factory BlogCategory.fromJson(Map<String, dynamic> json) => _$BlogCategoryFromJson(json);

  Map<String, dynamic> toJson() {
    final data = _$BlogCategoryToJson(this);
    data['parentId'] = parent?.id;
    data.remove('parent');

    return data;
  }
}

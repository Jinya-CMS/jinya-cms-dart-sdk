// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogCategory _$BlogCategoryFromJson(Map<String, dynamic> json) => BlogCategory(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      parent: json['parent'] == null
          ? null
          : BlogCategory.fromJson(json['parent'] as Map<String, dynamic>),
      webhookEnabled: json['webhookEnabled'] as bool?,
      webhookUrl: json['webhookUrl'] as String?,
    );

Map<String, dynamic> _$BlogCategoryToJson(BlogCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'parent': instance.parent,
      'webhookEnabled': instance.webhookEnabled,
      'webhookUrl': instance.webhookUrl,
    };

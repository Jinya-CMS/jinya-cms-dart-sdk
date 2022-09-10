// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogPost _$BlogPostFromJson(Map<String, dynamic> json) => BlogPost(
      id: json['id'] as int?,
      title: json['title'] as String?,
      slug: json['slug'] as String?,
      headerImage: json['headerImage'] == null
          ? null
          : File.fromJson(json['headerImage'] as Map<String, dynamic>),
      category: json['category'] == null
          ? null
          : BlogCategory.fromJson(json['category'] as Map<String, dynamic>),
      public: json['public'] as bool?,
      created: json['created'] == null
          ? null
          : Modification.fromJson(json['created'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BlogPostToJson(BlogPost instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'headerImage': instance.headerImage,
      'category': instance.category,
      'public': instance.public,
      'created': instance.created,
    };

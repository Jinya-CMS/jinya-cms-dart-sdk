// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_post_segment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogPostSegment _$BlogPostSegmentFromJson(Map<String, dynamic> json) =>
    BlogPostSegment(
      position: json['position'] as int?,
      id: json['id'] as int?,
      gallery: json['gallery'] == null
          ? null
          : Gallery.fromJson(json['gallery'] as Map<String, dynamic>),
      link: json['link'] as String?,
      html: json['html'] as String?,
      file: json['file'] == null
          ? null
          : File.fromJson(json['file'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BlogPostSegmentToJson(BlogPostSegment instance) =>
    <String, dynamic>{
      'position': instance.position,
      'id': instance.id,
      'gallery': instance.gallery,
      'link': instance.link,
      'html': instance.html,
      'file': instance.file,
    };

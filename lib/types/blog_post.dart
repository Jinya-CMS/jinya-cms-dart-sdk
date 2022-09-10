import 'package:jinya_cms/types/blog_category.dart';
import 'package:jinya_cms/types/modification.dart';
import 'package:json_annotation/json_annotation.dart';

import 'file.dart';

part 'blog_post.g.dart';

@JsonSerializable()
class BlogPost {
  BlogPost({
    this.id,
    this.title,
    this.slug,
    this.headerImage,
    this.category,
    this.public,
    this.created,
  });

  int? id;
  String? title;
  String? slug;
  File? headerImage;
  BlogCategory? category;
  bool? public;
  Modification? created;

  factory BlogPost.fromJson(Map<String, dynamic> json) => _$BlogPostFromJson(json);

  Map<String, dynamic> toJson() => _$BlogPostToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

import 'file.dart';
import 'gallery.dart';

part 'blog_post_segment.g.dart';

@JsonSerializable()
class BlogPostSegment {
  int? position;
  int? id;
  Gallery? gallery;
  String? link;
  String? html;
  File? file;

  BlogPostSegment({
    this.position,
    this.id,
    this.gallery,
    this.link,
    this.html,
    this.file,
  });

  factory BlogPostSegment.fromJson(Map<String, dynamic> json) => _$BlogPostSegmentFromJson(json);

  Map<String, dynamic> toJson() => _$BlogPostSegmentToJson(this);
}

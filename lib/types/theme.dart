import 'package:json_annotation/json_annotation.dart';

import 'blog_category.dart';
import 'file.dart';
import 'form.dart';
import 'gallery.dart';
import 'menu.dart';
import 'segment_page.dart';
import 'simple_page.dart';

part 'theme.g.dart';

@JsonSerializable(createToJson: false)
class Theme {
  Map<String, Map<String, dynamic>>? configuration;
  Map<String, String>? scssVariables;
  String? name;
  String? displayName;
  Map<String, String>? description;
  int? id;

  Theme({
    this.configuration,
    this.scssVariables,
    this.name,
    this.displayName,
    this.description,
    this.id,
  });

  factory Theme.fromJson(Map<String, dynamic> json) => _$ThemeFromJson(json);
}

@JsonSerializable(createToJson: false)
class ThemeBlogCategory {
  String? name;
  BlogCategory? blogCategory;

  ThemeBlogCategory({this.name, this.blogCategory});

  factory ThemeBlogCategory.fromJson(Map<String, dynamic> json) => _$ThemeBlogCategoryFromJson(json);
}

@JsonSerializable(createToJson: false)
class ThemeFile {
  String? name;
  File? file;

  ThemeFile({this.name, this.file});

  factory ThemeFile.fromJson(Map<String, dynamic> json) => _$ThemeFileFromJson(json);
}

@JsonSerializable(createToJson: false)
class ThemeForm {
  String? name;
  Form? form;

  ThemeForm({this.name, this.form});

  factory ThemeForm.fromJson(Map<String, dynamic> json) => _$ThemeFormFromJson(json);
}

@JsonSerializable(createToJson: false)
class ThemeGallery {
  String? name;
  Gallery? gallery;

  ThemeGallery({this.name, this.gallery});

  factory ThemeGallery.fromJson(Map<String, dynamic> json) => _$ThemeGalleryFromJson(json);
}

@JsonSerializable(createToJson: false)
class ThemeMenu {
  String? name;
  Menu? menu;

  ThemeMenu({this.name, this.menu});

  factory ThemeMenu.fromJson(Map<String, dynamic> json) => _$ThemeMenuFromJson(json);
}

@JsonSerializable(createToJson: false)
class ThemePage {
  String? name;
  SimplePage? page;

  ThemePage({this.name, this.page});

  factory ThemePage.fromJson(Map<String, dynamic> json) => _$ThemePageFromJson(json);
}

@JsonSerializable(createToJson: false)
class ThemeSegmentPage {
  String? name;
  SegmentPage? segmentPage;

  ThemeSegmentPage({this.name, this.segmentPage});

  factory ThemeSegmentPage.fromJson(Map<String, dynamic> json) => _$ThemeSegmentPageFromJson(json);
}

@JsonSerializable(createToJson: false)
class ThemeConfigurationLinks {
  @JsonKey(name: 'segment_pages')
  Map<String, String>? segmentPages;
  Map<String, String>? menus;
  Map<String, String>? pages;
  Map<String, String>? forms;
  Map<String, String>? galleries;
  Map<String, String>? files;
  @JsonKey(name: 'blog_categories')
  Map<String, String>? blogCategories;

  ThemeConfigurationLinks(
      {this.segmentPages, this.menus, this.pages, this.forms, this.galleries, this.files, this.blogCategories});

  factory ThemeConfigurationLinks.fromJson(Map<String, dynamic> json) => _$ThemeConfigurationLinksFromJson(json);
}

@JsonSerializable(createToJson: false)
class ThemeConfigurationGroup {
  String? name;
  Map<String, String>? title;
  Iterable<ThemeConfigurationField>? fields;

  ThemeConfigurationGroup({this.name, this.title, this.fields});

  factory ThemeConfigurationGroup.fromJson(Map<String, dynamic> json) => _$ThemeConfigurationGroupFromJson(json);
}

@JsonSerializable(createToJson: false)
class ThemeConfigurationField {
  String? name;
  String? type;
  Map<String, String>? label;

  ThemeConfigurationField({this.name, this.type, this.label});

  factory ThemeConfigurationField.fromJson(Map<String, dynamic> json) => _$ThemeConfigurationFieldFromJson(json);
}

@JsonSerializable(createToJson: false)
class ThemeConfigurationStructure {
  Map<String, String>? title;
  Iterable<ThemeConfigurationGroup>? groups;
  ThemeConfigurationLinks? links;

  ThemeConfigurationStructure({this.title, this.groups, this.links});

  factory ThemeConfigurationStructure.fromJson(Map<String, dynamic> json) =>
      _$ThemeConfigurationStructureFromJson(json);
}

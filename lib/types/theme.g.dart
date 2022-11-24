// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Theme _$ThemeFromJson(Map<String, dynamic> json) => Theme(
      configuration: (json['configuration'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as Map<String, dynamic>),
      ),
      scssVariables: (json['scssVariables'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      name: json['name'] as String?,
      description: (json['description'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      id: json['id'] as int?,
    );

ThemeBlogCategory _$ThemeBlogCategoryFromJson(Map<String, dynamic> json) =>
    ThemeBlogCategory(
      name: json['name'] as String?,
      blogCategory: json['blogCategory'] == null
          ? null
          : BlogCategory.fromJson(json['blogCategory'] as Map<String, dynamic>),
    );

ThemeFile _$ThemeFileFromJson(Map<String, dynamic> json) => ThemeFile(
      name: json['name'] as String?,
      file: json['file'] == null
          ? null
          : File.fromJson(json['file'] as Map<String, dynamic>),
    );

ThemeForm _$ThemeFormFromJson(Map<String, dynamic> json) => ThemeForm(
      name: json['name'] as String?,
      form: json['form'] == null
          ? null
          : Form.fromJson(json['form'] as Map<String, dynamic>),
    );

ThemeGallery _$ThemeGalleryFromJson(Map<String, dynamic> json) => ThemeGallery(
      name: json['name'] as String?,
      gallery: json['gallery'] == null
          ? null
          : Gallery.fromJson(json['gallery'] as Map<String, dynamic>),
    );

ThemeMenu _$ThemeMenuFromJson(Map<String, dynamic> json) => ThemeMenu(
      name: json['name'] as String?,
      menu: json['menu'] == null
          ? null
          : Menu.fromJson(json['menu'] as Map<String, dynamic>),
    );

ThemePage _$ThemePageFromJson(Map<String, dynamic> json) => ThemePage(
      name: json['name'] as String?,
      page: json['page'] == null
          ? null
          : SimplePage.fromJson(json['page'] as Map<String, dynamic>),
    );

ThemeSegmentPage _$ThemeSegmentPageFromJson(Map<String, dynamic> json) =>
    ThemeSegmentPage(
      name: json['name'] as String?,
      segmentPage: json['segmentPage'] == null
          ? null
          : SegmentPage.fromJson(json['segmentPage'] as Map<String, dynamic>),
    );

ThemeConfigurationLinks _$ThemeConfigurationLinksFromJson(
        Map<String, dynamic> json) =>
    ThemeConfigurationLinks(
      segmentPages: (json['segment_pages'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      menus: (json['menus'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      pages: (json['pages'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      forms: (json['forms'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      galleries: (json['galleries'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      files: (json['files'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      blogCategories: (json['blog_categories'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

ThemeConfigurationGroup _$ThemeConfigurationGroupFromJson(
        Map<String, dynamic> json) =>
    ThemeConfigurationGroup(
      name: json['name'] as String?,
      title: (json['title'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      fields: (json['fields'] as List<dynamic>?)?.map(
          (e) => ThemeConfigurationField.fromJson(e as Map<String, dynamic>)),
    );

ThemeConfigurationField _$ThemeConfigurationFieldFromJson(
        Map<String, dynamic> json) =>
    ThemeConfigurationField(
      name: json['name'] as String?,
      type: json['type'] as String?,
      label: (json['label'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

ThemeConfigurationStructure _$ThemeConfigurationStructureFromJson(
        Map<String, dynamic> json) =>
    ThemeConfigurationStructure(
      title: (json['title'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      groups: (json['groups'] as List<dynamic>?)?.map(
          (e) => ThemeConfigurationGroup.fromJson(e as Map<String, dynamic>)),
      links: json['links'] == null
          ? null
          : ThemeConfigurationLinks.fromJson(
              json['links'] as Map<String, dynamic>),
    );

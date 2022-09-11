// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuForm _$MenuFormFromJson(Map<String, dynamic> json) => MenuForm(
      id: json['id'] as int?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$MenuFormToJson(MenuForm instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
    };

MenuArtist _$MenuArtistFromJson(Map<String, dynamic> json) => MenuArtist(
      id: json['id'] as int?,
      artistName: json['artistName'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$MenuArtistToJson(MenuArtist instance) =>
    <String, dynamic>{
      'id': instance.id,
      'artistName': instance.artistName,
      'email': instance.email,
    };

MenuPage _$MenuPageFromJson(Map<String, dynamic> json) => MenuPage(
      id: json['id'] as int?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$MenuPageToJson(MenuPage instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
    };

MenuSegmentPage _$MenuSegmentPageFromJson(Map<String, dynamic> json) =>
    MenuSegmentPage(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$MenuSegmentPageToJson(MenuSegmentPage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

MenuGallery _$MenuGalleryFromJson(Map<String, dynamic> json) => MenuGallery(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$MenuGalleryToJson(MenuGallery instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

MenuCategory _$MenuCategoryFromJson(Map<String, dynamic> json) => MenuCategory(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$MenuCategoryToJson(MenuCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

MenuItem _$MenuItemFromJson(Map<String, dynamic> json) => MenuItem(
      id: json['id'] as int?,
      position: json['position'] as int?,
      highlighted: json['highlighted'] as bool?,
      title: json['title'] as String?,
      route: json['route'] as String?,
      blogHomePage: json['blogHomePage'] as bool?,
      form: json['form'] == null
          ? null
          : MenuForm.fromJson(json['form'] as Map<String, dynamic>),
      page: json['page'] == null
          ? null
          : MenuPage.fromJson(json['page'] as Map<String, dynamic>),
      artist: json['artist'] == null
          ? null
          : MenuArtist.fromJson(json['artist'] as Map<String, dynamic>),
      category: json['category'] == null
          ? null
          : MenuCategory.fromJson(json['category'] as Map<String, dynamic>),
      gallery: json['gallery'] == null
          ? null
          : MenuGallery.fromJson(json['gallery'] as Map<String, dynamic>),
      segmentPage: json['segmentPage'] == null
          ? null
          : MenuSegmentPage.fromJson(
              json['segmentPage'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => MenuItem.fromJson(e as Map<String, dynamic>)),
    );

Map<String, dynamic> _$MenuItemToJson(MenuItem instance) => <String, dynamic>{
      'id': instance.id,
      'position': instance.position,
      'highlighted': instance.highlighted,
      'title': instance.title,
      'route': instance.route,
      'blogHomePage': instance.blogHomePage,
      'form': instance.form,
      'page': instance.page,
      'artist': instance.artist,
      'category': instance.category,
      'gallery': instance.gallery,
      'segmentPage': instance.segmentPage,
      'items': instance.items?.toList(),
    };

import 'package:json_annotation/json_annotation.dart';

part 'menu_item.g.dart';

@JsonSerializable()
class MenuForm {
  int? id;
  String? title;

  MenuForm({
    this.id,
    this.title,
  });

  factory MenuForm.fromJson(Map<String, dynamic> json) => _$MenuFormFromJson(json);

  Map<String, dynamic> toJson() => _$MenuFormToJson(this);
}

@JsonSerializable()
class MenuArtist {
  int? id;
  String? artistName;
  String? email;

  MenuArtist({
    this.id,
    this.artistName,
    this.email,
  });

  factory MenuArtist.fromJson(Map<String, dynamic> json) => _$MenuArtistFromJson(json);

  Map<String, dynamic> toJson() => _$MenuArtistToJson(this);
}

@JsonSerializable()
class MenuPage {
  int? id;
  String? title;

  MenuPage({
    this.id,
    this.title,
  });

  factory MenuPage.fromJson(Map<String, dynamic> json) => _$MenuPageFromJson(json);

  Map<String, dynamic> toJson() => _$MenuPageToJson(this);
}

@JsonSerializable()
class MenuSegmentPage {
  int? id;
  String? name;

  MenuSegmentPage({
    this.id,
    this.name,
  });

  factory MenuSegmentPage.fromJson(Map<String, dynamic> json) => _$MenuSegmentPageFromJson(json);

  Map<String, dynamic> toJson() => _$MenuSegmentPageToJson(this);
}

@JsonSerializable()
class MenuGallery {
  int? id;
  String? name;

  MenuGallery({
    this.id,
    this.name,
  });

  factory MenuGallery.fromJson(Map<String, dynamic> json) => _$MenuGalleryFromJson(json);

  Map<String, dynamic> toJson() => _$MenuGalleryToJson(this);
}

@JsonSerializable()
class MenuCategory {
  int? id;
  String? name;

  MenuCategory({
    this.id,
    this.name,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) => _$MenuCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$MenuCategoryToJson(this);
}

@JsonSerializable()
class MenuItem {
  int? id;
  int? position;
  bool? highlighted;
  String? title;
  String? route;
  bool? blogHomePage;
  MenuForm? form;
  MenuPage? page;
  MenuArtist? artist;
  MenuCategory? category;
  MenuGallery? gallery;
  MenuSegmentPage? segmentPage;

  MenuItem({
    this.id,
    this.position,
    this.highlighted,
    this.title,
    this.route,
    this.blogHomePage,
    this.form,
    this.page,
    this.artist,
    this.category,
    this.gallery,
    this.segmentPage,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) => _$MenuItemFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemToJson(this);
}

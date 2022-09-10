import 'package:json_annotation/json_annotation.dart';

part 'artist.g.dart';

@JsonEnum()
enum ColorScheme {
  @JsonValue('dark')
  dark,
  @JsonValue('light')
  light,
  @JsonValue('auto')
  auto,
}

@JsonSerializable()
class Artist {
  int? id;
  String? artistName;
  String? email;
  String? profilePicture;
  String? aboutMe;
  List<String>? roles;
  ColorScheme? colorScheme;

  Artist({
    this.id,
    this.artistName,
    this.email,
    this.profilePicture,
    this.roles,
  });

  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);

  Map<String, dynamic> toJson() => _$ArtistToJson(this);
}

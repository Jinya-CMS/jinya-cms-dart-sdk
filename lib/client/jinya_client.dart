import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../errors/MissingFieldException.dart';
import '../errors/MissingApiKeyException.dart';
import '../errors/NotFoundException.dart';
import '../errors/NotEnoughPermissionsException.dart';
import '../errors/ConflictException.dart';
import '../types/types.dart';

class _JinyaResponse {
  late Map<String, dynamic> data;
  int statusCode = 204;
  late http.Response response;

  _JinyaResponse();

  factory _JinyaResponse.fromHttpResponse(http.Response response) {
    final _response = _JinyaResponse();
    _response.response = response;
    if (response.headers[io.HttpHeaders.contentTypeHeader] == 'application/json') {
      _response.data = jsonDecode(response.body);
    }
    _response.statusCode = response.statusCode;

    if (response.statusCode == io.HttpStatus.badRequest) {
      throw MissingFieldsException(_response.data['validation'].keys);
    } else if (response.statusCode == io.HttpStatus.unauthorized) {
      throw MissingApiKeyException();
    } else if (response.statusCode == io.HttpStatus.notFound) {
      throw NotFoundException();
    } else if (response.statusCode == io.HttpStatus.forbidden) {
      throw NotEnoughPermissionsException();
    } else if (response.statusCode == io.HttpStatus.conflict) {
      throw ConflictException();
    }

    return _response;
  }
}

class JinyaClient {
  late final String _jinyaUrl;
  late final String _apiKey;

  JinyaClient(this._jinyaUrl, {apiKey = ''}) {
    _apiKey = apiKey;
  }

  dynamic _prepareBody(body) {
    if (body is String) {
      return body.codeUnits;
    }

    if (body is Map) {
      return jsonEncode(body).codeUnits;
    }

    return body;
  }

  Future<_JinyaResponse> _post(
    String path, {
    Map<String, String> additionalHeaders = const {},
    data,
  }) async {
    final response = await http.post(
      Uri.parse('$_jinyaUrl/$path'),
      headers: {
        io.HttpHeaders.contentTypeHeader: 'application/json',
        'JinyaApiKey': _apiKey,
        ...additionalHeaders,
      },
      body: _prepareBody(data),
    );

    return _JinyaResponse.fromHttpResponse(response);
  }

  Future<_JinyaResponse> _postRaw(
    String path, {
    Map<String, String> additionalHeaders = const {},
    data,
  }) async {
    final response = await http.post(
      Uri.parse('$_jinyaUrl/$path'),
      headers: {
        'JinyaApiKey': _apiKey,
        ...additionalHeaders,
      },
      body: _prepareBody(data),
    );

    return _JinyaResponse.fromHttpResponse(response);
  }

  Future<_JinyaResponse> _put(
    String path, {
    Map<String, String> additionalHeaders = const {},
    data,
  }) async {
    final response = await http.put(
      Uri.parse('$_jinyaUrl/$path'),
      headers: {
        io.HttpHeaders.contentTypeHeader: 'application/json',
        'JinyaApiKey': _apiKey,
        ...additionalHeaders,
      },
      body: _prepareBody(data),
    );

    return _JinyaResponse.fromHttpResponse(response);
  }

  Future<_JinyaResponse> _putRaw(
    String path, {
    Map<String, String> additionalHeaders = const {},
    data,
  }) async {
    final response = await http.put(
      Uri.parse('$_jinyaUrl/$path'),
      headers: {
        'JinyaApiKey': _apiKey,
        ...additionalHeaders,
      },
      body: _prepareBody(data),
    );

    return _JinyaResponse.fromHttpResponse(response);
  }

  Future<_JinyaResponse> _get(
    String path, {
    Map<String, String> additionalHeaders = const {},
  }) async {
    final response = await http.get(
      Uri.parse('$_jinyaUrl/$path'),
      headers: {
        io.HttpHeaders.contentTypeHeader: 'application/json',
        'JinyaApiKey': _apiKey,
        ...additionalHeaders,
      },
    );

    return _JinyaResponse.fromHttpResponse(response);
  }

  Future<_JinyaResponse> _head(
    String path, {
    Map<String, String> additionalHeaders = const {},
  }) async {
    final response = await http.head(
      Uri.parse('$_jinyaUrl/$path'),
      headers: {
        io.HttpHeaders.contentTypeHeader: 'application/json',
        'JinyaApiKey': _apiKey,
        ...additionalHeaders,
      },
    );

    return _JinyaResponse.fromHttpResponse(response);
  }

  Future<_JinyaResponse> _delete(
    String path, {
    Map<String, String> additionalHeaders = const {},
  }) async {
    final response = await http.delete(
      Uri.parse('$_jinyaUrl/$path'),
      headers: {
        io.HttpHeaders.contentTypeHeader: 'application/json',
        'JinyaApiKey': _apiKey,
        ...additionalHeaders,
      },
    );

    return _JinyaResponse.fromHttpResponse(response);
  }

  /// Requests a two factor code for the given username and password
  Future<bool> requestTwoFactorCode(String username, String password) async {
    try {
      await _post('/api/2fa', data: {'username': username, 'password': password});

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Performs the login using username, password and one of twoFactorCode or deviceCode. If none is provided a MissingFieldsException is thrown
  Future<LoginData> login(String username, String password, {String? twoFactorCode, String? deviceCode}) async {
    _JinyaResponse? response;
    if (deviceCode != null) {
      response = await _post(
        '/api/login',
        data: {username, password},
        additionalHeaders: {'JinyaDeviceCode': deviceCode},
      );
    } else if (twoFactorCode != null) {
      response = await _post(
        '/api/login',
        data: {'username': username, 'password': password, 'twoFactorCode': twoFactorCode},
      );
    }

    if (response != null) {
      return LoginData.fromJson(response.data);
    }

    throw MissingFieldsException(['twoFactorCode']);
  }

  /// Removes the current api key from the database
  Future<void> logout() async {
    try {
      await _delete('/api/api_key/$_apiKey');
    } catch (e) {}
  }

  /// Updates the password of the current user
  Future<void> changePassword(String oldPassword, String newPassword) async {
    await _post('/api/account/password', data: {'oldPassword': oldPassword, 'password': newPassword});
  }

  /// Checks if the given api key is valid
  Future<bool> validateApiKey(String apiKey) async {
    try {
      await _head('/api/login');

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Gets all api keys for the current user
  Future<Iterable<ApiKey>> getApiKeys() async {
    final response = await _get('/api/api_key');

    return response.data['items'].map((e) => ApiKey.fromJson(e));
  }

  /// Invalidates the given api key
  Future<bool> invalidateApiKey(String apiKey) async {
    try {
      await _delete('/api/api_key/$apiKey');

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Checks if the given known device is valid
  Future<bool> validateKnownDevice(String knownDevice) async {
    try {
      await _head('/api/known_device/$knownDevice');

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Gets all known devices for the current user
  Future<Iterable<KnownDevice>> getKnownDevices() async {
    final response = await _get('/api/known_device');

    return response.data['items'].map((e) => KnownDevice.fromJson(e));
  }

  /// Invalidates the given known device
  Future<bool> invalidateKnownDevice(String knownDevice) async {
    try {
      await _delete('/api/known_device/$knownDevice');

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Gets all artists
  Future<Iterable<Artist>> getArtists() async {
    final response = await _get('/api/artist');

    return response.data['items'].map((e) => Artist.fromJson(e));
  }

  /// Gets the artist with the given id
  Future<Artist> getArtistById(int id) async {
    final response = await _get('/api/artist/$id');

    return Artist.fromJson(response.data);
  }

  /// Creates a new artist
  Future<Artist> createArtist(
    String artistName,
    String email,
    String password, {
    bool enabled = true,
    bool isReader = true,
    bool isWriter = true,
    bool isAdmin = false,
  }) async {
    final roles = <String>[];
    if (isReader) {
      roles.add('ROLE_READER');
    }
    if (isWriter) {
      roles.add('ROLE_WRITER');
    }
    if (isAdmin) {
      roles.add('ROLE_ADMIN');
    }
    final response = await _post('/api/artist', data: {
      'artistName': artistName,
      'email': email,
      'enabled': enabled,
      'password': password,
      'roles': roles,
    });

    return Artist.fromJson(response.data);
  }

  /// Updates the given artist
  Future<void> updateArtist(Artist artist) async {
    await _put('/api/artist/${artist.id}');
  }

  /// Deletes the given artist by id
  Future<void> deleteArtist(int id) async {
    await _delete('/api/artist/$id');
  }

  /// Activates the given artist by id
  Future<void> activateArtist(int id) async {
    await _put('/api/artist/$id/activation');
  }

  /// Deactivates the given artist by id
  Future<void> deactivateArtist(int id) async {
    await _delete('/api/artist/$id/activation');
  }

  /// Uploads a new profile picture for the given artist
  Future<void> uploadProfilePicture(int id, io.File file) async {
    await _putRaw('/api/artist/$id/profilepicture', data: file);
  }

  /// Deletes the profile picture of the given artist
  Future<Uint8List> getProfilePicture(int id) async {
    final response = await _get('/api/artist/$id/profilepicture');

    return response.response.bodyBytes;
  }

  /// Gets the details of the current artist
  Future<Artist> getArtistInfo() async {
    final response = await _get('/api/me');

    return Artist.fromJson(response.data);
  }

  /// Updates the about me info of the current artist
  Future<void> updateAboutMe(String email, String artistName, String aboutMe) async {
    await _put('/api/me', data: {
      'email': email,
      'artistName': artistName,
      'aboutMe': aboutMe,
    });
  }

  /// Sets the color scheme the current user prefers
  Future<void> updateColorScheme(ColorScheme colorScheme) async {
    await _put('/api/me/colorscheme', data: {
      'colorScheme': colorScheme.toString(),
    });
  }

  /// Gets all blog categories
  Future<Iterable<BlogCategory>> getBlogCategories() async {
    final response = await _get('/api/blog/category');

    return response.data['items'].map((e) => BlogCategory.fromJson(e));
  }

  /// Gets a blog category by id
  Future<BlogCategory> getBlogCategoryById(int id) async {
    final response = await _get('/api/blog/category/$id');

    return BlogCategory.fromJson(response.data);
  }

  /// Creates a new blog category with the given data
  Future<BlogCategory> createBlogCategory(
    String name,
    String description,
    int parentId,
    bool webhookEnabled,
    String webhookUrl,
  ) async {
    final response = await _post('/api/blog/category', data: {
      'name': name,
      'description': description,
      'parentId': parentId,
      'webhookEnabled': webhookEnabled,
      'webhookUrl': webhookUrl,
    });

    return BlogCategory.fromJson(response.data);
  }

  /// Updates the given blog category
  Future<void> updateBlogCategory(BlogCategory blogCategory) async {
    await _put('/api/blog/category/${blogCategory.id}', data: blogCategory.toJson());
  }

  /// Deletes the given blog category
  Future<void> deleteBlogCategory(int id) async {
    await _delete('/api/blog/category/$id');
  }

  /// Gets all blog posts, optionally filtered by category
  Future<Iterable<BlogPost>> getBlogPosts({int? categoryId}) async {
    var url = '/api/blog/post';

    if (categoryId != null) {
      url = '/api/blog/category/$categoryId/post';
    }

    final response = await _get(url);

    return response.data['items'].map((e) => BlogPost.fromJson(e));
  }

  /// Gets a blog post by id
  Future<BlogPost> getBlogPostById(int id) async {
    final response = await _get('/api/blog/post/$id');

    return BlogPost.fromJson(response.data);
  }

  /// Creates a new blog post with the given data
  Future<BlogPost> createBlogPost(
    String title,
    String slug,
    int headerImageId,
    int categoryId,
  ) async {
    final response = await _post('/api/blog/post', data: {
      'title': title,
      'slug': slug,
      'headerImageId': headerImageId,
      'categoryId': categoryId,
    });

    return BlogPost.fromJson(response.data);
  }

  /// Updates the given blog post
  Future<void> updateBlogPost(BlogPost blogPost) async {
    await _put('/api/blog/post/${blogPost.id}', data: blogPost.toJson());
  }

  /// Deletes the given blog post
  Future<void> deleteBlogPost(int id) async {
    await _delete('/api/blog/post/$id');
  }

  /// Gets the segments of the given blog post
  Future<Iterable<BlogPostSegment>> getBlogPostSegments(int postId) async {
    final response = await _get('/api/blog/post/$postId/segment');

    return response.data['items'].map((e) => BlogPostSegment.fromJson(e));
  }

  /// Batch replaces all blog post segments with the list of segments
  Future<void> batchReplaceBlogPostSegments(int postId, Iterable<BlogPostSegment> segments) async {
    final postData = {
      'segments': segments.map((e) {
        final data = <String, dynamic>{
          'position': e.position,
          'blogPostId': postId,
        };
        if (e.file != null) {
          data['fileId'] = e.file!.id;
          data['link'] = e.link;
        } else if (e.gallery != null) {
          data['galleryId'] = e.gallery!.id;
        } else {
          data['html'] = e.html ?? '';
        }

        return data;
      }),
    };

    await _put('/api/blog/post/$postId/segment', data: postData);
  }

  /// Gets all files
  Future<Iterable<File>> getFiles() async {
    final response = await _get('/api/media/file');

    return response.data['items'].map((e) => File.fromJson(e));
  }

  /// Gets the file with the given id
  Future<File> getFileById(int id) async {
    final response = await _get('/api/media/file/$id');

    return File.fromJson(response.data);
  }

  /// Creates a new file with the given name
  Future<File> createFile(String name) async {
    final response = await _post('/api/media/file', data: {'name': name});

    return File.fromJson(response.data);
  }

  /// Starts the file upload
  Future<void> startFileUpload(int id) async {
    await _put('/api/media/file/$id/content');
  }

  /// Uploads a file chunk
  Future<void> uploadFileChunk(int id, int position, Uint8List chunk) async {
    await _putRaw('/api/media/file/$id/content/$position', data: chunk);
  }

  /// Finishes the file upload
  Future<void> finishFileUpload(int id) async {
    await _put('/api/media/file/$id/content/finish');
  }

  /// Updates the given file
  Future<void> updateFile(File file) async {
    await _put('/api/media/file/${file.id}', data: {'name': file.name});
  }

  /// Deletes the given file
  Future<void> deleteFile(int id) async {
    await _delete('/api/media/file/$id');
  }

  /// Gets all galleries
  Future<Iterable<Gallery>> getGalleries() async {
    final response = await _get('/api/media/gallery');

    return response.data['items'].map((e) => Gallery.fromJson(e));
  }

  /// Gets the gallery with the given id
  Future<Gallery> getGallery(int id) async {
    final response = await _get('/api/media/gallery/$id');

    return Gallery.fromJson(response.data);
  }

  /// Creates the gallery with the given data
  Future<Gallery> createGallery(String name, String description, Orientation orientation, Type type) async {
    final response = await _post('/api/media/gallery', data: {
      'name': name,
      'description': description,
      'orientation': orientation,
      'type': type,
    });

    return Gallery.fromJson(response.data);
  }

  /// Updates the given gallery
  Future<void> updateGallery(Gallery gallery) async {
    await _put('/api/media/gallery/${gallery.id}', data: gallery.toJson());
  }

  /// Deletes the given gallery
  Future<void> deleteGallery(int id) async {
    await _delete('/api/media/gallery/$id');
  }

  /// Gets all gallery file positions for the given gallery
  Future<Iterable<GalleryFilePosition>> getGalleryFilePositions(int galleryId) async {
    final response = await _get('/api/media/gallery/$galleryId/file');

    return response.data['items'].map((e) => GalleryFilePosition.fromJson(e));
  }

  /// Deletes the gallery file position from the given gallery at the given position
  Future<void> deleteGalleryFilePosition(int galleryId, int position) async {
    await _delete('/api/media/gallery/$galleryId/file/$position');
  }

  /// Moves the gallery file position to the new position
  Future<void> moveGalleryFilePosition(int galleryId, int oldPosition, int newPosition) async {
    await _put('/api/media/gallery/$galleryId/file/$oldPosition', data: {'newPosition': newPosition});
  }

  /// Creates a new gallery file position
  Future<void> createGalleryFilePosition(int galleryId, int position, int fileId) async {
    await _post('/api/media/gallery/$galleryId/file', data: {'position': position, 'file': fileId});
  }
}

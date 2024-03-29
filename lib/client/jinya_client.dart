import 'dart:convert';
import 'dart:core';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../errors/conflict_exception.dart';
import '../errors/missing_api_key_exception.dart';
import '../errors/missing_field_exception.dart';
import '../errors/not_enough_permissions_exception.dart';
import '../errors/not_found_exception.dart';
import '../types/types.dart';

class _JinyaResponse {
  late dynamic data;
  int statusCode = 204;
  late http.Response response;

  _JinyaResponse();

  factory _JinyaResponse.fromHttpResponse(http.Response response) {
    final jinyaResponse = _JinyaResponse();
    jinyaResponse.response = response;
    if (response.headers[io.HttpHeaders.contentTypeHeader] == 'application/json') {
      jinyaResponse.data = jsonDecode(response.body);
    }
    jinyaResponse.statusCode = response.statusCode;

    if (response.statusCode == io.HttpStatus.badRequest) {
      throw MissingFieldsException(jinyaResponse.data['validation'].keys);
    } else if (response.statusCode == io.HttpStatus.unauthorized) {
      throw MissingApiKeyException();
    } else if (response.statusCode == io.HttpStatus.notFound) {
      throw NotFoundException();
    } else if (response.statusCode == io.HttpStatus.forbidden) {
      throw NotEnoughPermissionsException();
    } else if (response.statusCode == io.HttpStatus.conflict) {
      throw ConflictException();
    } else if (response.statusCode < 200 || response.statusCode > 299) {
      throw io.HttpException(response.body);
    }

    return jinyaResponse;
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
      Uri.parse('$_jinyaUrl$path'),
      headers: {
        io.HttpHeaders.contentTypeHeader: 'application/json',
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
      Uri.parse('$_jinyaUrl$path'),
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
      Uri.parse('$_jinyaUrl$path'),
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
      Uri.parse('$_jinyaUrl$path'),
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
      Uri.parse('$_jinyaUrl$path'),
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
      Uri.parse('$_jinyaUrl$path'),
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
        data: {'username': username, 'password': password},
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
      // ignore: empty_catches
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

    return response.data['items'].map<ApiKey>((e) => ApiKey.fromJson(e));
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

    return response.data['items'].map<KnownDevice>((e) => KnownDevice.fromJson(e));
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

    return response.data['items'].map<Artist>((e) => Artist.fromJson(e));
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
    await _put('/api/artist/${artist.id}', data: artist.toJson());
  }

  /// Sets the artists password
  Future<void> changePasswordAdmin(int artistId, String password) async {
    await _put('/api/artist/$artistId', data: {'password': password});
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

    return response.data['items'].map<BlogCategory>((e) => BlogCategory.fromJson(e));
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
    int? parentId,
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
    final data = blogCategory.toJson();
    data['parentId'] = blogCategory.parent?.id;
    await _put('/api/blog/category/${blogCategory.id}', data: data);
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

    return response.data['items'].map<BlogPost>((e) => BlogPost.fromJson(e));
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
    int? headerImageId,
    int categoryId,
    bool public,
  ) async {
    final response = await _post('/api/blog/post', data: {
      'title': title,
      'slug': slug,
      'headerImageId': headerImageId,
      'categoryId': categoryId,
      'public': public,
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

    return response.data.map<BlogPostSegment>((e) => BlogPostSegment.fromJson(e));
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
          data['file'] = e.file!.id;
          data['link'] = e.link;
        } else if (e.gallery != null) {
          data['gallery '] = e.gallery!.id;
        } else {
          data['html'] = e.html ?? '';
        }

        return data;
      }).toList(),
    };

    await _put('/api/blog/post/$postId/segment', data: postData);
  }

  /// Gets all files
  Future<Iterable<File>> getFiles() async {
    final response = await _get('/api/media/file');

    return response.data['items'].map<File>((e) => File.fromJson(e));
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

    return response.data['items'].map<Gallery>((e) => Gallery.fromJson(e));
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

    return response.data.map<GalleryFilePosition>((e) => GalleryFilePosition.fromJson(e));
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
  Future<GalleryFilePosition> createGalleryFilePosition(int galleryId, int position, int fileId) async {
    final response = await _post('/api/media/gallery/$galleryId/file', data: {'position': position, 'file': fileId});

    return GalleryFilePosition.fromJson(response.data);
  }

  /// Gets all forms
  Future<Iterable<Form>> getForms() async {
    final response = await _get('/api/form');

    return response.data['items'].map<Form>((e) => Form.fromJson(e));
  }

  /// Gets form by id
  Future<Form> getFormById(int id) async {
    final response = await _get('/api/form/$id');

    return Form.fromJson(response.data);
  }

  /// Creates a new form with the given data
  Future<Form> createForm(String description, String title, String toAddress) async {
    final response = await _post('/api/form', data: {
      'description': description,
      'title': title,
      'toAddress': toAddress,
    });

    return Form.fromJson(response.data);
  }

  /// Updates the given form
  Future<void> updateForm(Form form) async {
    await _put('/api/form/${form.id}', data: form.toJson());
  }

  /// Deletes the form with the given id
  Future<void> deleteForm(int id) async {
    await _delete('/api/form/$id');
  }

  /// Gets all form items for the given form
  Future<Iterable<FormItem>> getFormItems(int formId) async {
    final response = await _get('/api/form/$formId/item');

    return response.data.map<FormItem>((e) => FormItem.fromJson(e));
  }

  /// Deletes the form item in the given form at the given position
  Future<void> deleteFormItem(int formId, int position) async {
    await _delete('/api/form/$formId/item/$position');
  }

  /// Creates a new form item
  Future<FormItem> createFormItem(
    int formId,
    String type,
    int position,
    String label, {
    String placeholder = '',
    String helpText = '',
    bool isRequired = false,
    bool isFromAddress = false,
    bool isSubject = false,
    Iterable<String> options = const <String>[],
    Iterable<String> spamFilter = const <String>[],
  }) async {
    final response = await _post('/api/form/$formId/item', data: {
      'type': type,
      'label': label,
      'placeholder': placeholder,
      'helpText': helpText,
      'isRequired': isRequired,
      'isFromAddress': isFromAddress,
      'isSubject': isSubject,
      'options': options,
      'spamFilter': spamFilter,
      'position': position,
    });

    return FormItem.fromJson(response.data);
  }

  /// Updates the given form item
  Future<void> updateFormItem(int formId, FormItem formItem) async {
    await _put('/api/form/$formId/item/${formItem.position}', data: formItem.toJson());
  }

  /// Moves the form item in the given form at the given position to the new position
  Future<void> moveFormItem(int formId, int oldPosition, int newPosition) async {
    await _put('/api/form/$formId/item/$oldPosition', data: {'newPosition': newPosition});
  }

  /// Gets all menus
  Future<Iterable<Menu>> getMenus() async {
    final response = await _get('/api/menu');
    final data = response.data['items'].map<Menu>((e) => Menu.fromJson(e));
    return data;
  }

  /// Gets the menu with the given id
  Future<Menu> getMenuById(int id) async {
    final response = await _get('/api/menu/$id');

    return Menu.fromJson(response.data);
  }

  /// Creates a new menu with the given data
  Future<Menu> createMenu(String name, int? logoId) async {
    final response = await _post('/api/menu', data: {
      'name': name,
      'logo': logoId,
    });

    return Menu.fromJson(response.data);
  }

  /// Updates the given menu
  Future<void> updateMenu(Menu menu) async {
    await _put('/api/menu/${menu.id}', data: {
      'logo': menu.logo?.id,
      'name': menu.name,
    });
  }

  /// Deletes the given menu
  Future<void> deleteMenu(int id) async {
    await _delete('/api/menu/$id');
  }

  /// Gets all menu items for the given menu
  Future<Iterable<MenuItem>> getMenuItems(int menuId) async {
    final response = await _get('/api/menu/$menuId/item');

    return response.data.map<MenuItem>((e) => MenuItem.fromJson(e));
  }

  /// Creates a new menu item with the given menu as parent
  Future<MenuItem> createMenuItemByMenu(
    int menuId,
    String route,
    int position,
    String title, {
    int? artist,
    int? form,
    int? page,
    int? segmentPage,
    int? gallery,
    int? category,
    bool? blogHomePage,
    bool? highlighted,
  }) async {
    final response = await _post('/api/menu/$menuId/item', data: {
      'route': route,
      'position': position,
      'title': title,
      'artist': artist,
      'form': form,
      'page': page,
      'segmentPage': segmentPage,
      'gallery': gallery,
      'category': category,
      'blogHomePage': blogHomePage,
      'highlighted': highlighted,
    });

    return MenuItem.fromJson(response.data);
  }

  /// Creates a new menu item with the given menu item as parent
  Future<MenuItem> createMenuItemByMenuItem(
    int parentId,
    String route,
    int position,
    String title, {
    int? artist,
    int? form,
    int? page,
    int? segmentPage,
    int? gallery,
    int? category,
    bool? blogHomePage,
    bool? highlighted,
  }) async {
    final response = await _post('/api/menu-item/$parentId/item', data: {
      'route': route,
      'position': position,
      'title': title,
      'artist': artist,
      'form': form,
      'page': page,
      'segmentPage': segmentPage,
      'gallery': gallery,
      'category': category,
      'blogHomePage': blogHomePage,
      'highlighted': highlighted,
    });

    return MenuItem.fromJson(response.data);
  }

  /// Updates the given menu item with the given values
  Future<void> updateMenuItem(
    int itemId, {
    String? route,
    int? position,
    String? title,
    int? artist,
    int? form,
    int? page,
    int? segmentPage,
    int? gallery,
    int? category,
    bool? blogHomePage,
    bool? highlighted,
  }) async {
    await _put('/api/menu-item/$itemId', data: {
      'route': route,
      'position': position,
      'title': title,
      'artist': artist,
      'form': form,
      'page': page,
      'segmentPage': segmentPage,
      'gallery': gallery,
      'category': category,
      'blogHomePage': blogHomePage,
      'highlighted': highlighted,
    });
  }

  /// Moves the given menu item to the new position
  Future<void> moveMenuItem(int itemId, int position) async {
    await _put('/api/menu-item/$itemId', data: {
      'position': position,
    });
  }

  /// Deletes the given menu item
  Future<void> deleteMenuItem(int itemId) async {
    await _delete('/api/menu-item/$itemId');
  }

  /// Moves the given menu item one level up in the menu tree
  Future<void> moveMenuItemParentOneLevelUp(int menuId, int itemId) async {
    await _put('/api/menu/$menuId/item/$itemId/move/parent/one/level/up');
  }

  /// Moves the given menu item to the menu as the new parent
  Future<void> moveMenuItemToMenuParent(int menuId, int itemId) async {
    await _put('/api/menu/$itemId/move/parent/to/menu/$menuId');
  }

  /// Moves the given menu item to the new parent
  Future<void> moveMenuItemToNewParent(int itemId, int newParentId) async {
    await _put('/api/menu-item/$itemId/move/parent/to/item/$newParentId');
  }

  /// Gets all simple pages
  Future<Iterable<SimplePage>> getSimplePages() async {
    final response = await _get('/api/simple-page');

    return response.data['items'].map<SimplePage>((e) => SimplePage.fromJson(e));
  }

  /// Gets the simple page by id
  Future<SimplePage> getSimplePageById(int id) async {
    final response = await _get('/api/simple-page/$id');

    return SimplePage.fromJson(response.data);
  }

  /// Creates a new simple page with the given data
  Future<SimplePage> createSimplePage(String title, String content) async {
    final response = await _post('/api/simple-page', data: {
      'title': title,
      'content': content,
    });

    return SimplePage.fromJson(response.data);
  }

  /// Updates the given simple page
  Future<void> updateSimplePage(SimplePage page) async {
    await _put('/api/simple-page/${page.id}', data: page.toJson());
  }

  /// Deletes the simple page with the given id
  Future<void> deleteSimplePage(int id) async {
    await _delete('/api/simple-page/$id');
  }

  /// Gets all segment pages
  Future<Iterable<SegmentPage>> getSegmentPages() async {
    final response = await _get('/api/segment-page');

    return response.data['items'].map<SegmentPage>((e) => SegmentPage.fromJson(e));
  }

  /// Gets the segment page by id
  Future<SegmentPage> getSegmentPageById(int id) async {
    final response = await _get('/api/segment-page/$id');

    return SegmentPage.fromJson(response.data);
  }

  /// Creates a new segment page with the given data
  Future<SegmentPage> createSegmentPage(String name) async {
    final response = await _post('/api/segment-page', data: {
      'name': name,
    });

    return SegmentPage.fromJson(response.data);
  }

  /// Updates the segment page
  Future<void> updateSegmentPage(SegmentPage page) async {
    await _put('/api/segment-page/${page.id}', data: page.toJson());
  }

  /// Deletes the segment page
  Future<void> deleteSegmentPage(int id) async {
    await _delete('/api/segment-page/$id');
  }

  /// Gets the segments for the given page
  Future<Iterable<Segment>> getSegmentsByPage(int pageId) async {
    final response = await _get('/api/segment-page/$pageId/segment');

    return response.data.map<Segment>((e) => Segment.fromJson(e));
  }

  /// Creates a new segment for the given page
  Future<Segment> createSegment(int pageId, SegmentType type, Segment segment) async {
    var segmentType = '';
    final data = segment.toJson();
    switch (type) {
      case SegmentType.file:
        segmentType = 'file';
        data['file'] = segment.file!.id!;
        break;
      case SegmentType.gallery:
        segmentType = 'gallery';
        data['gallery'] = segment.gallery!.id!;
        break;
      case SegmentType.html:
        segmentType = 'html';
        break;
    }

    final response = await _post('/api/segment-page/$pageId/segment/$segmentType', data: data);

    return Segment.fromJson(response.data);
  }

  Future<void> moveSegment(int pageId, int oldPosition, int newPosition) async {
    await _put('/api/segment-page/$pageId/segment/$oldPosition', data: {'newPosition': newPosition});
  }

  /// Updates the given segment at the given position
  Future<void> updateSegment(int pageId, int position, Segment segment) async {
    final data = segment.toJson();
    if (segment.file != null) {
      data['file'] = segment.file!.id;
    } else if (segment.gallery != null) {
      data['gallery'] = segment.gallery!.id;
    }

    await _put('/api/segment-page/$pageId/segment/$position', data: data);
  }

  /// Deletes the given segment
  Future<void> deleteSegment(int pageId, int position) async {
    await _delete('/api/segment-page/$pageId/segment/$position');
  }

  /// Gets all themes
  Future<Iterable<Theme>> getThemes() async {
    final response = await _get('/api/theme');

    return response.data['items'].map<Theme>((e) => Theme.fromJson(e));
  }

  /// Uploads a new theme
  Future<void> createTheme(String name, io.File content) async {
    await _post('/api/theme?name=$name', data: await content.readAsBytes());
  }

  /// Updates the given theme
  Future<void> updateTheme(int id, io.File content) async {
    await _post('/api/theme/$id', data: await content.readAsBytes());
  }

  /// Activates the given theme
  Future<void> activateTheme(int id) async {
    await _put('/api/theme/$id/active');
  }

  /// Compiles the given theme
  Future<void> compileTheme(int id) async {
    await _put('/api/theme/$id/assets');
  }

  /// Gets the style variables for the given theme
  Future<Map<String, String>> getStyleVariables(int id) async {
    final response = await _get('/api/theme/$id/styling');
    final Map<String, String> map = {};
    for (var item in response.data.keys) {
      map[item.toString()] = response.data[item].toString();
    }

    return map;
  }

  /// Updates the style variables for the given theme
  Future<void> updateStyleVariables(int id, Map<String, String> variables) async {
    await _put('/api/theme/$id/styling', data: {'variables': variables});
  }

  /// Gets the theme files of the given theme
  Future<Iterable<ThemeFile>> getThemeFiles(int id) async {
    final response = await _get('/api/theme/$id/file');

    return response.data.keys.map<ThemeFile>((name) => ThemeFile(name: name, file: File.fromJson(response.data[name])));
  }

  /// Gets the theme simple pages of the given theme
  Future<Iterable<ThemePage>> getThemeSimplePages(int id) async {
    final response = await _get('/api/theme/$id/page');

    return response.data.keys
        .map<ThemePage>((name) => ThemePage(name: name, page: SimplePage.fromJson(response.data[name])));
  }

  /// Gets the theme segment pages of the given theme
  Future<Iterable<ThemeSegmentPage>> getThemeSegmentPages(int id) async {
    final response = await _get('/api/theme/$id/segment-page');

    return response.data.keys.map<ThemeSegmentPage>(
        (name) => ThemeSegmentPage(name: name, segmentPage: SegmentPage.fromJson(response.data[name])));
  }

  /// Gets the theme forms of the given theme
  Future<Iterable<ThemeForm>> getThemeForms(int id) async {
    final response = await _get('/api/theme/$id/form');

    return response.data.keys.map<ThemeForm>((name) => ThemeForm(name: name, form: Form.fromJson(response.data[name])));
  }

  /// Gets the theme menus of the given theme
  Future<Iterable<ThemeMenu>> getThemeMenus(int id) async {
    final response = await _get('/api/theme/$id/menu');

    return response.data.keys.map<ThemeMenu>((name) => ThemeMenu(name: name, menu: Menu.fromJson(response.data[name])));
  }

  /// Gets the theme galleries of the given theme
  Future<Iterable<ThemeGallery>> getThemeGalleries(int id) async {
    final response = await _get('/api/theme/$id/gallery');

    return response.data.keys
        .map<ThemeGallery>((name) => ThemeGallery(name: name, gallery: Gallery.fromJson(response.data[name])));
  }

  /// Gets the theme category of the given theme
  Future<Iterable<ThemeBlogCategory>> getThemeCategories(int id) async {
    final response = await _get('/api/theme/$id/category');

    return response.data.keys.map<ThemeBlogCategory>(
        (name) => ThemeBlogCategory(name: name, blogCategory: BlogCategory.fromJson(response.data[name])));
  }

  /// Updates the theme file for the given field and theme with the given file
  Future<void> updateThemeFile(int themeId, String field, int fileId) async {
    await _put('/api/theme/$themeId/file/$field', data: {'file': fileId});
  }

  /// Updates the theme simple page for the given field and theme with the given simple page
  Future<void> updateThemeSimplePage(int themeId, String field, int simplePageId) async {
    await _put('/api/theme/$themeId/page/$field', data: {'page': simplePageId});
  }

  /// Updates the theme segment page for the given field and theme with the given segment page
  Future<void> updateThemeSegmentPage(int themeId, String field, int segmentPageId) async {
    await _put('/api/theme/$themeId/segment-page/$field', data: {'segmentPage': segmentPageId});
  }

  /// Updates the theme form for the given field and theme with the given form
  Future<void> updateThemeForm(int themeId, String field, int formId) async {
    await _put('/api/theme/$themeId/form/$field', data: {'form': formId});
  }

  /// Updates the theme menu for the given field and theme with the given menu
  Future<void> updateThemeMenu(int themeId, String field, int menuId) async {
    await _put('/api/theme/$themeId/menu/$field', data: {'menu': menuId});
  }

  /// Updates the theme gallery for the given field and theme with the given gallery
  Future<void> updateThemeGallery(int themeId, String field, int galleryId) async {
    await _put('/api/theme/$themeId/gallery/$field', data: {'gallery': galleryId});
  }

  /// Updates the theme category for the given field and theme with the given category
  Future<void> updateThemeCategory(int themeId, String field, int categoryId) async {
    await _put('/api/theme/$themeId/category/$field', data: {'category': categoryId});
  }

  /// Gets the theme configuration structure
  Future<ThemeConfigurationStructure> getThemeConfigurationStructure(int id) async {
    final response = await _get('/api/theme/$id/configuration/structure');

    return ThemeConfigurationStructure.fromJson(response.data);
  }

  /// Gets the default configuration for the theme
  Future<Map<String, Map<String, dynamic>>> getThemeDefaultConfiguration(int id) async {
    final response = await _get('/api/theme/$id/configuration/default');
    final Map<String, Map<String, dynamic>> map = {};
    for (var group in (response.data as Map<String, dynamic>).keys) {
      final mapGroup = response.data[group] as Map<String, dynamic>;
      map[group] = <String, dynamic>{};
      for (var field in mapGroup.keys) {
        map[group]![field] = mapGroup[field];
      }
    }

    return map;
  }

  /// Updates the configuration for the given theme
  Future<void> updateConfiguration(int id, Map<String, Map<String, dynamic>> configuration) async {
    await _put('/api/theme/$id/configuration', data: {'configuration': configuration});
  }
}

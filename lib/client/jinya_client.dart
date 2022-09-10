import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:jinya_cms/types/api_key.dart';
import 'package:jinya_cms/types/artist.dart';
import 'package:jinya_cms/types/known_device.dart';

import '../errors/MissingFieldException.dart';
import '../errors/MissingApiKeyException.dart';
import '../errors/NotFoundException.dart';
import '../errors/NotEnoughPermissionsException.dart';
import '../errors/ConflictException.dart';
import '../types/login_data.dart';

class _JinyaResponse {
  dynamic data;
  int statusCode = 204;

  _JinyaResponse();

  factory _JinyaResponse.fromHttpResponse(http.Response response) {
    final _response = _JinyaResponse();
    if (response.body != '') {
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
      return LoginData.fromJson(jsonDecode(response.data));
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
    final result = jsonDecode(response.data);
    return result['items'].map((e) => ApiKey.fromJson(e));
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
    final result = jsonDecode(response.data);

    return result['items'].map((e) => KnownDevice.fromJson(e));
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
    final result = jsonDecode(response.data);

    return result['items'].map((e) => Artist.fromJson(e));
  }

  /// Gets the artist with the given id
  Future<Artist> getArtistById(int id) async {
    final response = await _get('/api/artist/$id');

    return Artist.fromJson(jsonDecode(response.data));
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

    return response.data;
  }

  /// Gets the details of the current artist
  Future<Artist> getArtistInfo() async {
    final response = await _get('/api/me');

    return Artist.fromJson(jsonDecode(response.data));
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
    await _put('/api/me/colorscheme',data: {
      'colorScheme': colorScheme.toString(),
    });
  }
}

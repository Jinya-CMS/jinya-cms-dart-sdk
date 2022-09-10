import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:jinya_cms/types/api_key.dart';
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

    if (response.statusCode == HttpStatus.badRequest) {
      throw MissingFieldsException(_response.data['validation'].keys);
    } else if (response.statusCode == HttpStatus.unauthorized) {
      throw MissingApiKeyException();
    } else if (response.statusCode == HttpStatus.notFound) {
      throw NotFoundException();
    } else if (response.statusCode == HttpStatus.forbidden) {
      throw NotEnoughPermissionsException();
    } else if (response.statusCode == HttpStatus.conflict) {
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
        HttpHeaders.contentTypeHeader: 'application/json',
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
        HttpHeaders.contentTypeHeader: 'application/json',
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
        HttpHeaders.contentTypeHeader: 'application/json',
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
        HttpHeaders.contentTypeHeader: 'application/json',
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
        HttpHeaders.contentTypeHeader: 'application/json',
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
}

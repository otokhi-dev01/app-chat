import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final Map<String, dynamic>? errors;
  final Map<String, dynamic> data;

  const ApiException({
    required this.statusCode,
    required this.message,
    this.errors,
    this.data = const <String, dynamic>{},
  });

  bool get isUnauthorized => statusCode == 401;
  bool get isValidationError => statusCode == 422;

  @override
  String toString() => 'ApiException(statusCode: $statusCode, message: $message)';
}

class ApiService {
  // --- GET ---
  Future<Map<String, dynamic>> get(
      String endpoint, {
        String? token,
      }) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

    _printRequest(
      method: 'GET',
      uri: uri,
      body: {},
      hasToken: token != null && token.trim().isNotEmpty,
    );

    try {
      final http.Response response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          if (token != null && token.trim().isNotEmpty)
            'Authorization': 'Bearer ${token.trim()}',
        },
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on TimeoutException {
      throw _throwTimeout();
    } on SocketException {
      throw _throwSocket();
    } on ApiException {
      rethrow;
    } catch (error, stackTrace) {
      throw _handleUnexpected(error, stackTrace);
    }
  }

  // --- POST ---
  Future<Map<String, dynamic>> post(
      String endpoint, {
        Map<String, dynamic> body = const <String, dynamic>{},
        String? token,
      }) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

    _printRequest(
      method: 'POST',
      uri: uri,
      body: body,
      hasToken: token != null && token.trim().isNotEmpty,
    );

    try {
      final http.Response response = await http
          .post(
        uri,
        headers: _headers(token),
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on TimeoutException {
      throw _throwTimeout();
    } on SocketException {
      throw _throwSocket();
    } on ApiException {
      rethrow;
    } catch (error, stackTrace) {
      throw _handleUnexpected(error, stackTrace);
    }
  }

  // --- POST MULTIPART ---
  Future<Map<String, dynamic>> postMultipart(
      String endpoint, {
        Map<String, String> fields = const <String, String>{},
        Map<String, File> files = const <String, File>{},
        String? token,
      }) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

    _printRequest(
      method: 'POST MULTIPART',
      uri: uri,
      body: fields,
      hasToken: token != null && token.trim().isNotEmpty,
    );

    try {
      final request = http.MultipartRequest('POST', uri);
      
      request.headers.addAll({
        'Accept': 'application/json',
        if (token != null && token.trim().isNotEmpty)
          'Authorization': 'Bearer ${token.trim()}',
      });
      
      request.fields.addAll(fields);
      
      for (final entry in files.entries) {
        request.files.add(
          await http.MultipartFile.fromPath(
            entry.key,
            entry.value.path,
          ),
        );
      }

      final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } on TimeoutException {
      throw _throwTimeout();
    } on SocketException {
      throw _throwSocket();
    } on ApiException {
      rethrow;
    } catch (error, stackTrace) {
      throw _handleUnexpected(error, stackTrace);
    }
  }

  // --- PUT ---
  Future<Map<String, dynamic>> put(
      String endpoint, {
        Map<String, dynamic> body = const <String, dynamic>{},
        String? token,
      }) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

    _printRequest(
      method: 'PUT',
      uri: uri,
      body: body,
      hasToken: token != null && token.trim().isNotEmpty,
    );

    try {
      final http.Response response = await http
          .put(
        uri,
        headers: _headers(token),
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on TimeoutException {
      throw _throwTimeout();
    } on SocketException {
      throw _throwSocket();
    } on ApiException {
      rethrow;
    } catch (error, stackTrace) {
      throw _handleUnexpected(error, stackTrace);
    }
  }

  // --- PATCH ---
  Future<Map<String, dynamic>> patch(
      String endpoint, {
        Map<String, dynamic> body = const <String, dynamic>{},
        String? token,
      }) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

    _printRequest(
      method: 'PATCH',
      uri: uri,
      body: body,
      hasToken: token != null && token.trim().isNotEmpty,
    );

    try {
      final http.Response response = await http
          .patch(
        uri,
        headers: _headers(token),
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on TimeoutException {
      throw _throwTimeout();
    } on SocketException {
      throw _throwSocket();
    } on ApiException {
      rethrow;
    } catch (error, stackTrace) {
      throw _handleUnexpected(error, stackTrace);
    }
  }

  // --- DELETE ---
  Future<Map<String, dynamic>> delete(
      String endpoint, {
        Map<String, dynamic> body = const <String, dynamic>{},
        String? token,
      }) async {
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

    _printRequest(
      method: 'DELETE',
      uri: uri,
      body: body,
      hasToken: token != null && token.trim().isNotEmpty,
    );

    try {
      final http.Response response = await http
          .delete(
        uri,
        headers: _headers(token),
        body: body.isNotEmpty ? jsonEncode(body) : null,
      )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on TimeoutException {
      throw _throwTimeout();
    } on SocketException {
      throw _throwSocket();
    } on ApiException {
      rethrow;
    } catch (error, stackTrace) {
      throw _handleUnexpected(error, stackTrace);
    }
  }

  // --- PRIVATE HELPERS ---

  Map<String, String> _headers(String? token) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.trim().isNotEmpty)
        'Authorization': 'Bearer ${token.trim()}',
    };
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final bool isSuccessful =
        response.statusCode >= 200 && response.statusCode < 300;
    Map<String, dynamic> data = {};

    if (response.body.trim().isNotEmpty) {
      try {
        final dynamic decoded = jsonDecode(response.body);
        data = decoded is Map
            ? Map<String, dynamic>.from(decoded)
            : {'data': decoded};
      } on FormatException {
        _printRawResponse(response: response, isSuccessful: isSuccessful);
        throw ApiException(
          statusCode: response.statusCode,
          message: 'Server returned an invalid JSON response.',
          data: {'rawBody': response.body},
        );
      }
    }

    _printResponse(response: response, data: data, isSuccessful: isSuccessful);

    if (isSuccessful) return data;

    throw ApiException(
      statusCode: response.statusCode,
      message: data['message']?.toString() ?? 'Request failed.',
      errors: data['errors'] is Map
          ? Map<String, dynamic>.from(data['errors'])
          : null,
      data: data,
    );
  }

  void _printRequest({
    required String method,
    required Uri uri,
    required Map<String, dynamic> body,
    required bool hasToken,
  }) {
    if (!kDebugMode) return;
    debugPrint('\n========== API REQUEST ==========');
    debugPrint('--> METHOD: $method');
    debugPrint('--> URL: $uri');
    debugPrint('--> TOKEN: ${hasToken ? 'PRESENT' : 'NOT PRESENT'}');
    if (body.isNotEmpty) _printJson('--> BODY', _redactSensitiveData(body));
    debugPrint('=================================');
  }

  void _printResponse({
    required http.Response response,
    required Map<String, dynamic> data,
    required bool isSuccessful,
  }) {
    if (!kDebugMode) return;
    debugPrint('\n========== API RESPONSE =========');
    debugPrint('<-- RESULT: ${isSuccessful ? 'SUCCESS' : 'ERROR'}');
    debugPrint('<-- STATUS: ${response.statusCode}');
    _printJson('<-- DATA', _redactSensitiveData(data));
    debugPrint('=================================');
  }

  void _printRawResponse(
      {required http.Response response, required bool isSuccessful}) {
    if (!kDebugMode) return;
    debugPrint('\n========== API RESPONSE =========');
    debugPrint('<-- RESULT: ${isSuccessful ? 'SUCCESS' : 'ERROR'}');
    debugPrint('<-- STATUS: ${response.statusCode}');
    debugPrint('<-- RAW BODY:\n${response.body}');
    debugPrint('=================================');
  }

  void _printException(ApiException exception) {
    if (!kDebugMode) return;
    debugPrint('\n========== API ERROR ============');
    debugPrint('<-- STATUS: ${exception.statusCode}');
    debugPrint('<-- MESSAGE: ${exception.message}');
    debugPrint('=================================');
  }

  void _printJson(String label, dynamic value) {
    if (!kDebugMode) return;
    try {
      debugPrint('$label:\n${const JsonEncoder.withIndent('  ').convert(value)}');
    } catch (_) {
      debugPrint('$label: $value');
    }
  }

  ApiException _throwTimeout() {
    const ex = ApiException(
        statusCode: 408, message: 'Connection timed out. Please try again.');
    _printException(ex);
    return ex;
  }

  ApiException _throwSocket() {
    const ex = ApiException(
        statusCode: 0, message: 'Cannot connect to the Laravel server.');
    _printException(ex);
    return ex;
  }

  ApiException _handleUnexpected(dynamic error, StackTrace stack) {
    if (kDebugMode) {
      debugPrint('<-- UNEXPECTED ERROR: $error');
      debugPrintStack(stackTrace: stack);
    }
    return const ApiException(
        statusCode: 0, message: 'Unexpected connection error.');
  }

  dynamic _redactSensitiveData(dynamic value) {
    if (value is Map) {
      final Map<String, dynamic> result = {};
      value.forEach((key, item) {
        final normalizedKey =
        key.toString().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
        result[key.toString()] = _sensitiveKeys.contains(normalizedKey)
            ? _redactedValue(item)
            : _redactSensitiveData(item);
      });
      return result;
    }
    if (value is Iterable) return value.map(_redactSensitiveData).toList();
    return value;
  }

  String _redactedValue(dynamic value) =>
      (value is String && value.isNotEmpty)
          ? '[REDACTED: ${value.length} characters]'
          : '[REDACTED]';

  static const Set<String> _sensitiveKeys = {
    'password',
    'passwordconfirmation',
    'token',
    'accesstoken',
    'refreshtoken',
    'authorization',
    'cookie',
    'setcookie',
    'jwtsecret',
    'otp',
    'emailotphash'
  };
}
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import 'network_exceptions.dart';

class ApiClient {
  // Singleton instance
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final http.Client _client = http.Client();
  final Duration _timeout = const Duration(seconds: 20);

  /// ----------------------------------------------------------
  /// 1. HELPER: Get Standard Headers
  /// ----------------------------------------------------------
  Map<String, String> _getHeaders({Map<String, String>? extraHeaders}) {
    final lang = Get.locale?.languageCode ?? 'bn';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Language': lang, // Auto-injects current language
    };
    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }
    return headers;
  }

  /// ----------------------------------------------------------
  /// 2. METHOD: GET Request
  /// ----------------------------------------------------------
  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    try {
      final uri = Uri.parse(url);
      final finalHeaders = _getHeaders(extraHeaders: headers);

      _logRequest('GET', url, finalHeaders); // LOGGING

      final response = await _client
          .get(uri, headers: finalHeaders)
          .timeout(_timeout);

      _logResponse(url, response.statusCode, response.body); // LOGGING

      return _processResponse(response);
    } catch (e) {
      _logError(url, e);
      throw _handleError(e);
    }
  }

  /// ----------------------------------------------------------
  /// 3. METHOD: POST Request
  /// ----------------------------------------------------------
  Future<dynamic> post(String url, {dynamic body, Map<String, String>? headers}) async {
    try {
      final uri = Uri.parse(url);
      final finalHeaders = _getHeaders(extraHeaders: headers);

      _logRequest('POST', url, finalHeaders, body: body);

      final response = await _client
          .post(uri, headers: finalHeaders, body: jsonEncode(body))
          .timeout(_timeout);

      _logResponse(url, response.statusCode, response.body);

      return _processResponse(response);
    } catch (e) {
      _logError(url, e);
      throw _handleError(e);
    }
  }

  /// ----------------------------------------------------------
  /// 4. METHOD: GET RAW (For HTML/Text responses like Station Data)
  /// ----------------------------------------------------------
  Future<String> getRaw(String url) async {
    try {
      final uri = Uri.parse(url);
      // We don't send 'Accept: json' here because we expect text/html
      final headers = {'Accept-Language': Get.locale?.languageCode ?? 'bn'};

      _logRequest('GET RAW', url, headers);

      final response = await _client.get(uri, headers: headers).timeout(_timeout);

      _logResponse(url, response.statusCode, "Raw Content (Length: ${response.body.length})");

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw NetworkExceptions.handleResponseError(response.statusCode);
      }
    } catch (e) {
      _logError(url, e);
      throw _handleError(e);
    }
  }

  // [NEW] Add DELETE method
  Future<dynamic> delete(String url, {Map<String, String>? headers}) async {
    try {
      final response = await http.delete(Uri.parse(url), headers: headers);
      return _processResponse(response);
    } catch (e) {
      print("Delete Error: $e");
      return null;
    }
  }

  // [NEW] Add Multipart POST (For Image Upload)
  Future<dynamic> postMultipart(
      String url, {
        required Map<String, String> fields,
        required Map<String, String> headers,
        File? file,
        String? fileKey, // e.g., 'photo'
      }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add Headers
      request.headers.addAll(headers);

      // Add Text Fields
      fields.forEach((key, value) {
        request.fields[key] = value;
      });

      // Add File
      if (file != null && fileKey != null) {
        var stream = http.ByteStream(file.openRead());
        var length = await file.length();
        var multipartFile = http.MultipartFile(
          fileKey,
          stream,
          length,
          filename: file.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      // Send
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      return _processResponse(response);
    } catch (e) {
      print("Multipart Error: $e");
      return null;
    }
  }

  // ... _processResponse helper ...
  dynamic _processResponse(http.Response response) {
    // Basic handler provided in previous steps, ensure it returns decoded JSON
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      // You might want to handle 401 specific logic here or return the error body
      try {
        return jsonDecode(response.body);
      } catch(_) {
        return {'statusCode': response.statusCode, 'error': response.reasonPhrase};
      }
    }
  }

  /// ----------------------------------------------------------
  /// Internal Helpers

  String _handleError(dynamic error) {
    // Return a friendly string message to the controller
    return NetworkExceptions.getErrorMessage(error);
  }

  /// ----------------------------------------------------------
  /// Logging (Replaces Interceptor)
  /// ----------------------------------------------------------
  void _logRequest(String method, String url, Map headers, {dynamic body}) {
    log("🔵 [API] $method: $url");
    log("   Headers: $headers");
    if (body != null) log("   Body: $body");
  }

  void _logResponse(String url, int statusCode, String body) {
    log("🟢 [API] $statusCode: $url");
    // Print first 200 chars to avoid console flooding
    log("   Response: ${body.length > 200 ? '${body.substring(0, 200)}...' : body}");
  }

  void _logError(String url, dynamic error) {
    log("🔴 [API] ERROR: $url");
    log("   Details: $error");
  }

  /// ----------------------------------------------------------
  Future<Uint8List?> getRawBytes(String url) async {
    try {
      final uri = Uri.parse(url);
      final response = await _client.get(uri).timeout(_timeout);
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';

class ApiService {
  Future<Map<String, dynamic>> post(
      String endpoint, {
        required Map<String, dynamic> body,
        String? token,
      }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

    try {
      debugPrint('--> POST $uri');
      debugPrint('--> BODY: ${jsonEncode(body)}');

      final response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 30));

      debugPrint('<-- STATUS: ${response.statusCode}');
      debugPrint('<-- BODY: ${response.body}');

      final Map<String, dynamic> data = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : {};

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      }

      throw Exception(data['message'] ?? 'Request failed.');
    } catch (error) {
      debugPrint('LOGIN API ERROR: $error');
      rethrow;
    }
  }
}
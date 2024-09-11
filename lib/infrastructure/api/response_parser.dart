import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiResponseParser {
  static String parseErrorMessage(http.Response response) {
    try {
      final body = json.decode(response.body);
      return body['error'] ?? body['message'] ?? 'Unknown error occurred';
    } catch (_) {
      return 'Error: ${response.statusCode}';
    }
  }
}

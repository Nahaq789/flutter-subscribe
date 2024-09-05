import 'dart:convert';

import 'package:flutter_guid/flutter_guid.dart';

class ApiRequestBuilder {
  static Map<String, String> buildHeaders(
      {Map<String, String>? additionalHeader}) {
    Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-requestId': Guid.newGuid.toString()
    };

    if (additionalHeader != null) {
      header.addAll(additionalHeader);
    }
    return header;
  }

  static String buildRequestBody(Map<String, dynamic> data) {
    return jsonEncode(data);
  }
}

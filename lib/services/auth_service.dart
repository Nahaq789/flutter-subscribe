import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:subscribe/models/login_model.dart';
import 'package:subscribe/models/token_model.dart';
import 'package:subscribe/services/auth_i_service.dart';
import 'package:http/http.dart' as http;

class AuthService implements IAuthService {
  @override
  Future<TokenModel> login({required LoginModel model}) async {
    String baseURL = dotenv.get('API_URL');
    String endpointURL = '${baseURL}Auth/login';

    final response = await http.post(Uri.parse('${baseURL}Auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-requestId': Guid.newGuid.toString()
        },
        body: jsonEncode(<String, String>{
          'email': model.email,
          'password': model.password
        }));

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodeRes = json.decode(response.body);
      print('Login success with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Response headers: ${response.headers}');
      return TokenModel.fromJson(decodeRes);
    } else {
      print('Login failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Response headers: ${response.headers}');
      throw Exception('Login failed: ${response.statusCode}');
    }
  }
}

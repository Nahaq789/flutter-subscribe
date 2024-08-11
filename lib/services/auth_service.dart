import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:subscribe/exceptions/auth_exception.dart';
import 'package:subscribe/models/login_model.dart';
import 'package:subscribe/models/token_model.dart';
import 'package:subscribe/services/auth_i_service.dart';
import 'package:http/http.dart' as http;
import 'package:subscribe/services/token_storage_i_service.dart';

class AuthService implements IAuthService {
  late final ITokenStorageService _tokenStorageService;

  AuthService(this._tokenStorageService);

  @override
  Future<TokenModel> login({required LoginModel model}) async {
    String baseURL = dotenv.get('API_URL');
    try {
      final response = await http
          .post(Uri.parse('${baseURL}Auth/login'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'x-requestId': Guid.newGuid.toString()
              },
              body: jsonEncode(<String, String>{
                'email': model.email,
                'password': model.password
              }))
          .timeout(const Duration(seconds: 10));

      final Map<String, dynamic> decodeRes = json.decode(response.body);

      if (response.statusCode == 200) {
        await _tokenStorageService.saveToken(
            token: TokenModel.fromJson(decodeRes));
        return TokenModel.fromJson(decodeRes);
      }
      if (response.statusCode == 401) {
        if (decodeRes['detail'] != null &&
            decodeRes['title'] == 'Unauthorized') {
          return TokenModel(
              success: false,
              errorMessage: 'Login failed. Incorrect email or password.');
        }
        throw AuthException('Authentication failed', 401);
      }
      throw HttpException('HTTP Error: ${response.statusCode}');
    } on SocketException catch (e) {
      FirebaseCrashlytics.instance
          .recordError(e, StackTrace.current, reason: 'Network error');
      return TokenModel(
          errorMessage:
              'A network error occurred. Please check your connection.');
    } on TimeoutException catch (e) {
      FirebaseCrashlytics.instance
          .recordError(e, StackTrace.current, reason: 'Request timeout');
      return TokenModel(
          errorMessage:
              'The server is not responding. Please try again later.');
    } on FormatException catch (e) {
      FirebaseCrashlytics.instance
          .recordError(e, StackTrace.current, reason: 'Response parsing error');
      return TokenModel(errorMessage: 'Unable to process the server response.');
    } catch (e, stack) {
      FirebaseCrashlytics.instance
          .recordError(e, stack, reason: 'Unexpected error during login');
      return TokenModel(
          errorMessage:
              'An unexpected error occurred. Please try again later.');
    }
  }
}

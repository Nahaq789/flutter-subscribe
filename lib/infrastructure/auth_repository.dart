import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:subscribe/domain/models/login_model.dart';
import 'package:subscribe/domain/repository/auth_i_repository.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:flutter_guid/flutter_guid.dart';
import 'package:subscribe/exceptions/auth_exception.dart';

class AuthRepository implements IAuthRepository {
  final String baseURL = dotenv.get('API_URL');

  @override
  Future<Response> authenticate({required LoginModel model}) async {
    try {
      final response = await http
          .post(Uri.parse('${baseURL}auth/signin'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'x-requestId': Guid.newGuid.toString()
              },
              body: jsonEncode(<String, String>{
                'email': model.email,
                'password': model.password,
                'verify_code': ""
              }))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return response;
      }
      if (response.statusCode == 401) {
        throw AuthException('Authentication failed: ${response.body}', 401);
      }
      throw HttpException('HTTP Error: ${response.statusCode}');
    } on SocketException catch (e) {
      FirebaseCrashlytics.instance
          .recordError(e, StackTrace.current, reason: 'Network error');
      throw AuthException(
          'A network error occurred. Please check your connection.', 500);
    } on TimeoutException catch (e) {
      FirebaseCrashlytics.instance
          .recordError(e, StackTrace.current, reason: 'Request timeout');
      throw AuthException(
          'The server is not responding. Please try again later.', 500);
    } on FormatException catch (e) {
      FirebaseCrashlytics.instance
          .recordError(e, StackTrace.current, reason: 'Response parsing error');
      throw AuthException('Unable to process the server response.', 500);
    } catch (e, stack) {
      FirebaseCrashlytics.instance
          .recordError(e, stack, reason: 'Unexpected error during login');
      throw AuthException(
          'An unexpected error occurred. Please try again later.', 500);
    }
  }

  @override
  Future registerAccount({required LoginModel model}) async {
    try {
      final response = await http
          .post(Uri.parse('${baseURL}auth/signin'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'x-requestId': Guid.newGuid.toString()
              },
              body: jsonEncode(<String, String>{
                'email': model.email,
                'password': model.password
              }))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return response;
      }
      if (response.statusCode == 401) {
        throw AuthException('Authentication failed: ${response.body}', 401);
      }
      throw HttpException('HTTP Error: ${response.statusCode}');
    } on SocketException catch (e) {
      FirebaseCrashlytics.instance
          .recordError(e, StackTrace.current, reason: 'Network error');
      throw AuthException(
          'A network error occurred. Please check your connection.', 500);
    } on TimeoutException catch (e) {
      FirebaseCrashlytics.instance
          .recordError(e, StackTrace.current, reason: 'Request timeout');
      throw AuthException(
          'The server is not responding. Please try again later.', 500);
    } on FormatException catch (e) {
      FirebaseCrashlytics.instance
          .recordError(e, StackTrace.current, reason: 'Response parsing error');
      throw AuthException('Unable to process the server response.', 500);
    } catch (e, stack) {
      FirebaseCrashlytics.instance
          .recordError(e, stack, reason: 'Unexpected error during login');
      throw AuthException(
          'An unexpected error occurred. Please try again later.', 500);
    }
  }
}

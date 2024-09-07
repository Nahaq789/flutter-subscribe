import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:subscribe/adapter/firebase/crashlytics_i_service.dart';
import 'package:subscribe/domain/models/login_model.dart';
import 'package:subscribe/domain/repository/auth_i_repository.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_guid/flutter_guid.dart';
import 'package:subscribe/exceptions/api_exception.dart';
import 'package:subscribe/exceptions/auth_exception.dart';
import 'package:subscribe/infrastructure/api/request_builder.dart';
import 'package:subscribe/infrastructure/error/api_error_handler.dart';

class AuthRepository implements IAuthRepository {
  late final ICrashlyticsService _crashlyticsService;
  late final ApiErrorHandler _apiErrorHandler;
  final String baseURL = dotenv.get('API_URL');

  AuthRepository(this._crashlyticsService)
      : _apiErrorHandler = ApiErrorHandler(_crashlyticsService);

  @override
  Future<Response> authenticate({required LoginModel model}) async {
    try {
      final response = await http
          .post(Uri.parse('${baseURL}auth/signin'),
              headers: ApiRequestBuilder.buildHeaders(),
              body: ApiRequestBuilder.buildRequestBody(<String, String>{
                'email': model.email,
                'password': model.password,
                'verify_code': ""
              }))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == HttpStatus.ok) {
        await _crashlyticsService.log(response.body);
        return response;
      }

      if (response.statusCode == HttpStatus.unauthorized) {
        await _apiErrorHandler.handleException(
            AuthException(), 'Authenticate failed', HttpStatus.unauthorized);
      }

      throw ApiException(
          'HTTP Error: ${response.statusCode}', response.statusCode);
    } on SocketException catch (e) {
      await _apiErrorHandler.handleException(
          e, 'Network error', HttpStatus.serviceUnavailable);
      rethrow;
    } on TimeoutException catch (e) {
      await _apiErrorHandler.handleException(
          e, 'Request timeout', HttpStatus.requestTimeout);
      rethrow;
    } on FormatException catch (e) {
      await _apiErrorHandler.handleException(
          e, 'Response parsing error', HttpStatus.internalServerError);
      rethrow;
    } catch (e, stack) {
      await _crashlyticsService.recordError(e, stack,
          reason: 'Unexpected error during login');
      rethrow;
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
      if (response.statusCode == HttpStatus.unauthorized) {
        throw AuthException(message: response.body, statusCode: 401);
      }
      throw HttpException('HTTP Error: ${response.statusCode}');
    } on SocketException catch (e) {
      await _crashlyticsService.recordError(e, StackTrace.current,
          reason: 'Network error');
      await _crashlyticsService
          .log('A network error occurred. Please check your connection.');
      throw AuthException(
          message: 'A network error occurred. Please check your connection.',
          statusCode: 500);
    } on TimeoutException catch (e) {
      await _crashlyticsService.recordError(e, StackTrace.current,
          reason: 'Request timeout');
      throw AuthException(
          message: 'The server is not responding. Please try again later.',
          statusCode: 500);
    } on FormatException catch (e) {
      await _crashlyticsService.recordError(e, StackTrace.current,
          reason: 'Parsing error');
      throw AuthException(
          message: 'Unable to process the server response.', statusCode: 500);
    } catch (e, stack) {
      await _crashlyticsService.recordError(e, stack,
          reason: 'Unexpected error during login');
      rethrow;
    }
  }
}

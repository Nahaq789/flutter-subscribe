import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:subscribe/adapter/firebase/crashlytics_i_service.dart';
import 'package:subscribe/domain/models/auth_user_model.dart';
import 'package:subscribe/domain/repository/auth_i_repository.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:io';

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
  Future<Response> authenticate({required AuthUserModel model}) async {
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

      await _apiErrorHandler.handleException(
          ApiException(), response.body, response.statusCode);
      throw ApiException(
          message: 'HTTP Error: ${response.statusCode}',
          statusCode: response.statusCode);
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
  Future<Response> registerAccount({required AuthUserModel model}) async {
    try {
      final response = await http
          .post(Uri.parse('${baseURL}auth/signup'),
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
      _apiErrorHandler.handleException(
          ApiException(), response.body, response.statusCode);
      throw ApiException();
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
          reason: 'Unexpected error during signup');
      rethrow;
    }
  }

  @override
  Future<Response> confirmCode({required AuthUserModel model}) async {
    try {
      final response = await http
          .post(Uri.parse('${baseURL}auth/confirm'),
              headers: ApiRequestBuilder.buildHeaders(),
              body: ApiRequestBuilder.buildRequestBody(<String, String>{
                'email': model.email,
                'password': model.password,
                'verify_code': model.verifyCode
              }))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == HttpStatus.ok) {
        await _crashlyticsService.log(response.body);
        return response;
      }
      await _apiErrorHandler.handleException(
          ApiException(), response.body, response.statusCode);
      throw ApiException();
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
          reason: 'Unexpected error during signup');
      rethrow;
    }
  }
}

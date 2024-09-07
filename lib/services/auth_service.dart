import 'dart:async';
import 'dart:convert';

import 'package:subscribe/domain/models/token_model.dart';
import 'package:subscribe/domain/repository/auth_i_repository.dart';
import 'package:subscribe/domain/repository/token_i_repository.dart';
import 'package:subscribe/domain/models/login_model.dart';
import 'package:subscribe/exceptions/api_exception.dart';
import 'package:subscribe/presentation/dto/auth_request.dart';
import 'package:subscribe/presentation/dto/auth_response.dart';
import 'package:subscribe/services/auth_i_service.dart';

class AuthService implements IAuthService {
  late final ITokenRepository _tokenRepository;
  late final IAuthRepository _authRepository;

  AuthService(this._authRepository, this._tokenRepository);

  @override
  Future<AuthResponse> login({required AuthRequest auth}) async {
    try {
      final loginModel = LoginModel(email: auth.email, password: auth.password);
      final response = await _authRepository.authenticate(model: loginModel);
      final Map<String, dynamic> decodeRes = json.decode(response.body);

      await _tokenRepository.saveToken(token: TokenModel.fromJson(decodeRes));

      return AuthResponse(isAuth: true, errorMessage: "", statusCode: 200);
    } on ApiException catch (e) {
      return AuthResponse(
          isAuth: false, errorMessage: e.message, statusCode: e.statusCode);
    }
  }

  @override
  Future<void> registerAccount({required AuthRequest auth}) async {
    try {} catch (e) {}
  }
}

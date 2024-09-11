import 'package:subscribe/presentation/dto/auth_request.dart';
import 'package:subscribe/presentation/dto/auth_response.dart';

abstract interface class IAuthService {
  Future<AuthResponse> login({required AuthRequest auth});
  Future<AuthResponse> registerAccount({required AuthRequest auth});
  Future<AuthResponse> confirmCode({required AuthRequest auth});
}

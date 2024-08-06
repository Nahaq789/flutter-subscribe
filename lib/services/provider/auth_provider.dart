import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:subscribe/services/auth_i_service.dart';
import 'package:subscribe/services/auth_service.dart';

final authServiceProvider = Provider<IAuthService>((ref) {
  return AuthService();
});

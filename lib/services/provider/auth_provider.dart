import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:subscribe/infrastructure/provider/auth_repository_provider.dart';
import 'package:subscribe/infrastructure/provider/token_repository_provider.dart';
import 'package:subscribe/services/auth_i_service.dart';
import 'package:subscribe/services/auth_service.dart';

final authServiceProvider = Provider<IAuthService>((ref) {
  final tokenRepository = ref.watch(tokenRepositoryProvider);
  final authRepository = ref.watch(authRepositoryProvider);

  return AuthService(authRepository, tokenRepository);
});

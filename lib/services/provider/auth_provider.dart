import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:subscribe/services/auth_i_service.dart';
import 'package:subscribe/services/auth_service.dart';
import 'package:subscribe/services/provider/token_storage_provider.dart';

final authServiceProvider = Provider<IAuthService>((ref) {
  final tokenStorageService = ref.watch(tokenStorageProvider);
  return AuthService(tokenStorageService);
});

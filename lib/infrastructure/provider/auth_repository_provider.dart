import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subscribe/domain/repository/auth_i_repository.dart';
import 'package:subscribe/infrastructure/auth_repository.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository();
});

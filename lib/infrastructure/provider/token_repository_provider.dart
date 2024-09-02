import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subscribe/domain/repository/token_i_repository.dart';
import 'package:subscribe/infrastructure/token_repository.dart';

final tokenRepositoryProvider = Provider<ITokenRepository>((ref) {
  return TokenRepository();
});

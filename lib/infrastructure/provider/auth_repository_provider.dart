import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subscribe/adapter/firebase/provider/crashlytics_provider.dart';
import 'package:subscribe/domain/repository/auth_i_repository.dart';
import 'package:subscribe/infrastructure/repository/auth_repository.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final crashlyticsService = ref.watch(carshlyticsProvider);
  return AuthRepository(crashlyticsService);
});

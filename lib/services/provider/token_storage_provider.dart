import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subscribe/services/token_storage_i_service.dart';
import 'package:subscribe/services/token_storage_service.dart';

final tokenStorageProvider = Provider<ITokenStorageService>((ref) {
  return TokenStorageService();
});

import 'package:subscribe/domain/models/token_model.dart';

abstract interface class ITokenStorageService {
  Future<void> saveToken({required TokenModel token});
}

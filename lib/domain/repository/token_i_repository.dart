import 'package:subscribe/domain/models/token_model.dart';

abstract interface class ITokenRepository {
  Future<void> saveToken({required TokenModel token});
}

import 'package:subscribe/domain/models/login_model.dart';
import 'package:subscribe/domain/models/token_model.dart';

abstract interface class IAuthService {
  Future<TokenModel> login({required LoginModel model});
  Future registerAccount({required LoginModel model});
}

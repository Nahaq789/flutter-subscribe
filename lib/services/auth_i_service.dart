import 'package:subscribe/models/login_model.dart';
import 'package:subscribe/models/token_model.dart';

abstract interface class IAuthService {
  Future<TokenModel> login({required LoginModel model});
}

import 'package:http/http.dart';
import 'package:subscribe/domain/models/auth_user_model.dart';

abstract interface class IAuthRepository {
  Future<Response> authenticate({required AuthUserModel model});
  Future registerAccount({required AuthUserModel model});
  Future<Response> confirmCode({required AuthUserModel model});
}

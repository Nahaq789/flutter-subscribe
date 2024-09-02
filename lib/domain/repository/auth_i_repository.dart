import 'package:http/http.dart';
import 'package:subscribe/domain/models/login_model.dart';

abstract interface class IAuthRepository {
  Future<Response> authenticate({required LoginModel model});
  Future registerAccount({required LoginModel model});
}

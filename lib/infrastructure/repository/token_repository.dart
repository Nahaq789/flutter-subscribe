import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subscribe/domain/models/token_model.dart';
import 'package:subscribe/domain/repository/token_i_repository.dart';

class TokenRepository implements ITokenRepository {
  @override
  Future<void> saveToken({required TokenModel token}) async {
    try {
      if (token.jwt != null && token.refreshToken != null) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString('jwt', token.jwt as String);
        await pref.setString('refresh_token', token.refreshToken as String);
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance
          .recordError(e, stack, reason: "Can not save token");
      throw Exception(e);
    }
  }
}

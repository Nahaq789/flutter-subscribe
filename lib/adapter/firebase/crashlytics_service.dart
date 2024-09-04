import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:subscribe/adapter/firebase/crashlytics_i_service.dart';

class CrashlyticsService implements ICrashlyticsService {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  @override
  Future<void> log(String message) async {
    await _crashlytics.log(message);
  }

  @override
  Future<void> recordError(exception, StackTrace stack,
      {String? reason}) async {
    await _crashlytics.recordError(exception, stack, reason: reason);
  }

  @override
  Future<void> setCustomKey(String key, value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  @override
  Future<void> recordNonFatalError(String message, String code) async {
    await _crashlytics.recordError(Exception(message), null,
        reason: 'Non-fetal error', fatal: false);
    await _crashlytics.log('Error code: $code');
  }
}

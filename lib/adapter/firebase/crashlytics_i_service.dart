abstract interface class ICrashlyticsService {
  Future<void> recordError(dynamic exception, StackTrace stack,
      {String? reason});
  Future<void> log(String message);
  Future<void> setCustomKey(String key, dynamic value);
  Future<void> recordNonFatalError(String message, String code);
}

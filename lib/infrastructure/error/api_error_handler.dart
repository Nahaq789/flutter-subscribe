import 'package:subscribe/adapter/firebase/crashlytics_i_service.dart';
import 'package:subscribe/exceptions/api_exception.dart';
import 'package:subscribe/infrastructure/error/repository_error_message_generator.dart';

class ApiErrorHandler {
  final ICrashlyticsService _crashlyticsService;

  ApiErrorHandler(this._crashlyticsService);

  Future<void> handleException(Exception? e, String reason, int statusCode) {
    _crashlyticsService.recordError(e, StackTrace.current, reason: reason);
    final userMessage =
        RepositoryErrorMessageGenerator.generateUserFriendlyMessage(statusCode);
    _crashlyticsService.log(userMessage);
    throw ApiException(message: userMessage, statusCode: statusCode);
  }
}

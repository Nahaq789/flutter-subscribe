import 'dart:io';

class RepositoryErrorMessageGenerator {
  static String generateUserFriendlyMessage(int statusCode) {
    switch (statusCode) {
      case HttpStatus.unauthorized:
        return 'Authentication failed. Please check your credentials and try again.';
      case HttpStatus.forbidden:
        return 'You do not have permission to access this resource.';
      case HttpStatus.notFound:
        return 'The requested resource was not found.';
      case HttpStatus.serviceUnavailable:
        return 'The service is currently unavailable. Please try again later.';
      case HttpStatus.requestTimeout:
        return 'The request timed out. Please check your connection and try again.';
      default:
        return 'An unexpected error occurred. Please try again later.';
    }
  }
}

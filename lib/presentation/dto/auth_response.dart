/// Represents the response from an authentication attempt.
///
/// This class encapsulates the result of an authentication operation,
/// including a success indicator and any error message that may have occurred.
class AuthResponse {
  /// Indicates whether the authentication was successful.
  ///
  /// `true` if the authentication succeeded, `false` otherwise.
  final bool isAuth;

  /// An error message describing any issues that occurred during authentication.
  ///
  /// This field may be empty if the authentication was successful.
  final String errorMessage;

  /// An error status code.
  final int statusCode;

  /// Creates a new [AuthResponse] instance.
  ///
  /// Both [isAuth] and [errorMessage] are required parameters.
  ///
  /// Example:
  /// ```dart
  /// var response = AuthResponse(isAuth: true, errorMessage: '');
  /// var errorResponse = AuthResponse(isAuth: false, errorMessage: 'Invalid credentials');
  /// ```
  AuthResponse(
      {required this.isAuth,
      required this.errorMessage,
      required this.statusCode});
}

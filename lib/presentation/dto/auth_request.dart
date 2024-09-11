/// Represents an authentication request.
///
/// This class encapsulates the data required for user authentication,
/// including email and password. It also has an optional verification code
/// field that can be used for two-factor authentication or similar purposes.
class AuthRequest {
  /// The email address of the user attempting to authenticate.
  String email;

  /// The password for the user's account.
  String password;

  /// An optional verification code for two-factor authentication.
  ///
  /// This field can be null if not used in the authentication process.
  String verifyCode;

  /// Creates a new [AuthRequest] instance.
  ///
  /// [email] and [password] are required parameters.
  /// [verifyCode] is optional and can be omitted if not needed.
  ///
  /// Example:
  /// ```dart
  /// var request = AuthRequest(email: 'user@example.com', password: 'securepass');
  /// ```
  AuthRequest(
      {required this.email, required this.password, required this.verifyCode});
}

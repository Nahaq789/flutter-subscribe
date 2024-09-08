class AuthUserModel {
  String password;
  String email;
  String verifyCode;
  AuthUserModel(
      {required this.email, required this.password, required this.verifyCode});
}

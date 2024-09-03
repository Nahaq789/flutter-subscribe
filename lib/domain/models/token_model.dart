class TokenModel {
  bool success;
  String? jwt;
  String? refreshToken;
  String? errorMessage;

  TokenModel(
      {this.success = false, this.jwt, this.refreshToken, this.errorMessage});

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      jwt: json['token'],
      refreshToken: json['refreshToken'],
    );
  }
}

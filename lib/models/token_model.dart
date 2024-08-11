class TokenModel {
  bool success;
  String? jwt;
  String? refreshToken;
  String? errorMessage;

  TokenModel(
      {this.success = false, this.jwt, this.refreshToken, this.errorMessage});

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
        success: json['success'],
        jwt: json['token'].toString(),
        refreshToken: json['refreshToken'],
        errorMessage: json['errorMessage']);
  }
}

class TokenModel {
  String? jwt;
  String? refreshToken;

  TokenModel({this.jwt, this.refreshToken});

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(jwt: json['jwt'], refreshToken: json['refreshToken']);
  }
}

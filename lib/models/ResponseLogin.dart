import 'dart:convert';

class ResponseLogin {
  String code;
  String message;
  Data data;

  ResponseLogin({
    required this.code,
    required this.message,
    required this.data,
  });

  factory ResponseLogin.fromRawJson(String str) => ResponseLogin.fromJson(json.decode(str));
  factory ResponseLogin.fromJson(Map<String, dynamic> json) => ResponseLogin(

    code: json["code"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

}

class Data {
  User user;

  Data({
    required this.user,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: User.fromJson(json["user"]),
  );

}

class User {
  String name;
  String apiKey;
  String rol;

  User({
    required this.name,
    required this.apiKey,
    required this.rol,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    apiKey: json["apiKey"],
    rol: json["rol"],
  );

}

import 'dart:convert';

class ResponseError {
  int status;
  String message;
  DateTime timestamp;
  String description;

  ResponseError({
    required this.status,
    required this.message,
    required this.timestamp,
    required this.description,
  });

  factory ResponseError.fromRawJson(String str) => ResponseError.fromJson(json.decode(str));

  factory ResponseError.fromJson(Map<String, dynamic> json) => ResponseError(
    status: json["status"],
    message: json["message"],
    timestamp: DateTime.parse(json["timestamp"]),
    description: json["description"],
  );

}

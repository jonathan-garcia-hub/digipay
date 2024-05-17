import 'dart:convert';

class ResponseTransactions {
  int id;
  DateTime tranDate;
  String serial;
  String taxId;
  String mit;
  String lotNumber;
  int affiliationId;
  String applicationIdentifier;
  String applicationLabel;
  String upn;
  String d002;
  String d003;
  String d004;
  String d007;
  String d011;
  String d012;
  String d022;
  String d024;
  String d037;
  String d038;
  String d039;
  String d041;
  String d042;
  DateTime tranDateResp;
  String receipt;

  ResponseTransactions({
    required this.id,
    required this.tranDate,
    required this.serial,
    required this.taxId,
    required this.mit,
    required this.lotNumber,
    required this.affiliationId,
    required this.applicationIdentifier,
    required this.applicationLabel,
    required this.upn,
    required this.d002,
    required this.d003,
    required this.d004,
    required this.d007,
    required this.d011,
    required this.d012,
    required this.d022,
    required this.d024,
    required this.d037,
    required this.d038,
    required this.d039,
    required this.d041,
    required this.d042,
    required this.tranDateResp,
    required this.receipt,
  });

  factory ResponseTransactions.fromRawJson(String str) => ResponseTransactions.fromJson(json.decode(str));

  factory ResponseTransactions.fromJson(Map<String, dynamic> json) => ResponseTransactions(
    id: json["id"],
    tranDate: DateTime.parse(json["tranDate"]),
    serial: json["serial"],
    taxId: json["taxId"],
    mit: json["mit"],
    lotNumber: json["lotNumber"],
    affiliationId: json["affiliationId"],
    applicationIdentifier: json["applicationIdentifier"],
    applicationLabel: json["applicationLabel"],
    upn: json["upn"],
    d002: json["d002"],
    d003: json["d003"],
    d004: json["d004"],
    d007: json["d007"],
    d011: json["d011"],
    d012: json["d012"],
    d022: json["d022"],
    d024: json["d024"],
    d037: json["d037"],
    d038: json["d038"],
    d039: json["d039"],
    d041: json["d041"],
    d042: json["d042"],
    tranDateResp: DateTime.parse(json["tranDateResp"]),
    receipt: json["receipt"],
  );

}

import 'dart:convert';

class ResponseLoteDetails {
  int id;
  DateTime tranDate;
  String serial;
  String taxId;
  String mit;
  String lotNumber;
  int affiliationId;
  String upn;
  String d003;
  String d007;
  String d011;
  String d012;
  String d024;
  String d037;
  String d039;
  String d041;
  String d042;
  DateTime tranDateResp;
  String receipt;

  ResponseLoteDetails({
    required this.id,
    required this.tranDate,
    required this.serial,
    required this.taxId,
    required this.mit,
    required this.lotNumber,
    required this.affiliationId,
    required this.upn,
    required this.d003,
    required this.d007,
    required this.d011,
    required this.d012,
    required this.d024,
    required this.d037,
    required this.d039,
    required this.d041,
    required this.d042,
    required this.tranDateResp,
    required this.receipt,
  });

  factory ResponseLoteDetails.fromRawJson(String str) => ResponseLoteDetails.fromJson(json.decode(str));

  factory ResponseLoteDetails.fromJson(Map<String, dynamic> json) => ResponseLoteDetails(
    id: json["id"],
    tranDate: DateTime.parse(json["tranDate"]),
    serial: json["serial"],
    taxId: json["taxId"],
    mit: json["mit"],
    lotNumber: json["lotNumber"],
    affiliationId: json["affiliationId"],
    upn: json["upn"],
    d003: json["d003"],
    d007: json["d007"],
    d011: json["d011"],
    d012: json["d012"],
    d024: json["d024"],
    d037: json["d037"],
    d039: json["d039"],
    d041: json["d041"],
    d042: json["d042"],
    tranDateResp: DateTime.parse(json["tranDateResp"]),
    receipt: json["receipt"],
  );

  factory ResponseLoteDetails.fromJsonList(List<dynamic> json) {
    if (json.isEmpty) {
      return ResponseLoteDetails.empty();
    }

    final Map<String, dynamic> firstItem = json[0];
    return ResponseLoteDetails(
      id: firstItem["id"],
      tranDate: DateTime.parse(firstItem["tranDate"]),
      serial: firstItem["serial"],
      taxId: firstItem["taxId"],
      mit: firstItem["mit"],
      lotNumber: firstItem["lotNumber"],
      affiliationId: firstItem["affiliationId"],
      upn: firstItem["upn"],
      d003: firstItem["d003"],
      d007: firstItem["d007"],
      d011: firstItem["d011"],
      d012: firstItem["d012"],
      d024: firstItem["d024"],
      d037: firstItem["d037"],
      d039: firstItem["d039"],
      d041: firstItem["d041"],
      d042: firstItem["d042"],
      tranDateResp: DateTime.parse(firstItem["tranDateResp"]),
      receipt: firstItem["receipt"],
    );
  }

  static ResponseLoteDetails empty() {
    return ResponseLoteDetails(
      id: 0,
      tranDate: DateTime.now(),
      serial: '',
      taxId: '',
      mit: '',
      lotNumber: '',
      affiliationId: 0,
      upn: '',
      d003: '',
      d007: '',
      d011: '',
      d012: '',
      d024: '',
      d037: '',
      d039: '',
      d041: '',
      d042: '',
      tranDateResp: DateTime.now(),
      receipt: '',
    );
  }

}

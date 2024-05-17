import 'dart:convert';

class ResponseAfiliados {
  List<Commerce> commerces;

  ResponseAfiliados({required this.commerces});

  factory ResponseAfiliados.fromJson(List<dynamic> json) => ResponseAfiliados(
    commerces: List<Commerce>.from(
        json.map((x) => Commerce.fromJson(x as Map<String, dynamic>))),
  );

  static ResponseAfiliados empty() {
    return ResponseAfiliados(
      commerces: [],
    );
  }
}

class Commerce {
  int id;
  String taxId;
  String name;
  List<Affiliation> affiliations;

  Commerce({
    required this.id,
    required this.taxId,
    required this.name,
    required this.affiliations,
  });

  factory Commerce.fromJson(Map<String, dynamic> json) => Commerce(
    id: json["commerce"]["id"] ?? 0,
    taxId: json["commerce"]["taxId"] ?? "NA",
    name: json["commerce"]["name"] ?? "NA",
    affiliations: (json["affiliations"] != null)
        ? List<Affiliation>.from(json["affiliations"]
        .map((x) => Affiliation.fromJson(x as Map<String, dynamic>)))
        : [],
  );
}

class Affiliation {
  int id;
  String merchant;
  String terminal;
  String lotNumber;
  int statusId;
  String description;
  int deviceId;
  String serial;

  Affiliation({
    required this.id,
    required this.merchant,
    required this.terminal,
    required this.lotNumber,
    required this.statusId,
    required this.description,
    required this.deviceId,
    required this.serial,
  });

  factory Affiliation.fromJson(Map<String, dynamic> json) => Affiliation(
    id: json["id"] ?? 0,
    merchant: json["merchant"] ?? "NA",
    terminal: json["terminal"] ?? "NA",
    lotNumber: json["lotNumber"] ?? "NA",
    statusId: json["statusId"] ?? 0,
    description: json["description"] ?? "NA",
    deviceId: json["deviceId"] ?? 0,
    serial: json["serial"] ?? "NA",
  );
}

import 'dart:convert';

class ResponseIndicators {
  int lotNumber;
  int quantityRefund;
  String amountRefund;
  int quantitySales;
  String amountSales;
  int quantitySalesDebitApproved;
  String amountSalesDebitApproved;
  int quantitySalesCreditApproved;
  String amountSalesCreditApproved;

  ResponseIndicators({
    required this.lotNumber,
    required this.quantityRefund,
    required this.amountRefund,
    required this.quantitySales,
    required this.amountSales,
    required this.quantitySalesDebitApproved,
    required this.amountSalesDebitApproved,
    required this.quantitySalesCreditApproved,
    required this.amountSalesCreditApproved,
  });

  factory ResponseIndicators.fromRawJson(String str) => ResponseIndicators.fromJson(json.decode(str));

  factory ResponseIndicators.fromJson(Map<String, dynamic> json) => ResponseIndicators(
    lotNumber: json["lotNumber"],
    quantityRefund: json["quantityRefund"],
    amountRefund: json["amountRefund"],
    quantitySales: json["quantitySales"],
    amountSales: json["amountSales"],
    quantitySalesDebitApproved: json["quantitySalesDebitApproved"],
    amountSalesDebitApproved: json["amountSalesDebitApproved"],
    quantitySalesCreditApproved: json["quantitySalesCreditApproved"],
    amountSalesCreditApproved: json["amountSalesCreditApproved"],
  );

  factory ResponseIndicators.fromJson2(Map<String, dynamic> json) => ResponseIndicators(
    lotNumber: json["data"]["resumenLote"]["lotNumber"],
    quantityRefund: json["data"]["resumenLote"]["quantityRefund"],
    amountRefund: json["data"]["resumenLote"]["amountRefund"],
    quantitySales: json["data"]["resumenLote"]["quantitySales"],
    amountSales: json["data"]["resumenLote"]["amountSales"],
    quantitySalesDebitApproved: json["data"]["resumenLote"]["quantitySalesDebitApproved"],
    amountSalesDebitApproved: json["data"]["resumenLote"]["amountSalesDebitApproved"],
    quantitySalesCreditApproved: json["data"]["resumenLote"]["quantitySalesCreditApproved"],
    amountSalesCreditApproved: json["data"]["resumenLote"]["amountSalesCreditApproved"],
  );

  static ResponseIndicators empty() {
    return ResponseIndicators(
      lotNumber: 0,
      quantityRefund: 0,
      amountRefund: "",
      quantitySales: 0,
      amountSales:"",
      quantitySalesDebitApproved: 0,
      amountSalesDebitApproved: "",
      quantitySalesCreditApproved: 0,
      amountSalesCreditApproved: "",
    );
  }
}
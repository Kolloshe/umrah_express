// To parse this JSON data, do
//
// final cancellationPolicyModel = cancellationPolicyModelFromJson(jsonString);

import 'dart:convert';

CancellationPolicyModel cancellationPolicyModelFromJson(String str) =>
    CancellationPolicyModel.fromJson(json.decode(str));

String cancellationPolicyModelToJson(CancellationPolicyModel data) => json.encode(data.toJson());

class CancellationPolicyModel {
  final num? code;
  final bool? error;
  final String? message;
  final Data? data;

  CancellationPolicyModel({
    this.code,
    this.error,
    this.message,
    this.data,
  });

  factory CancellationPolicyModel.fromJson(Map<String, dynamic> json) => CancellationPolicyModel(
        code: json["code"],
        error: json["error"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "error": error,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  final CancellationPolicy? cancellationPolicy;
  final List<String>? cancellationReasons;

  Data({
    this.cancellationPolicy,
    this.cancellationReasons,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        cancellationPolicy: json["cancellation_policy"] == null
            ? null
            : CancellationPolicy.fromJson(json["cancellation_policy"]),
        cancellationReasons: json["cancellation_reasons"] == null
            ? []
            : List<String>.from(json["cancellation_reasons"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "cancellation_policy": cancellationPolicy?.toJson(),
        "cancellation_reasons": cancellationReasons == null
            ? []
            : List<dynamic>.from(cancellationReasons!.map((x) => x)),
      };
}

class CancellationPolicy {
  final String? selectedCurrency;
  final num? totalAmount;
  final num? purchasedAmount;
  final num? creditOrVoucherApplied;
  final num? refundAmount;
  final String? refundText;

  CancellationPolicy({
    this.selectedCurrency,
    this.totalAmount,
    this.purchasedAmount,
    this.creditOrVoucherApplied,
    this.refundAmount,
    this.refundText,
  });

  factory CancellationPolicy.fromJson(Map<String, dynamic> json) => CancellationPolicy(
        selectedCurrency: json["selected_currency"],
        totalAmount: json["total_amount"],
        purchasedAmount: json["purchased_amount"],
        creditOrVoucherApplied: json["credit_or_voucher_applied"],
        refundAmount: json["refund_amount"],
        refundText: json["refund_text"],
      );

  Map<String, dynamic> toJson() => {
        "selected_currency": selectedCurrency,
        "total_amount": totalAmount,
        "purchased_amount": purchasedAmount,
        "credit_or_voucher_applied": creditOrVoucherApplied,
        "refund_amount": refundAmount,
        "refund_text": refundText,
      };
}

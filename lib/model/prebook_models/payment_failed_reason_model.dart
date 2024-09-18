// To parse this JSON data, do
//
// final paymentFailedModel = paymentFailedModelFromMap(jsonString);

import 'dart:convert';

PaymentFailedModel paymentFailedModelFromMap(String str) => PaymentFailedModel.fromMap(json.decode(str));

String paymentFailedModelToMap(PaymentFailedModel data) => json.encode(data.toMap());

class PaymentFailedModel {
  PaymentFailedModel({
   required this.code,
   required this.error,
   required this.message,
   required this.data,
  });

  int? code;
  bool? error;
  String? message;
  Data? data;

  factory PaymentFailedModel.fromMap(Map<String, dynamic> json) => PaymentFailedModel(
    code: json["code"],
    error: json["error"],
    message: json["message"],
    data:json.containsKey('data')? Data.fromMap(json["data"]):null,
  );

  Map<String, dynamic> toMap() => {
    "code": code,
    "error": error,
    "message": message,
    "data": data?.toMap()??'',
  };
}

class Data {
  Data({
   required this.errorCode,
   required this.errorMsg,
   required this.errorDesc,
  });

  String? errorCode;
  String? errorMsg;
  String? errorDesc;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    errorCode: json["error_code"],
    errorMsg: json["error_msg"],
    errorDesc: json["error_desc"],
  );

  Map<String, dynamic> toMap() => {
    "error_code": errorCode,
    "error_msg": errorMsg,
    "error_desc": errorDesc,
  };
}

// To parse this JSON data, do
//
//     final cancelBookingModel = cancelBookingModelFromMap(jsonString);

import 'dart:convert';

CancelBookingModel cancelBookingModelFromMap(String str) => CancelBookingModel.fromMap(json.decode(str));

String cancelBookingModelToMap(CancelBookingModel data) => json.encode(data.toMap());

class CancelBookingModel {
  CancelBookingModel({
   required this.code,
   required this.error,
   required this.message,
   required this.data,
  });

  int code;
  bool error;
  String message;
  CancellationData? data;

  factory CancelBookingModel.fromMap(Map<String, dynamic> json) => CancelBookingModel(
    code: json["code"],
    error: json["error"],
    message: json["message"],
    data: json.containsKey('data')?  CancellationData.fromMap(json["data"]):null,
  );

  Map<String, dynamic> toMap() => {
    "code": code,
    "error": error,
    "message": message,
    "data": data?.toMap(),
  };
}

class CancellationData {
  CancellationData({
   required this.bookingRef,
   required this.supportEmail,
  });

  String bookingRef;
  String supportEmail;

  factory CancellationData.fromMap(Map<String, dynamic> json) => CancellationData(
    bookingRef: json["bookingRef"],
    supportEmail: json["support_email"],
  );

  Map<String, dynamic> toMap() => {
    "bookingRef": bookingRef,
    "support_email": supportEmail,
  };
}

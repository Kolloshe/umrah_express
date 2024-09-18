// To parse this JSON data, do
//
//     final bookingFailedModel = bookingFailedModelFromMap(jsonString);

import 'dart:convert';

BookingFailedModel bookingFailedModelFromMap(String str) =>
    BookingFailedModel.fromMap(json.decode(str));

String bookingFailedModelToMap(BookingFailedModel data) => json.encode(data.toMap());

class BookingFailedModel {
  BookingFailedModel({
    required this.code,
    required this.error,
    required this.message,
    required this.data,
  });

  int? code;
  bool? error;
  String? message;
  Data? data;

  factory BookingFailedModel.fromMap(Map<String, dynamic> json) => BookingFailedModel(
        code: json["code"],
        error: json["error"],
        message: json["message"],
        data: json.containsKey('data') ? Data.fromMap(json["data"]) : null,
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "error": error,
        "message": message,
        "data": data?.toMap(),
      };
}

class Data {
  Data({
    required this.message,
    required this.code,
    required this.desc,
  });

  String? message;
  String? code;
  String? desc;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        message: json["message"],
        code: json["code"],
        desc: json["desc"],
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "code": code,
        "desc": desc,
      };
}

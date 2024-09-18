// To parse required this JSON data, do
//
//     final payload = payloadFromJson(jsonString);

import 'dart:convert';

Payload payloadFromJson(String str) => Payload.fromJson(json.decode(str));

String payloadToJson(Payload data) => json.encode(data.toJson());

class Payload {
  Payload({
    required this.status,
    required this.payload,
    required this.message,
    required this.completedAt,
    required this.code,
  });

  bool status;
  List<PayloadElement> payload;
  String message;
  DateTime completedAt;
  int code;

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        status: json["status"],
        payload: json.containsKey("payload")
            ? json["payload"] == null
                ? <PayloadElement>[]
                : List<PayloadElement>.from(json["payload"].map((x) => PayloadElement.fromJson(x)))
            : <PayloadElement>[],
        message: json["message"],
        completedAt: DateTime.parse(json["completed_at"]),
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "payload": List<dynamic>.from(payload.map((x) => x.toJson())),
        "message": message,
        "completed_at": completedAt.toIso8601String(),
        "code": code,
      };
}

class PayloadElement {
  PayloadElement(
      {required this.id,
      required this.cityName,
      required this.destinationName,
      required this.countryName,
      required this.cityCode,
      required this.airportCode,
      required this.hotelCounts,
      required this.countryCode});

  String? id;
  String? cityName;
  String? destinationName;
  String? countryName;
  String? cityCode;
  String? airportCode;
  String? hotelCounts;
  String? countryCode;

  factory PayloadElement.fromJson(Map<String, dynamic> json) => PayloadElement(
      id: json["id"].toString(),
      cityName: json["city_name"],
      destinationName: json["destination_name"],
      countryName: json["country_name"],
      cityCode: json["city_code"],
      airportCode: json["airport_code"].toString(),
      hotelCounts: json["hotel_counts"].toString(),
      countryCode: (json.containsKey('country_code') ? json["country_code"] : "AE").toString());

  Map<String, dynamic> toJson() => {
        "id": id,
        "city_name": cityName,
        "destination_name": destinationName,
        "country_name": countryName,
        "city_code": cityCode,
        "airport_code": airportCode,
        "hotel_counts": hotelCounts,
        "country_code": countryCode
      };
}

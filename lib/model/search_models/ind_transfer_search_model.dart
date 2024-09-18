// final indTransferSearchModel = indTransferSearchModelFromJson(jsonString);

import 'dart:convert';

IndTransferSearchModel indTransferSearchModelFromJson(String str) =>
    IndTransferSearchModel.fromJson(json.decode(str));

String indTransferSearchModelToJson(IndTransferSearchModel data) => json.encode(data.toJson());

class IndTransferSearchModel {
  final int? code;
  final bool? error;
  final String? message;
  final List<IndTransferSearchResultData>? data;

  IndTransferSearchModel({
    this.code,
    this.error,
    this.message,
    this.data,
  });

  factory IndTransferSearchModel.fromJson(Map<String, dynamic> json) => IndTransferSearchModel(
        code: json["code"],
        error: json["error"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<IndTransferSearchResultData>.from(
                json["data"]!.map((x) => IndTransferSearchResultData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "error": error,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class IndTransferSearchResultData {
  final String? code;
  final String? countryCode;
  final String? hotelName;
  final String? label;
  final String? value;
  final String? type;
  final String? country;
  final String? category;

  IndTransferSearchResultData({
    this.code,
    this.countryCode,
    this.hotelName,
    this.label,
    this.value,
    this.type,
    this.country,
    this.category,
  });

  factory IndTransferSearchResultData.fromJson(Map<String, dynamic> json) =>
      IndTransferSearchResultData(
        code: json["code"].toString(),
        countryCode: json["country_code"],
        hotelName: json["hotel_name"],
        label: json["label"],
        value: json["value"],
        type: json["type"],
        country: json["country"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "country_code": countryCode,
        "hotel_name": hotelName,
        "label": label,
        "value": value,
        "type": type,
        "country": country,
        "category": category,
      };
}

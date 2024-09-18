//  final transferListModel = transferListModelFromJson(jsonString);

import 'dart:convert';

TransferListModel transferListModelFromJson(String str) =>
    TransferListModel.fromJson(json.decode(str));

String transferListModelToJson(TransferListModel data) => json.encode(data.toJson());

class TransferListModel {
  final int? code;
  final bool? error;
  final String? message;
  final Data? data;

  TransferListModel({
    this.code,
    this.error,
    this.message,
    this.data,
  });

  factory TransferListModel.fromJson(Map<String, dynamic> json) => TransferListModel(
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
  final List<In>? dataIn;
  final List<In>? out;

  Data({
    this.dataIn,
    this.out,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        dataIn: json["in"] == null ? [] : List<In>.from(json["in"]!.map((x) => In.fromJson(x))),
        out: json["out"] == null ? [] : List<In>.from(json["out"]!.map((x) => In.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "in": dataIn == null ? [] : List<dynamic>.from(dataIn!.map((x) => x.toJson())),
        "out": out == null ? [] : List<dynamic>.from(out!.map((x) => x.toJson())),
      };
}

class In {
  final String? id;
  final String? currency;
  final num? totalAmount;
  final String? serviceTypeName;
  final String? name;
  final String? images;
  final num? priceDifference;

  In({
    this.id,
    this.currency,
    this.totalAmount,
    this.serviceTypeName,
    this.name,
    this.images,
    this.priceDifference,
  });

  factory In.fromJson(Map<String, dynamic> json) => In(
        id: json["_id"],
        currency: json["currency"],
        totalAmount: json["total_amount"],
        serviceTypeName: json["service_type_name"],
        name: json["name"],
        images: json["images"],
        priceDifference: json["price_difference"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "currency": currency,
        "total_amount": totalAmount,
        "service_type_name": serviceTypeName,
        "name": name,
        "images": images,
        "price_difference": priceDifference,
      };
}

// To parse this JSON data, do
//
//     final promotionDataModel = promotionDataModelFromJson(jsonString);

import 'dart:convert';

PromotionDataModel promotionDataModelFromJson(String str) => PromotionDataModel.fromJson(json.decode(str));

String promotionDataModelToJson(PromotionDataModel data) => json.encode(data.toJson());

class PromotionDataModel {
    final int? code;
    final bool? error;
    final String? message;
    final List<PromoListData>? data;

    PromotionDataModel({
        this.code,
        this.error,
        this.message,
        this.data,
    });

    factory PromotionDataModel.fromJson(Map<String, dynamic> json) => PromotionDataModel(
        code: json["code"],
        error: json["error"],
        message: json["message"],
        data: json["data"] == null ? [] : List<PromoListData>.from(json["data"]!.map((x) => PromoListData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "error": error,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class PromoListData {
    final int? id;
    final String? title;
    final String? description;
    final String? promoCode;
    final String? thumbnail;
    final String? image;
    final int? status;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    PromoListData({
        this.id,
        this.title,
        this.description,
        this.promoCode,
        this.thumbnail,
        this.image,
        this.status,
        this.createdAt,
        this.updatedAt,
    });

    factory PromoListData.fromJson(Map<String, dynamic> json) => PromoListData(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        promoCode: json["promo_code"],
        thumbnail: json["thumbnail"],
        image: json["image"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "promo_code": promoCode,
        "thumbnail": thumbnail,
        "image": image,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

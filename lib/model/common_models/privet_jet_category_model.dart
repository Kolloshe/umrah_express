// To parse this JSON data, do
//
//     final privateJetCategories = privateJetCategoriesFromJson(jsonString);

import 'dart:convert';

PrivateJetCategories privateJetCategoriesFromJson(String str) => PrivateJetCategories.fromJson(json.decode(str));

String privateJetCategoriesToJson(PrivateJetCategories data) => json.encode(data.toJson());

class PrivateJetCategories {
    final int? code;
    final bool? error;
    final String? message;
    final List<CategoryData>? data;

    PrivateJetCategories({
        this.code,
        this.error,
        this.message,
        this.data,
    });

    factory PrivateJetCategories.fromJson(Map<String, dynamic> json) => PrivateJetCategories(
        code: json["code"],
        error: json["error"],
        message: json["message"],
        data: json["data"] == null ? [] : List<CategoryData>.from(json["data"]!.map((x) => CategoryData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "error": error,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class CategoryData {
    final int? id;
    final String? name;

    CategoryData({
        this.id,
        this.name,
    });

    factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}

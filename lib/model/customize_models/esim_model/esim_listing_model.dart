 
// final esimListModel = esimListModelFromJson(jsonString);

import 'dart:convert';

EsimListModel esimListModelFromJson(String str) => EsimListModel.fromJson(json.decode(str));

String esimListModelToJson(EsimListModel data) => json.encode(data.toJson());

class EsimListModel {
    final int? code;
    final bool? error;
    final String? message;
    final List<EsimData>? data;

    EsimListModel({
        this.code,
        this.error,
        this.message,
        this.data,
    });

    factory EsimListModel.fromJson(Map<String, dynamic> json) => EsimListModel(
        code: json["code"],
        error: json["error"],
        message: json["message"],
        data: json["data"] == null ? [] : List<EsimData>.from(json["data"]!.map((x) => EsimData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "error": error,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class EsimData {
    final String? name;
    final String? description;
    final int? dataAmount;
    final List<String>? speed;
    final bool? autostart;
    final String? imageUrl;
    final List<String>? groups;
    final String? countryName;
    final String? payableCurrency;
    final String? sellingCurrency;
    final double? payableAmount;
    final int? sellingAmount;
    final String? duration;
    final int? roamingCountry;
    final String? roaming;
    final List<String>? roamingEnabled;
    final String? customizeId;
    final String? simPackageId;

    EsimData({
        this.name,
        this.description,
        this.dataAmount,
        this.speed,
        this.autostart,
        this.imageUrl,
        this.groups,
        this.countryName,
        this.payableCurrency,
        this.sellingCurrency,
        this.payableAmount,
        this.sellingAmount,
        this.duration,
        this.roamingCountry,
        this.roaming,
        this.roamingEnabled,
        this.customizeId,
        this.simPackageId,
    });

    factory EsimData.fromJson(Map<String, dynamic> json) => EsimData(
        name: json["name"],
        description: json["description"],
        dataAmount: json["dataAmount"],
        speed: json["speed"] == null ? [] : List<String>.from(json["speed"]!.map((x) => x)),
        autostart: json["autostart"],
        imageUrl: json["imageUrl"],
        groups: json["groups"] == null ? [] : List<String>.from(json["groups"]!.map((x) => x)),
        countryName: json["countryName"],
        payableCurrency: json["payableCurrency"],
        sellingCurrency: json["sellingCurrency"],
        payableAmount: json["payableAmount"]?.toDouble(),
        sellingAmount: json["sellingAmount"],
        duration: json["duration"],
        roamingCountry: json["roamingCountry"],
        roaming: json["roaming"],
        roamingEnabled: json["roamingEnabled"] == null ? [] : List<String>.from(json["roamingEnabled"]!.map((x) => x)),
        customizeId: json["customizeId"],
        simPackageId: json["simPackageId"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "dataAmount": dataAmount,
        "speed": speed == null ? [] : List<dynamic>.from(speed!.map((x) => x)),
        "autostart": autostart,
        "imageUrl": imageUrl,
        "groups": groups == null ? [] : List<dynamic>.from(groups!.map((x) => x)),
        "countryName": countryName,
        "payableCurrency": payableCurrency,
        "sellingCurrency": sellingCurrency,
        "payableAmount": payableAmount,
        "sellingAmount": sellingAmount,
        "duration": duration,
        "roamingCountry": roamingCountry,
        "roaming": roaming,
        "roamingEnabled": roamingEnabled == null ? [] : List<dynamic>.from(roamingEnabled!.map((x) => x)),
        "customizeId": customizeId,
        "simPackageId": simPackageId,
    };
}

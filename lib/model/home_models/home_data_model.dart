//final homeDataModel = homeDataModelFromJson(jsonString);

import 'dart:convert';

HomeDataModel homeDataModelFromJson(String str) => HomeDataModel.fromJson(json.decode(str));

String homeDataModelToJson(HomeDataModel data) => json.encode(data.toJson());

class HomeDataModel {
  final int? code;
  final bool? error;
  final String? message;
  final Data? data;

  HomeDataModel({
    this.code,
    this.error,
    this.message,
    this.data,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) => HomeDataModel(
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
  final DateTime? packageStart;
  final DateTime? packageEnd;
  final int? departureCode;
  final Section? sectionOne;
  final Section? sectionTwo;
  final bool? isGameControlActive;
  final num? coinAmount;

  Data(
      {this.packageStart,
      this.packageEnd,
      this.departureCode,
      this.sectionOne,
      this.sectionTwo,
      this.isGameControlActive,
      this.coinAmount});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        packageStart: json["package_start"] == null ? null : DateTime.parse(json["package_start"]),
        packageEnd: json["package_end"] == null ? null : DateTime.parse(json["package_end"]),
        departureCode: json["departure_code"],
        sectionOne: json["section_one"] == null ? null : Section.fromJson(json["section_one"]),
        sectionTwo: json["section_two"] == null ? null : Section.fromJson(json["section_two"]),
        isGameControlActive: json["is_game_control_active"] ?? true,
        coinAmount: num.parse(json["coin_amount"]),
      );

  Map<String, dynamic> toJson() => {
        "package_start": packageStart?.toIso8601String(),
        "package_end": packageEnd?.toIso8601String(),
        "departure_code": departureCode,
        "section_one": sectionOne?.toJson(),
        "section_two": sectionTwo?.toJson(),
      };
}

class Section {
  final String? title;
  final List<SectionData>? data;

  Section({
    this.title,
    this.data,
  });

  factory Section.fromJson(Map<String, dynamic> json) => Section(
        title: json["title"],
        data: json["data"] == null
            ? []
            : List<SectionData>.from(json["data"]!.map((x) => SectionData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SectionData {
  final String? label;
  final String? city;
  final String? country;
  final String? cityFullName;
  final String? image;
  final String? searchUrl;
  final int? arrivalCode;
  final int? departureCode;

  SectionData({
    this.label,
    this.city,
    this.country,
    this.cityFullName,
    this.image,
    this.searchUrl,
    this.arrivalCode,
    this.departureCode,
  });

  factory SectionData.fromJson(Map<String, dynamic> json) => SectionData(
        label: json["label"],
        city: json["city"],
        country: json["country"],
        cityFullName: json["city_full_name"],
        image: json["image"],
        searchUrl: json["search_url"],
        arrivalCode: json["arrival_code"],
        departureCode: json["departure_code"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "city": city,
        "country": country,
        "city_full_name": cityFullName,
        "image": image,
        "search_url": searchUrl,
        "arrival_code": arrivalCode,
        "departure_code": departureCode,
      };
}

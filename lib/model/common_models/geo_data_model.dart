//final apiGeoData = apiGeoDataFromJson(jsonString);

import 'dart:convert';

ApiGeoData apiGeoDataFromJson(String str) => ApiGeoData.fromJson(json.decode(str));

String apiGeoDataToJson(ApiGeoData data) => json.encode(data.toJson());

class ApiGeoData {
  final String? id;
  final String? ip;
  final String? continentCode;
  final String? continentName;
  final String? countryCode;
  final String? countryName;
  final String? regionCode;
  final String? regionName;
  final String? city;
  final dynamic zip;
  final String? latitude;
  final String? longitude;
  final String? capital;
  final dynamic countryFlag;
  final String? callingCode;
  final String? languageCode;
  final String? languageName;
  final String? currencyCode;
  final String? currencyName;
  final String? url;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ApiGeoData({
    this.id,
    this.ip,
    this.continentCode,
    this.continentName,
    this.countryCode,
    this.countryName,
    this.regionCode,
    this.regionName,
    this.city,
    this.zip,
    this.latitude,
    this.longitude,
    this.capital,
    this.countryFlag,
    this.callingCode,
    this.languageCode,
    this.languageName,
    this.currencyCode,
    this.currencyName,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  factory ApiGeoData.fromJson(Map<String, dynamic> json) => ApiGeoData(
        id: json["id"].toString(),
        ip: json["ip"],
        continentCode: json["continent_code"],
        continentName: json["continent_name"],
        countryCode: json["country_code"],
        countryName: json["country_name"],
        regionCode: json["region_code"],
        regionName: json["region_name"],
        city: json["city"],
        zip: json["zip"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        capital: json["capital"],
        countryFlag: json["country_flag"],
        callingCode: json["calling_code"],
        languageCode: json["language_code"],
        languageName: json["language_name"],
        currencyCode: json["currency_code"],
        currencyName: json["currency_name"],
        url: json["url"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ip": ip,
        "continent_code": continentCode,
        "continent_name": continentName,
        "country_code": countryCode,
        "country_name": countryName,
        "region_code": regionCode,
        "region_name": regionName,
        "city": city,
        "zip": zip,
        "latitude": latitude,
        "longitude": longitude,
        "capital": capital,
        "country_flag": countryFlag,
        "calling_code": callingCode,
        "language_code": languageCode,
        "language_name": languageName,
        "currency_code": currencyCode,
        "currency_name": currencyName,
        "url": url,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

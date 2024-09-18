// final hotelListModel = hotelListModelFromJson(jsonString);

import 'dart:convert';

import 'package:geolocator/geolocator.dart';

import '../package_customize_model.dart';

HotelListModel hotelListModelFromJson(String str) => HotelListModel.fromJson(json.decode(str));

String hotelListModelToJson(HotelListModel data) => json.encode(data.toJson());

class HotelListModel {
  final Status? status;
  final List<HotelData>? hotelData;

  HotelListModel({
    this.status,
    this.hotelData,
  });

  factory HotelListModel.fromJson(Map<String, dynamic> json) => HotelListModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        hotelData: json["response"] == null
            ? []
            : List<HotelData>.from(json["response"]!.map((x) => HotelData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "response": hotelData == null ? [] : List<dynamic>.from(hotelData!.map((x) => x.toJson())),
      };
}

class HotelData {
  final num? id;
  final String? searchId;
  final String? hotelCode;
  final String? name;
  final String? description;
  final String? starRating;
  final String? destinationCode;
  final String? destinationName;
  final String? checknumext;
  final String? checkOutText;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final DateTime? checkin;
  final DateTime? checkout;
  final String? address;
  final String? currency;
  final num? rateFrom;
  final String? latitude;
  final String? longitude;
  final String? image;
  final List<ImgAll>? imgAll;
  final List<List<Room>>? rooms;
  final List<String>? facilities;
  final String? distanceFromMakkah;

  HotelData({
    this.id,
    this.searchId,
    this.hotelCode,
    this.name,
    this.description,
    this.starRating,
    this.destinationCode,
    this.destinationName,
    this.checknumext,
    this.checkOutText,
    this.checkIn,
    this.checkOut,
    this.checkin,
    this.checkout,
    this.address,
    this.currency,
    this.rateFrom,
    this.latitude,
    this.longitude,
    this.image,
    this.imgAll,
    this.rooms,
    this.facilities,
    this.distanceFromMakkah,
  });

  factory HotelData.fromJson(Map<String, dynamic> json) => HotelData(
        id: json["id"],
        searchId: json["searchId"],
        hotelCode: json["hotelCode"],
        name: json["name"],
        description: json["description"],
        starRating: json["starRating"],
        destinationCode: json["destinationCode"],
        destinationName: json["destinationName"],
        checknumext: json["checknumext"],
        checkOutText: json["checkOutText"],
        checkIn: json["checkIn"] == null ? null : DateTime.parse(json["checkIn"]),
        checkOut: json["checkOut"] == null ? null : DateTime.parse(json["checkOut"]),
        checkin: json["checkin"] == null ? null : DateTime.parse(json["checkin"]),
        checkout: json["checkout"] == null ? null : DateTime.parse(json["checkout"]),
        address: json["address"],
        currency: json["currency"],
        rateFrom: json["rateFrom"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        image: json["image"],
        imgAll: json["img_all"] == null
            ? []
            : List<ImgAll>.from(json["img_all"]!.map((x) => ImgAll.fromJson(x))),
        rooms: json["rooms"] == null
            ? []
            : List<List<Room>>.from(
                json["rooms"]!.map((x) => List<Room>.from(x.map((x) => Room.fromJson(x))))),
        facilities:
            json["facilities"] == null ? [] : List<String>.from(json["facilities"]!.map((x) => x)),
       distanceFromMakkah: (Geolocator.distanceBetween(
                double.tryParse(json["latitude"]) ?? 1,
                double.tryParse(json["longitude"]) ?? 1,
                21.422510,
                39.826168,
              ) /
              1000)
          .toStringAsFixed(1)  );

  Map<String, dynamic> toJson() => {
        "id": id,
        "searchId": searchId,
        "hotelCode": hotelCode,
        "name": name,
        "description": description,
        "starRating": starRating,
        "destinationCode": destinationCode,
        "destinationName": destinationName,
        "checknumext": checknumext,
        "checkOutText": checkOutText,
        "checkIn": checkIn?.toIso8601String(),
        "checkOut": checkOut?.toIso8601String(),
        "checkin": checkin?.toIso8601String(),
        "checkout": checkout?.toIso8601String(),
        "address": address,
        "currency": currency,
        "rateFrom": rateFrom,
        "latitude": latitude,
        "longitude": longitude,
        "image": image,
        "img_all": imgAll == null ? [] : List<dynamic>.from(imgAll!.map((x) => x.toJson())),
        "rooms": rooms == null
            ? []
            : List<dynamic>.from(rooms!.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
        "facilities": facilities == null ? [] : List<dynamic>.from(facilities!.map((x) => x)),
      };
}

class Status {
  final num? code;
  final String? message;
  final bool? error;

  Status({
    this.code,
    this.message,
    this.error,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        code: json["code"],
        message: json["message"],
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "error": error,
      };
}

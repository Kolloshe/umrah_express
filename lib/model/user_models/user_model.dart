// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final num? code;
  final bool? error;
  final String? message;
  final UserData? data;

  UserModel({
    this.code,
    this.error,
    this.message,
    this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        code: json["code"],
        error: json["error"],
        message: json["message"],
        data: json["data"] == null ? null : UserData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "error": error,
        "message": message,
        "data": data?.toJson(),
      };
}

class UserData {
  final String? name;
  final String? lastName;
  final String? email;
  final String? phoneCountryCode;
  final String? phone;
  final num? status;
  final String? creditCurrency;
  final num? creditBalance;
  final num? userId;
  final String? language;
  final String? currency;
  final String? mobile;
  final String? profileImage;
  final String? address;
  final String? postalCode;
  final String? country;
  final String? city;
  final String? countryCode;
  final String? cityCode;
  final dynamic profilePath;
  final List<PassengerDetail>? passengerDetails;
  final String? token;
  final num? phoneVerified;
  final List<Country>? countries;
  final List<dynamic>? defaultCities;
  final List<PassengersDetail>? passengersDetails;

  UserData({
    this.name,
    this.lastName,
    this.email,
    this.phoneCountryCode,
    this.phone,
    this.status,
    this.creditCurrency,
    this.creditBalance,
    this.userId,
    this.language,
    this.currency,
    this.mobile,
    this.profileImage,
    this.address,
    this.postalCode,
    this.country,
    this.city,
    this.countryCode,
    this.cityCode,
    this.profilePath,
    this.passengerDetails,
    this.token,
    this.phoneVerified,
    this.countries,
    this.defaultCities,
    this.passengersDetails,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        name: json["name"],
        lastName: json["last_name"],
        email: json["email"],
        phoneCountryCode: json["phone_country_code"],
        phone: json["phone"],
        status: json["status"],
        creditCurrency: json["credit_currency"],
        creditBalance: json["credit_balance"],
        userId: json["user_id"],
        language: json["language"],
        currency: json["currency"],
        mobile: json["mobile"],
        profileImage: json["profile_image"],
        address: json["address"],
        postalCode: json["postal_code"],
        country: json["country"],
        city: json["city"],
        countryCode: json["country_code"],
        cityCode: json["city_code"],
        profilePath: json["profile_path"],
        passengerDetails: json["passenger_details"] == null
            ? []
            : List<PassengerDetail>.from(
                json["passenger_details"]!.map((x) => PassengerDetail.fromJson(x))),
        token: json["token"],
        phoneVerified: json["phone_verified"],
        countries: json["countries"] == null
            ? []
            : List<Country>.from(json["countries"]!.map((x) => Country.fromJson(x))),
        defaultCities: json["default_cities"] == null
            ? []
            : List<dynamic>.from(json["default_cities"]!.map((x) => x)),
        passengersDetails: json["passengers_details"] == null
            ? []
            : List<PassengersDetail>.from(
                json["passengers_details"]!.map((x) => PassengersDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "last_name": lastName,
        "email": email,
        "phone_country_code": phoneCountryCode,
        "phone": phone,
        "status": status,
        "credit_currency": creditCurrency,
        "credit_balance": creditBalance,
        "user_id": userId,
        "language": language,
        "currency": currency,
        "mobile": mobile,
        "profile_image": profileImage,
        "address": address,
        "postal_code": postalCode,
        "country": country,
        "city": city,
        "country_code": countryCode,
        "city_code": cityCode,
        "profile_path": profilePath,
        "passenger_details": passengerDetails == null
            ? []
            : List<dynamic>.from(passengerDetails!.map((x) => x.toJson())),
        "token": token,
        "phone_verified": phoneVerified,
        "countries": countries == null ? [] : List<dynamic>.from(countries!.map((x) => x.toJson())),
        "default_cities":
            defaultCities == null ? [] : List<dynamic>.from(defaultCities!.map((x) => x)),
        "passengers_details": passengersDetails == null
            ? []
            : List<dynamic>.from(passengersDetails!.map((x) => x.toJson())),
      };
}

class Country {
  final String? code;
  final String? name;
  final String? currencyCode;

  Country({
    this.code,
    this.name,
    this.currencyCode,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        code: json["code"],
        name: json["name"],
        currencyCode: json["currency_code"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "currency_code": currencyCode,
      };
}

class PassengerDetail {
  final num? id;
  final String? type;
  final String? name;
  final String? surname;
  final String? selectedTitle;
  final String? nationatily;
  final DateTime? birthdate;
  final String? passportNumber;
  final DateTime? passportExpirityDate;
  final String? passportCountryIssued;
  final String? personType;
  final String? nationalityName;
  final String? passportCountry;

  PassengerDetail({
    this.id,
    this.type,
    this.name,
    this.surname,
    this.selectedTitle,
    this.nationatily,
    this.birthdate,
    this.passportNumber,
    this.passportExpirityDate,
    this.passportCountryIssued,
    this.personType,
    this.nationalityName,
    this.passportCountry,
  });

  factory PassengerDetail.fromJson(Map<String, dynamic> json) {
    final x = (json["passport_expirity_date"].toString()).split("-");

    return PassengerDetail(
      id: json["id"],
      type: json["type"],
      name: json["name"],
      surname: json["surname"],
      selectedTitle: json["selected_title"],
      nationatily: json["nationatily"],
      birthdate: json["birthdate"] == null ? null : DateTime.parse(json["birthdate"]),
      passportNumber: json["passport_number"],
      passportExpirityDate: (json.containsKey("passport_exp_date") &&
              json["passport_exp_date"] != null)
          ? DateTime.parse(json["passport_exp_date"])
          : (json.containsKey("passport_expirity_date") && json["passport_expirity_date"] != null)
              ? DateTime(int.parse(x[0]), int.parse(x[1]), int.parse(x[2]))
              : null,
      passportCountryIssued: json["passport_country_issued"],
      personType: json["person_type"],
      nationalityName: json["nationality_name"],
      passportCountry: json["passport_country"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "name": name,
        "surname": surname,
        "selected_title": selectedTitle,
        "nationatily": nationatily,
        "birthdate":
            "${birthdate!.year.toString().padLeft(4, '0')}-${birthdate!.month.toString().padLeft(2, '0')}-${birthdate!.day.toString().padLeft(2, '0')}",
        "passport_number": passportNumber,
        "passport_expirity_date":
            "${passportExpirityDate!.year.toString().padLeft(4, '0')}-${passportExpirityDate!.month.toString().padLeft(2, '0')}-${passportExpirityDate!.day.toString().padLeft(2, '0')}",
        "passport_country_issued": passportCountryIssued,
        "person_type": personType,
        "nationality_name": nationalityName,
        "passport_country": passportCountry,
      };
}

class PassengersDetail {
  final num? id;
  final num? userId;
  final String? personType;
  final String? type;
  final String? title;
  final String? name;
  final String? surname;
  final DateTime? dateOfBirth;
  final String? nationality;
  final String? passportNumber;
  final DateTime? passportExpDate;
  final String? countryPassportIssued;
  final String? email;
  final String? phoneCode;
  final String? phone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PassengersDetail({
    this.id,
    this.userId,
    this.personType,
    this.type,
    this.title,
    this.name,
    this.surname,
    this.dateOfBirth,
    this.nationality,
    this.passportNumber,
    this.passportExpDate,
    this.countryPassportIssued,
    this.email,
    this.phoneCode,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });

  factory PassengersDetail.fromJson(Map<String, dynamic> json) {
    final x = json["passport_exp_date"].toString().split("-");

    return PassengersDetail(
      id: json["id"],
      userId: json["user_id"],
      personType: json["person_type"],
      type: json["type"],
      title: json["title"],
      name: json["name"],
      surname: json["surname"],
      dateOfBirth: json["date_of_birth"] == null ? null : DateTime.parse(json["date_of_birth"]),
      nationality: json["nationality"],
      passportNumber: json["passport_number"],
      passportExpDate: json["passport_exp_date"] == null
          ? null
          : DateTime(int.parse(x[0]), int.parse(x[1]), int.parse(x[2])),
      countryPassportIssued: json["country_passport_issued"],
      email: json["email"],
      phoneCode: json["phone_code"],
      phone: json["phone"],
      createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "person_type": personType,
        "type": type,
        "title": title,
        "name": name,
        "surname": surname,
        "date_of_birth":
            "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
        "nationality": nationality,
        "passport_number": passportNumber,
        "passport_exp_date":
            "${passportExpDate!.year.toString().padLeft(4, '0')}-${passportExpDate!.month.toString().padLeft(2, '0')}-${passportExpDate!.day.toString().padLeft(2, '0')}",
        "country_passport_issued": countryPassportIssued,
        "email": email,
        "phone_code": phoneCode,
        "phone": phone,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

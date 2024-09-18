// To parse required this JSON data, do
//
//     final PrebookPassengerDataModel = prebookPassengerToJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

PrebookPassengerDataModel formsFromJson(String str) =>
    PrebookPassengerDataModel.fromJson(json.decode(str));

String prebookPassengerToJson(PrebookPassengerDataModel data) => json.encode(data.toJson());

class PrebookPassengerDataModel {
  PrebookPassengerDataModel(
      {required this.id,
      required this.ageType,
      required this.type,
      required this.firstName,
      required this.surname,
      required this.dateofbirth,
      required this.passportissuedcountry,
      required this.passportnumber,
      required this.passportexpirydate,
      required this.nationality,
      required this.holderType,
      required this.email,
      required this.phone,
      this.phoneCode});
  dynamic id;
  String type;
  String ageType;
  String firstName;
  String surname;
  String dateofbirth;
  String passportissuedcountry;
  String passportnumber;
  String passportexpirydate;
  String nationality;
  String holderType;
  String email;
  String phone;
  String? phoneCode;

  factory PrebookPassengerDataModel.fromJson(Map<String, dynamic> json) =>
      PrebookPassengerDataModel(
          id: json["id"],
          ageType: json["guestAgeType"],
          type: json["selected_title"],
          firstName: json["FirstName"],
          surname: json["Surname"],
          dateofbirth: json["Dateofbirth"],
          passportissuedcountry: json["Passportissuedcountry"],
          passportnumber: json["Passportnumber"] ?? "",
          passportexpirydate: json["Passportexpirydate"],
          nationality: json["Nationality"],
          holderType: json.containsKey("type") ? json["type"] : '',
          email: json.containsKey('email') ? json["email"] : '',
          phone: json.containsKey("phone") ? json["phone"] : "");

  Map<String, dynamic> toJson() => {
        "type": "holder",
        "guestId": id,
        "guestType": "",
        "guestAgeType": ageType,
        "guestTitle": type,
        "guestName": firstName,
        "guestSurame": surname,
        "guestDob": dateofbirth,
        "guestPassportIssue": passportissuedcountry,
        "guestPassportNo": passportnumber,
        "guestPassportExpiry": passportexpirydate,
        "guestNationality": nationality,
        "email": email,
        "phone": phone
      };

  Map<String, dynamic> updatePassengerToUserTOJSON() => {
        "passenger_id": id,
        "title": type,
        "email": email,
        "first_name": firstName,
        "last_name": surname,
        "dob": dateofbirth,
        "phone": phone,
        "phone_code": '',
        "passport_number": passportnumber,
        "passport_expiry": passportexpirydate,
        "nationality": nationality,
        'type': "passenger"
      };
}

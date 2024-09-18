// final activitiesListModel = activitiesListModelFromJson(jsonString);

import 'dart:convert';

ActivitiesListModel activitiesListModelFromJson(String str) =>
    ActivitiesListModel.fromJson(json.decode(str));

String activitiesListModelToJson(ActivitiesListModel data) => json.encode(data.toJson());

class ActivitiesListModel {
  final bool? error;
  final bool? availability;
  final List<AvailableActivity>? data;

  ActivitiesListModel({
    this.error,
    this.availability,
    this.data,
  });

  factory ActivitiesListModel.fromJson(Map<String, dynamic> json) => ActivitiesListModel(
        error: json["error"],
        availability: json["availability"],
        data: json["data"] == null
            ? []
            : List<AvailableActivity>.from(json["data"]!.map((x) => AvailableActivity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "availability": availability,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class AvailableActivity {
  final String? activityId;
  final String? name;
  final String? image;
  final String? content;
  final String? modalitiyCode;
  final String? modalitiyName;
  final String? currency;
  final String? modalityAmount;
  final String? activityOnlyCurrency;
  final num? activityOnlyAmount;

  AvailableActivity({
    this.activityId,
    this.name,
    this.image,
    this.content,
    this.modalitiyCode,
    this.modalitiyName,
    this.currency,
    this.modalityAmount,
    this.activityOnlyCurrency,
    this.activityOnlyAmount,
  });

  factory AvailableActivity.fromJson(Map<String, dynamic> json) => AvailableActivity(
        activityId: json["activity_id"],
        name: json["name"],
        image: json["image"],
        content: json["content"],
        modalitiyCode: json["modalitiy_code"].toString(),
        modalitiyName: json["modalitiy_name"].toString(),
        currency: json["currency"].toString(),
        modalityAmount: json["modality_amount"].toString(),
        activityOnlyCurrency: json["activity_only_currency"].toString(),
        activityOnlyAmount: json["activity_only_amount"],
      );

  Map<String, dynamic> toJson() => {
        "activity_id": activityId,
        "name": name,
        "image": image,
        "content": content,
        "modalitiy_code": modalitiyCode,
        "modalitiy_name": modalitiyName,
        "currency": currency,
        "modality_amount": modalityAmount,
        "activity_only_currency": activityOnlyCurrency,
        "activity_only_amount": activityOnlyAmount,
      };
}

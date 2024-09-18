// To parse this JSON data, do
//
//     final activityQuestions = activityQuestionsFromJson(jsonString);

import 'dart:convert';

ActivityQuestions activityQuestionsFromJson(String str) =>
    ActivityQuestions.fromJson(json.decode(str));

String activityQuestionsToJson(ActivityQuestions data) => json.encode(data.toJson());

class ActivityQuestions {
  final int? code;
  final bool? error;
  final String? message;
  final List<Questions>? data;

  ActivityQuestions({
    this.code,
    this.error,
    this.message,
    this.data,
  });

  factory ActivityQuestions.fromJson(Map<String, dynamic> json) => ActivityQuestions(
        code: json["code"],
        error: json["error"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Questions>.from(json["data"]!.map((x) => Questions.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "error": error,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Questions {
  final String? code;
  final String? text;
  final bool? required;
  final String? activityName;
  final String? activityCode;
  final String? activityId;
  final String? ibhCode;
  String? answer;

  Questions({
    this.code,
    this.text,
    this.required,
    this.activityName,
    this.activityCode,
    this.activityId,
    this.ibhCode,
    this.answer,
  });

  factory Questions.fromJson(Map<String, dynamic> json) => Questions(
        code: json["code"],
        text: json["text"],
        required: json["required"],
        activityName: json["activity_name"],
        activityCode: json["activity_code"],
        activityId: json["activity_id"],
        ibhCode: json["ibh_code"],
        answer: '',
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "text": text,
        "required": required,
        "ibh_code": ibhCode,
        "answer": answer,
      };
}

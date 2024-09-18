// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:umrah_by_lamar/common/request_manager.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/common/utility_var.dart';
import 'package:umrah_by_lamar/model/customize_models/package_customize_model.dart';

import '../common/network_static.dart';
import '../model/prebook_models/activity_questions_model.dart';
import '../model/prebook_models/booking_failed_reason_model.dart';
import '../model/prebook_models/passengers_for_prebook_models.dart';
import '../model/prebook_models/payment_failed_reason_model.dart';
import '../model/prebook_models/prebook_pricing_details_model.dart';
import '../model/prebook_models/prebook_result_model.dart';
import '../screen/booking/checkout_view.dart';

class PrebookController extends ChangeNotifier {
  PackageCustomizeModel? packageCustomize;

  void getCustomizeData(PackageCustomizeModel package) {
    packageCustomize = package;
  }

  Map<String, PrebookPassengerDataModel?> pax = {};

  Map prebookSpecialRequest = {};

  preparePassengers() {
    pax.clear();
    final childCount = (packageCustomize?.result?.children ?? 0).toInt();
    final adultCount = (packageCustomize?.result?.adults ?? 1).toInt();
    for (int i = 0; i < adultCount; i++) {
      pax['adult ${i + 1}'] = null;
    }
    for (int i = 0; i < childCount; i++) {
      pax['child ${i + 1}'] = null;
    }
  }

  ActivityQuestions? activityQuestions;

  Future<bool> getActivityQuestions() async {
    final jsonString = await ApiAdapter.getRequest(
        url: 'sort-activity-questions/${packageCustomize?.result?.customizeId ?? ''}');

    log(jsonString.toString());
    if (jsonString == null) return false;

    if (jsonString is String) {
      activityQuestions = activityQuestionsFromJson(jsonString);
      return true;
    } else {
      return false;
    }
  }

  PrebookResultModel? prebookResultModel;

  Future<Map<String, dynamic>> proceedPreBooking(token, gameCoin) async {
    Map<String, dynamic> userlogin = {
      "email": pax['adult 1']?.email ?? '',
      "phonecode": pax['adult 1']?.phoneCode ?? "",
      "phonenumber": pax['adult 1']?.phone,
      "selected_title": pax['adult 1']?.type,
      "surname": pax['adult 1']?.surname,
      "name": pax['adult 1']?.firstName,
      // "phonenumber": phoneNumer,
      // "phonecode": counterPhoneCode
    };
    Map<String, dynamic> prebookData = {
      "holder": userlogin,
      "token": token,
      "passengers": pax.values.map((e) => e?.toJson()).toList(),
      "sellingCurrency": UtilityVar.genCurrency,
      "customizeId": packageCustomize?.result?.customizeId ?? '',
      "specialRequest": prebookSpecialRequest,
      "accept_terms": true,
      "selected_language": UtilityVar.genLanguage,
      "selected_currency": UtilityVar.genCurrency,
      "game_coins": gameCoin,
      "activity_question_answers": activityQuestions?.data?.map((e) => e.toJson()).toList(),
    };
//hotelDebug=yes&flightDebug=yes&transferDebug=yes&activityDebug=yes&esimDebug=yes
    final jsonString = await ApiAdapter.postRequest(
        url:
            'holiday/prebook?&currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}',
        data: prebookData,
        version: '2');

    log(jsonString.toString());
    if (jsonString == null) return {"errorType": "null json", "status": false};

    if (jsonString is String) {
      prebookResultModel = prebookResultModelFromJson(jsonString);
      notifyListeners();

      return {"status": true};
    } else {
      final error = jsonEncode(jsonString['data']);

      if ((jsonString['statusCode'] ?? 0) == 409) {
        StaticVar().showToastMessage(message: jsonString['data']['message'], isError: true);
        return {"status": false, "errorType": "PAYMENT_IN_PROGRESS"};
      } else {
        prebookResultModel = prebookResultModelFromJson(error);
        notifyListeners();
        return {"status": false, "errorType": "Services"};
      }
    }
  }

  Future<Map> getPackageCancellationPrice(String packageID) async {
    final jsonString = await ApiAdapter.getRequest(
        url:
            "holiday/canx-policy?packageId=$packageID&customizeId=${prebookResultModel?.data?.customizeId}&currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}");

    log(jsonString.toString());
    if (jsonString == null) return {};

    if (jsonString is String) {
      final data = jsonDecode(jsonString);
      print(data);

      return {"total": data['data']['total'], "currency": data['data']['currency']};
    } else {
      return {};
    }
  }

  Future<PrebookPricingDetails?> updatePackagePrice(PaymentMethod paymentMethod) async {
    String paymentType = '';
    switch (paymentMethod) {
      case PaymentMethod.card:
        paymentType = 'ngenius';

        break;
      case PaymentMethod.coin:
        paymentType = 'coinbase';
        break;

      case PaymentMethod.creditAmount:
        paymentType = 'credit-balance';
        break;
    }

    final data = {
      "customizeId": prebookResultModel?.data?.customizeId ?? "",
      "paymentMethod": paymentType,
    };
    print(data);
    final jsonString = await ApiAdapter.postRequest(
        url: "holiday/prebook/update-payment", version: '2', data: data);
    if (jsonString == null) return null;

    log(jsonString);
    if (jsonString is String) {
      final prebookPricingDetails = prebookPricingDetailsFromJson(jsonString);
      return prebookPricingDetails;
    } else {
      return null;
    }
  }

  Future<PrebookPricingDetails?> applyCreditAmount(bool isApplied) async {
    final data = {
      "customizeId": packageCustomize?.result?.customizeId ?? "",
      "applyCredit": isApplied,
      "creditQuantity": prebookResultModel?.data?.userCredits?.creditCanBeUsed,
    };
    if (!isApplied) {
      data.remove('creditQuantity');
    }

    final jsonString =
        await ApiAdapter.postRequest(url: 'credit-balance/change', version: '2', data: data);

    if (jsonString == null) return null;

    if (jsonString is String) {
      final prebookPricingDetails = prebookPricingDetailsFromJson(jsonString);
      return prebookPricingDetails;
    } else {
      return null;
    }
  }

  Stream<Response> coinPaymentStreaming(String chargeID) async* {
    bool done = false;

    String url = "${baseUrl}coinbase/stream/$chargeID/created";
    Stream<Response> request;
    var headers = {
      'Content-Type': 'application/json',
      'mobile-os': Platform.isIOS ? 'ios' : 'android',
      // 'app_version': "${packageInfo!.buildNumber}"
    };

    int i = 1;

    while (true) {
      request = get(Uri.parse(url), headers: headers).asStream();
      request.listen((event) {
        final res = jsonDecode(event.body);
        print(res);
        if (res['data']['type'] != 'confirmed') {
          url = res['data']['next_url'];

          done = false;
        } else {
          done = true;
        }
      }, onDone: () {});

      yield* request;
    }
  }

  Map<String, dynamic> coinPaymentStatus = {};

  Map<String, dynamic> get getCoinPaymentStatus => coinPaymentStatus;

  set getCoinPaymentStatus(Map<String, dynamic> val) {
    coinPaymentStatus = val;
  }

  Future tryThis(String streamApi) async {
    bool done = false;

    String url = streamApi;
    print(url);

    var headers = {
      'Content-Type': 'application/json',
      'mobile-os': Platform.isIOS ? 'ios' : 'android',
      //'app_version': "${packageInfo!.buildNumber}"
    };
    int i = 0;

    while (!done) {
      var request = await get(Uri.parse(url), headers: headers);

      final res = jsonDecode(request.body);

      if (res['data']['type'] == 'confirmed' || res['data']['type'] == 'failed') {
        done = true;

        getCoinPaymentStatus = res;
      } else {
        getCoinPaymentStatus = res;

        if (res["data"].containsKey('next_url')) {
          url = res['data']['next_url'];
          print(res['data']['type']);
        }

        done = false;
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  int switchThePaymentResponse() {
    int status = 0;
    if (getCoinPaymentStatus.containsKey('code')) {
      status = getCoinPaymentStatus['code'];
    }

    return status;
  }

  Future<String> getCoinPaymentResult(String url) async {
    var request = Request('GET', Uri.parse(url));
    var headers = {
      'Content-Type': 'application/json',
      'mobile-os': Platform.isIOS ? 'ios' : 'android',
      // 'app_version': "${packageInfo!.buildNumber}"
    };

    request.headers.addAll(headers);
    StreamedResponse response = await request.send();
    final jsonString = await response.stream.bytesToString();

    final res = jsonDecode(jsonString);
    return res['message'];
  }

  bool stopCountDownTimer = false;

  bool get stopCountDownTimers => stopCountDownTimer;

  void setStopCountDownTimer(bool value) {
    stopCountDownTimer = value;
    notifyListeners();
  }

  Stream<Response> getRandomNumberFact(String url) async* {
    yield* Stream.periodic(Duration(seconds: 5), (_) {
      return get(Uri.parse(url));
    }).asyncMap((event) async {
      print("object");
      return await event;
    });
  }

  Future<PaymentFailedModel?> getPaymentFailedReason(String url) async {
    var request = Request('GET', Uri.parse(url));
    var headers = {
      'Content-Type': 'application/json',
      'mobile-os': Platform.isIOS ? 'ios' : 'android',
      //'app_version': "${packageInfo!.buildNumber}"
    };

    request.headers.addAll(headers);
    StreamedResponse response = await request.send();
    final jsonString = await response.stream.bytesToString();
    if (response.statusCode == 500) {
      return null;
    } else {
      final paymentFailedModel = paymentFailedModelFromMap(jsonString);
      return paymentFailedModel;
    }
  }

  Future<BookingFailedModel?> getBookingFailedReason(String url) async {
    var request = Request('GET', Uri.parse(url));
    var headers = {
      'Content-Type': 'application/json',
      'mobile-os': Platform.isIOS ? 'ios' : 'android',
      //   'app_version': "${packageInfo!.buildNumber}"
    };

    request.headers.addAll(headers);
    StreamedResponse response = await request.send();
    final jsonString = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return null;
    } else {
      final bookingFailedModel = bookingFailedModelFromMap(jsonString);
      return bookingFailedModel;
    }
  }
}

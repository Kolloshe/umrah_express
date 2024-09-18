import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:umrah_by_lamar/common/request_manager.dart';
import 'package:umrah_by_lamar/common/shear_pref.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/common/utility_var.dart';

import '../l10n/l10n.dart';
import '../model/common_models/booking_cancellation_policy_model.dart';
import '../model/common_models/cancel_booking_model.dart';
import '../model/user_models/user_bookings_data.dart';
import '../model/user_models/user_model.dart';

class UserController extends ChangeNotifier {
  Locale? _locale = const Locale('ar');

  bool isAR() {
    return _locale == const Locale('ar');
  }

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }

  Locale get locale => _locale!;

  void clearLocal() {
    _locale = null;
    notifyListeners();
  }

  UserModel? userModel;
  Future<bool> loginUser({required String email, required String password}) async {
    final data = {
      "email": email,
      "password": password,
    };

    final jsonString = await ApiAdapter.postRequest(
        url: 'user/login?currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}',
        data: data);

    if (jsonString == null) return false;

    if (jsonString is String) {
      userModel = userModelFromJson(jsonString);
      UtilityVar.userToken = userModel?.data?.token ?? "";

      LocalSavedData.setUserdata(userModel?.data?.token ?? "");

      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateUserInformation(data) async {
    UtilityVar.userToken = userModel?.data?.token ?? "";
    final jsonString = await ApiAdapter.putRequest(
        url: 'user/update-profile-data?language=${UtilityVar.genLanguage}', data: data);
    log(jsonString);

    if (jsonString == null) return false;

    if (jsonString is String) {
      userModel = userModelFromJson(jsonString);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> getUserProfileData() async {
    final jsonString = await ApiAdapter.getRequest(
        url:
            'user/get-profile-data?currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}',
        withOutLoader: true);

    if (jsonString == null) return false;

    if (jsonString is String) {
      userModel = userModelFromJson(jsonString);

      UtilityVar.genLanguage = userModel?.data?.language ?? "en";

      UtilityVar.genCurrency = userModel?.data?.currency ?? "AED";

      setLocale(Locale(UtilityVar.genLanguage));

      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future uploadUserImage(String base64image) async {
    final jsonString = await ApiAdapter.putRequest(
        url: 'user/update-profile-pic', data: {"profilePic": base64image});

    if (jsonString == null) return false;

    if (jsonString is String) {
      await getUserProfileData();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updatePassengerData({required Map<String, dynamic> data}) async {
    UtilityVar.userToken = userModel?.data?.token ?? '';
    final jsonString = await ApiAdapter.postRequest(
        url:
            'user/update-passenger-details?currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}&search_type=""',
        data: data);

    log(jsonString.toString());

    if (jsonString == null) return false;

    if (jsonString is String) {
      await getUserProfileData();

      return true;
    } else {
      return false;
    }
  }

  Future<bool> removeUserPassenger({required int id}) async {
    final jsonString = await ApiAdapter.deleteRequest(
        url: "user/delete-passenger/$id?language=${UtilityVar.genLanguage}");

    if (jsonString == null) return false;

    if (jsonString is String) {
      await getUserProfileData();
      notifyListeners();

      return true;
    } else {
      return false;
    }
  }

  UserBookingsDataModel? userBookingsDataModel;
  Future<bool> getUserBookingList() async {
    final jsonString = await ApiAdapter.getRequest(
        url:
            'user/bookings/all?currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}');

    if (jsonString == null) return false;

    if (jsonString is String) {
      userBookingsDataModel = userBookingsDataModelFromJson(jsonString);
      return true;
    } else {
      return false;
    }
  }

  // Future<List<String>> getCancellationReasons() async {
  //   final jsonString = await ApiAdapter.getRequest(
  //       url:
  //           "holiday/booking/cancellation/reasons?currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}");

  //   if (jsonString == null) return [];

  //   if (jsonString is String) {
  //     final cancellationReasonsModel = cancellationReasonsModelFromJson(jsonString);
  //     return cancellationReasonsModel.data ?? [];
  //   } else {
  //     return [];
  //   }
  // }

  Future<CancellationPolicyModel?> getBookingCancellationPolicy(id) async {
    final jsonString = await ApiAdapter.getRequest(
        url:
            "holiday/booking/cancellation/policy?reference=$id&currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}");

    if (jsonString == null) return null;

    if (jsonString is String) {
      final cancellationPolicyModel = cancellationPolicyModelFromJson(jsonString);
      return cancellationPolicyModel;
    } else {
      return null;
    }
  }

  Future<CancelBookingModel?> cancellBooking({required Map<String, dynamic> data}) async {
    final jsonString = await ApiAdapter.postRequest(
        url: 'holiday/cancel?currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}',
        data: data);

    if (jsonString == null) return null;

    if (jsonString is String) {
      final cancelBookingModel = cancelBookingModelFromMap(jsonString);
      return cancelBookingModel;
    } else {
      return null;
    }
  }

  Future<bool> resetPassword(Map<String, dynamic> userEmail) async {
    final jsonString = await ApiAdapter.postRequest(url: 'user/password/reset', data: userEmail);

    if (jsonString == null) return false;
    if (jsonString == String) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> changePassword({required Map<String, dynamic> data}) async {
    final jsonString = await ApiAdapter.putRequest(url: 'user/change-password', data: data);

    if (jsonString == null) return false;

    if (jsonString is String) {
      final message = jsonDecode(jsonString)['message'];
      StaticVar().showToastMessage(message: message.toString());
      return true;
    } else {
      StaticVar().showToastMessage(message: jsonString['data']['message'], isError: true);
      return false;
    }
  }

  Future<bool> logoutUser() async {
    final jsonString = await ApiAdapter.getRequest(url: 'user/logout');
    if (jsonString == null) return false;
    if (jsonString is String) {
      userModel = null;

      UtilityVar.userToken = '';
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> changeCurranceylanguage(Map<String, dynamic> data, String action) async {
    UtilityVar.userToken = userModel?.data?.token ?? "";
    final jsonString =
        await ApiAdapter.putRequest(url: "user/update-language-and-currency", data: data);

    if (jsonString == null) return false;

    if (jsonString is String) {
      switch (action.toLowerCase()) {
        case 'language':
          UtilityVar.genLanguage = data['language'];

          await LocalSavedData.setUserLocal(data['language']);

          break;

        case 'currency':
          UtilityVar.genLanguage = data['currency'];

          await LocalSavedData.setUserCurrency(data['currency']);
          break;
        default:
          break;
      }
      await getUserProfileData();
      notifyListeners();

      return true;
    } else {
      return false;
    }
  }

  Future<bool> registrUser(Map<String, String> data) async {
    final jsonString = await ApiAdapter.postRequest(
        url:
            "user/mob/preregistration?currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}",
        data: data);

    if (jsonString == null) return false;
    if (jsonString is String) {
      userModel = userModelFromJson(jsonString);
      UtilityVar.userToken = userModel?.data?.token ?? "";
      return true;
    } else {
      return false;
    }
  }
}

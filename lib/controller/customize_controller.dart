import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../common/request_manager.dart';
import '../common/utility_var.dart';
import '../model/customize_models/activity_model/activites_list_model.dart';
import '../model/customize_models/esim_model/esim_listing_model.dart';
import '../model/customize_models/flights_model/flights_listing_model.dart';
import '../model/customize_models/hotel_model/hotel_listing_model.dart';
import '../model/customize_models/package_customize_model.dart';
import '../model/customize_models/transfer_model/transfer_listing_model.dart';

class CustomizeController extends ChangeNotifier {
  PackageCustomizeModel? packageCustomize;

  Future<bool> customizePackage(String id) async {
    final jsonString = await ApiAdapter.getRequest(
        url: 'holiday/customize?package_id=$id&currency=${UtilityVar.genCurrency}&language=ar');
    print(jsonString);
    if (jsonString == null) return false;

    if (jsonString is String) {
      packageCustomize = packageCustomizeModelFromJson(jsonString);
      return true;
    } else {
      return false;
    }
  }

  Future<FlightsListingModel?> getFlightsListing() async {
    final jsonString = await ApiAdapter.getRequest(
        url:
            "holiday/change_flight?holidayCustomizeId=${packageCustomize?.result?.customizeId ?? ''}"
            "&flightClass=${packageCustomize?.result?.flight?.flightClass ?? ''}&currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}");

    if (jsonString == null) return null;

    if (jsonString is String) {
      final flightsListingModel = flightsListingModelFromJson(jsonString);

      return flightsListingModel;
    } else {
      return null;
    }
  }

  Future<bool> changeFlights(flightID) async {
    final data = {
      "flightId": flightID,
      "customizeId": packageCustomize?.result?.customizeId ?? '',
      "sellingCurrency": UtilityVar.genCurrency,
      "language": UtilityVar.genLanguage
    };

    final jsonString = await ApiAdapter.postRequest(
        url:
            'holiday/update_flight?currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}',
        data: data);

    if (jsonString == null) return false;

    if (jsonString is String) {
      log(jsonString);
      final result = await updatePackageDetails(packageCustomize?.result?.customizeId);
      // await updateFlightTransferHotelData(packageCustomize?.result?.customizeId ?? '');

      notifyListeners();
      return result;
    } else {
      return false;
    }
  }

  /* Update transfer hotel flight after changing flights
  */
  Future<bool> updateFlightTransferHotelData(packID) async {
    final jsonString = await ApiAdapter.getRequest(
        url:
            'holiday/transfer_hotel_flight_change?customizeId=$packID&currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}');

    if (jsonString == null) return false;

    if (jsonString is String) {
      //  print(jsonString.toString());
      final result = await updateHotelCheckIn(packID);
      return result;
    } else {
      return false;
    }
  }

  Future<bool> updatePackageDetails(packId) async {
    final jsonString = await ApiAdapter.getRequest(
        url:
            'holiday/customize?customizeId=$packId&selling_currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}');

    if (jsonString == null) return false;

    if (jsonString is String) {
      packageCustomize = packageCustomizeModelFromJson(jsonString);
      notifyListeners();

      return true;
    } else {
      return false;
    }
  }

  /*
  HOTELS
   */
  Future<bool> updateHotelCheckIn(packId) async {
    final jsonString = await ApiAdapter.getRequest(
        url:
            'holiday/check_hotel_checkin?customizeId=$packId&currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}&fn=mobapi');

    if (jsonString == null) return false;

    if (jsonString is String) {
      final result = await updatePackageDetails(packId);

      return result;
    } else {
      return false;
    }
  }

  HotelListModel? hotelListModel;
  Future<bool> getHotelListing(
      {required checkIn, required checkOut, required hotelID, required star}) async {
    final jsonString = await ApiAdapter.getRequest(
        url:
            'holiday/change_hotel?customizeId=${packageCustomize?.result?.customizeId ?? ''}&checkIn=$checkIn&checkOut=$checkOut&hId=$hotelID&star=$star&action=changeHotel&currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}');

    if (jsonString == null) return false;

    if (jsonString is String) {
      hotelListModel = hotelListModelFromJson(jsonString);

      return true;
    } else {
      return false;
    }
  }

  Future<Map> getHotelCancellationPolicy(rateKey) async {
    final data = {
      "customizeId": packageCustomize?.result?.customizeId ?? '',
      "currency": UtilityVar.genCurrency,
      "rateKey": rateKey
    };

    final jsonString = await ApiAdapter.postRequest(url: 'holiday/hotel-canx-policy', data: data);

    if (jsonString == null) return {};

    if (jsonString is String) {
      final data = jsonDecode(jsonString);

      return data;
    } else {
      return {};
    }
  }

  Future<bool> changeHotelRoom(List<Room> room) async {
    final data = {
      "customizeId": packageCustomize?.result?.customizeId ?? '',
      "hotelId": (packageCustomize?.result?.hotels ?? <Hotel>[]).first.id ?? 0,
      "hotelKey": 0,
      "selectedRoom": room,
      "currency": UtilityVar.genCurrency,
      "language": UtilityVar.genLanguage
    };
    final jsonString = await ApiAdapter.postRequest(
        url:
            'holiday/split-hotel/change-room?currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}',
        data: data);

    if (jsonString == null) return false;

    if (jsonString is String) {
      packageCustomize = packageCustomizeModelFromJson(jsonString);

      print(packageCustomize?.result?.hotels?.first.selectedRoom?.first.boardName);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> changeTheHotel({hotelId, hotelKey, selectedRoom}) async {
    final data = {
      "customizeId": packageCustomize?.result?.customizeId ?? '',
      "hotelId": (packageCustomize?.result?.hotels ?? []).first.id ?? '',
      "newHotelId": hotelId,
      "hotelKey": hotelKey,
      "selectedRoom": selectedRoom,
      "currency": UtilityVar.genCurrency,
      "language": UtilityVar.genLanguage
    };

    final jsonString = await ApiAdapter.postRequest(
        url:
            "holiday/split-hotel/change-hotel?currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}",
        data: data);

    if (jsonString == null) return false;

    if (jsonString is String) {
      packageCustomize = packageCustomizeModelFromJson(jsonString);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
  // ACTIVITY

  Map<DateTime, Activity?> prepareActivity() {
    final firstPackageDay = getFirstPackageDay();

    final Map<DateTime, Activity?> activityOprationList = {};

    final List<Activity> actitviyList = packageCustomize?.result?.activities?.values
            .map((e) => e)
            .toList()
            .expand((element) => element)
            .toList() ??
        <Activity>[];

    for (int i = 0; i < (packageCustomize?.result?.packageDays ?? 0); i++) {
      final day = firstPackageDay.add(Duration(days: i));

      activityOprationList.putIfAbsent(day, () => null);
    }

    for (var element in actitviyList) {
      if (activityOprationList.containsKey(element.activityDate)) {
        activityOprationList[element.activityDate ?? DateTime.now()] = element;
      }
    }
    return activityOprationList;
  }

  DateTime getFirstPackageDay() {
    DateTime date;
    if ((packageCustomize?.result?.noFlight ?? false) != true) {
      date = packageCustomize?.result?.flight?.from?.arrivalFdate ?? DateTime.now();
    } else {
      date = packageCustomize?.result?.packageStart ?? DateTime.now();
    }
    return date;
  }

  bool checkFirstDayForActivity() {
    const maxAllowedDate = 12;

    bool isArrivalInSameDate = ((packageCustomize?.result?.noFlight ?? false) != true)
        ? packageCustomize?.result?.flight?.from?.departureFdate ==
            (packageCustomize?.result?.flight?.from?.arrivalFdate ?? DateTime.now())
        : true;

    int arrivalTime = ((packageCustomize?.result?.noFlight ?? false) != true)
        ? int.tryParse(
                (packageCustomize?.result?.flight?.from?.arrivalTime ?? '13').substring(0, 2)) ??
            13
        : 7;

    print(((arrivalTime < maxAllowedDate) && isArrivalInSameDate));

    if ((arrivalTime < maxAllowedDate) && isArrivalInSameDate) {
      return true;
    } else {
      return false;
    }
  }

  bool checkActiviyLastDay() {
    bool canBook = true;

    if (packageCustomize?.result?.flight != null) {
      const int maxAllowedtime = 9;

      int time =
          int.parse((packageCustomize?.result?.flight?.to?.departureTime ?? '12').substring(0, 2));
      if (time < maxAllowedtime) {
        canBook = true;
      } else {
        canBook = false;
      }
      return canBook;
    } else {
      return canBook;
    }
  }

  ActivitiesListModel? activitiesListModel;

  Future<bool> getActivityList(activityDay) async {
    final jsonString = await ApiAdapter.getRequest(
        url:
            'holiday/change_activity?searchId=${packageCustomize?.result?.searchId ?? 0}&customizeId=${packageCustomize?.result?.customizeId ?? 0}&activityDay=$activityDay&currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}&priceSort=asc&nameSort=&searchQuery=');

    if (jsonString == null) return false;

    if (jsonString is String) {
      log(jsonString);
      activitiesListModel = activitiesListModelFromJson(jsonString);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateActivity({required activityId, required activityDay}) async {
    final data = {
      "customizeId": packageCustomize?.result?.customizeId ?? '',
      "activityIds": [activityId],
      "activityDay": activityDay,
      "currency": UtilityVar.genCurrency,
      "language": UtilityVar.genLanguage
    };

    final jsonString = await ApiAdapter.postRequest(
        url:
            'holiday/update_activity?currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}',
        data: data);

    if (jsonString == null) return false;

    if (jsonString is String) {
      log(jsonString);
      final result = await updatePackageDetails(packageCustomize?.result?.customizeId ?? '');
      return result;
    } else {
      return false;
    }
  }

  Future<bool> removeSingleActivity({required activityId, required activityDate}) async {
    final jsonString = await ApiAdapter.getRequest(
        url:
            'holiday/remove_activity?customizeId=${packageCustomize?.result?.customizeId ?? ''}&activityId=$activityId&activityDate=$activityDate&currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}');

    if (jsonString == null) return false;

    if (jsonString is String) {
      final result = await updatePackageDetails(packageCustomize?.result?.customizeId ?? '');
      return result;
    } else {
      return false;
    }
  }

  TransferListModel? transferListModel;

  Future<bool> getTransferListing() async {
    final jsonString = await ApiAdapter.getRequest(
        url:
            'holiday/transfer-list-inout?&currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}&customizeId=${packageCustomize?.result?.customizeId ?? ''}');

    if (jsonString == null) return false;

    if (jsonString is String) {
      log(jsonString);
      transferListModel = transferListModelFromJson(jsonString);

      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateTransfer({required String inTransferId, required String outTransferId}) async {
    final jsonString = await ApiAdapter.putRequest(
        url:
            'holiday/transfer-update-inout?currency=${UtilityVar.genCurrency}&customizeId=${packageCustomize?.result?.customizeId ?? ''}&in=$inTransferId&out=$outTransferId&language=${UtilityVar.genLanguage}');

    if (jsonString == null) return false;

    if (jsonString is String) {
      packageCustomize = packageCustomizeModelFromJson(jsonString);
      notifyListeners();

      return true;
    } else {
      return false;
    }
  }

  EsimListModel? esimListModel;

  Future<bool> getEsimListing() async {
    final jsonString = await ApiAdapter.getRequest(
        url:
            'holiday/esim-list?customizeId=${packageCustomize?.result?.customizeId ?? ""}&currency=${UtilityVar.genCurrency}');

    if (jsonString == null) return false;

    if (jsonString is String) {
      esimListModel = esimListModelFromJson(jsonString);

      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateEsim(simId) async {
    final data = {
      "customizeId": packageCustomize?.result?.customizeId ?? '',
      "simPackageId": simId,
      "sellingCurrency": UtilityVar.genCurrency
    };

    final jsonString = await ApiAdapter.putRequest(url: 'holiday/update-esim', data: data);

    if (jsonString == null) return false;

    if (jsonString is String) {
      packageCustomize = packageCustomizeModelFromJson(jsonString);
      notifyListeners();

      return true;
    } else {
      return false;
    }
  }

  Future<bool> serviceManager({required String action, required String type}) async {
    final jsonString = await ApiAdapter.getRequest(
        url:
            'holiday/service/$action/$type?customizeId=${packageCustomize?.result?.customizeId}&selling_currency=${UtilityVar.genCurrency}&currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}');

    if (jsonString == null) return false;

    if (jsonString is String) {
      packageCustomize = packageCustomizeModelFromJson(jsonString);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}

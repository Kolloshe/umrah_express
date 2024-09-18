import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:umrah_by_lamar/common/request_manager.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/common/utility_var.dart';
import 'package:intl/intl.dart';

import '../common/network_static.dart';
import '../common/shear_pref.dart';
import '../model/common_models/privet_jet_category_model.dart';
import '../model/search_models/ind_transfer_search_model.dart';
import '../model/search_models/payload.dart';
import '../model/search_models/search_result_models/search_result_model.dart';
import '../screen/search/search_v2/holiday_search/holiday_search_stepper.dart';
import '../screen/search/search_v2/search_stepper_v2.dart';

class PackSearchController extends ChangeNotifier {
  String searchMode = '';

  num userCollectedPoint = 0;

  String selectedflightcode = '';
  String selectdHoteltcode = '';

  int adultCount = 1;

  int seniorTravelers = 0;

  int roomsCount = 1;

  int paxCountForPrivetJet = 1;

  CategoryData? privateJetCategory;

  void resetApp() {
    selectedflightcode = '';
    selectdHoteltcode = '';

    notifyListeners();
  }

  void userCollectedCoinFromGame(num coin) {
    userCollectedPoint = coin;
    notifyListeners();
  }

  String title = '';

  void newSearchTitle(String titles) {
    title = titles;
    notifyListeners();
  }

  bool isDiscountDialog = false;

  void handleTheDisountDialog(bool value) {
    isDiscountDialog = value;
    notifyListeners();
  }

  bool isloadedonce = false;

  void handelTheloading(bool state) {
    isloadedonce = state;
    notifyListeners();
  }

  // SEARCH FOR TRANSFER PAYLOAD
  Future<IndTransferSearchModel?> getCityForTransfer(
      String query, String id, airportCode, city) async {
    final jsonString = await ApiAdapter.getRequest(
        url:
            'transfer/location?search=$query&country_code=$id&airport_code=$airportCode&&city=$city',
        version: '2');

    log(jsonString.toString());

    if (jsonString == null) return null;

    if (jsonString is String) {
      final indTransferSearchModel = indTransferSearchModelFromJson(jsonString);
      return indTransferSearchModel;
    } else {
      return null;
    }
  }

  Future<List<PayloadElement>> searchForCity(String cityName, {bool? withOutLoader = false}) async {
    final jsonString = await ApiAdapter.getRequest(
        withOutLoader: withOutLoader,
        url:
            'holiday/destination_list?destination=$cityName&currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}');
    log(jsonString.toString());
    if (jsonString == null) return [];

    if (jsonString is String) {
      final payload = payloadFromJson(jsonString);

      return payload.payload;
    } else {
      return [];
    }
  }

  PayloadElement? payloadFromlocation;

  void getpayloadFromlocation(PayloadElement payload) {
    payloadFromlocation = payload;
    notifyListeners();
  }

  PayloadElement? payloadWhichCityForTransfer;

  void getPayloadWhichCity(PayloadElement payload) {
    payloadWhichCityForTransfer = payload;
    notifyListeners();
  }

  List<PayloadElement> cities = [];

  //////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////
  //////////////////// SEARCH DATA VAR /////////////////////
  //////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////

  void gitcities(List<PayloadElement> citity) {
    cities = citity;
    notifyListeners();
  }

  PayloadElement? payloadFrom;

  void getpayloadFrom(PayloadElement payload) {
    payloadFrom = payload;

    notifyListeners();
  }

  PayloadElement? payloadto;

  void getpayloadTo(PayloadElement payload) {
    payloadto = payload;
    notifyListeners();
  }

  initPayloadTo() async {
    List<PayloadElement> distnation = [];

    distnation = await searchForCity('مكه', withOutLoader: true);

    if (distnation.isNotEmpty) {
      payloadto = distnation.first;
      return;
    } else {
      distnation = await searchForCity("Makkah", withOutLoader: true);

      if (distnation.isNotEmpty) {
        payloadto = distnation.first;
        return;
      } else {
        payloadto ??= PayloadElement.fromJson({
          "id": 26377,
          "city_name": "مكه",
          "destination_name": "Makkah",
          "country_name": "Saudi arabia",
          "country_code": "SA",
          "city_code": "QCA",
          "airport_code": "TIF",
          "hotel_counts": 41
        });
        return;
      }
    }
  }

  Map<String, DateTime> selectedDatas = {
    "start_date": DateTime.now().add(const Duration(days: 3)),
    "end_date": DateTime.now().add(const Duration(days: 8))
  };

  void selectedDateRage(Map<String, DateTime> dates) {
    selectedDatas = dates;
  }

  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////

  Map<String, IndTransferSearchResultData> transferPointsData = {};

  Map<String, IndTransferSearchResultData> get transferIndPoints => transferPointsData;

  set transferIndPoints(Map<String, IndTransferSearchResultData> val) {
    transferPointsData = val;
  }

  void injectTransferIndPoint(String key, IndTransferSearchResultData val) {
    transferPointsData.update(key, (value) => val, ifAbsent: () => val);
  }

  Future getPayloadFromLocation(String citiy) async {}
  List<PayloadElement> umrahDistnations = [];
  Future<List<PayloadElement>> getUmrahArrivalLocation() async {
    final jsonString = await ApiAdapter.getRequest(url: "umrah/destinations");

    if (jsonString == null) return [];

    if (jsonString is String) {
      final json = jsonDecode(jsonString);
      umrahDistnations = List<PayloadElement>.from(json.map((x) => PayloadElement.fromJson(x)));
      return umrahDistnations;
    } else {
      return [];
    }
  }

  Future? getSectionSearchData(SearchSections sections, String quere, bool? isTransfer) {
    if ((isTransfer ?? false) == true) {
      return getCityForTransfer(
          quere, payloadFrom?.countryCode ?? "", payloadFrom?.airportCode, payloadFrom?.cityName);
    } else {
      switch (sections) {
        case SearchSections.whereFrom:
          return searchForCity(quere);
        case SearchSections.toWhere:
          return searchForCity(quere);
        case SearchSections.selectCity:
          return searchForCity(quere);
        // return getCityForTransfer(
        //     quere, payloadFrom?.countryCode ?? "", payloadFrom?.airportCode, payloadFrom?.cityName);

        default:
          return null;
      }
    }
  }

  int childCount = 0;

  get childCountSetter => childCount;

  set childCountSetter(val) {
    childCount = val;

    if (childAges.length > childCount) {
      if (childAges.containsKey(childCount + 1)) {
        childAges.remove(childCount + 1);
      }
    } else {
      childAges[childCount] = 1;
    }
  }

  Map<int, int> childAges = {};

  getChildrenAges({required int key, required int age}) {
    childAges.remove(0);
    childAges[key] = age;
    print(childAges);
  }

  String formatChildrenAges() {
    // "childAge[1][1]=3&childAge[1][2]=5";

    String data = '';

    childAges.forEach((key, value) {
      data = "${data}childAge[1][$key]=$value&";
    });

    return data;
  }

  String formatTheDates(DateTime date) => DateFormat('dd/MM/y').format(date);

  SearchResultModel? searchResultModel;

  List<Package> packages = [];

  String flightClass = 'Y';

  getFlightClass(selectedFlightClass) {
    switch (selectedFlightClass) {
      case FlightClass.economy:
        flightClass = 'Y';
        break;
      case FlightClass.premiumEconomy:
        flightClass = 'W';
        break;
      case FlightClass.business:
        flightClass = 'C';
        break;
      case FlightClass.firstClass:
        flightClass = 'F';
        break;
    }
  }

  String searchNationality = "AE";
  int hotelStar = 4;
  Future<bool> makeSearchData({bool? withOutLoadder = false, String? url}) async {
    String url = 'holiday/search?'
        'os=${Platform.isIOS ? "ios" : "android"}&'
        'app_version=33&'
        'package_start=${formatTheDates(selectedDatas['start_date']!)}&'
        'package_end=${formatTheDates(searchMode == 'activity' ? selectedDatas['start_date']! : selectedDatas['end_date']!)}&'
        'departure_code=${searchMode == 'activity' ? payloadto?.id : payloadFrom?.id}&'
        'arrival_code=${payloadto?.id}&'
        'hotelCode=&'
        'flightCode=&'
        'search_Type=1&'
        'flightClass=$flightClass&'
        'rooms[1]=$roomsCount&'
        'adults[1]=$adultCount&'
        'children[1]=$childCount&'
        '${formatChildrenAges()}'
        'hotelStar=$hotelStar&'
        'currency=${UtilityVar.genCurrency}&'
        'language=${UtilityVar.genLanguage}&'
        'selling_currency=${UtilityVar.genCurrency}&'
        'searchRequest=1&'
        'nationality=$searchNationality&'
        'searchMode=$searchMode';
    if (url != null) {
      url = url;
    }

    LocalSavedData.setSearchData(url);
    final jsonString = await ApiAdapter.getRequest(url: url, withOutLoader: withOutLoadder);
    if (jsonString == null) return false;

    if (jsonString is String) {
      searchResultModel = searchResultModelFromJson(jsonString);
      prepearFilter();

      return true;
    } else {
      return false;
    }
  }

  Future loadMorePackages() async {
    if (searchResultModel == null) return;
    final jsonString = await ApiAdapter.getRequest(
        url: "holiday/second-search?packageId=${searchResultModel?.data?.packageId}",
        withOutLoader: true);

    if (jsonString == null) return;

    if (jsonString is String) {
      final data = searchResultModelFromJson(jsonString);
      if ((data.data?.secondAPISearch ?? false) == false) {
        loadMorePackages();
      } else {
        searchResultModel = data;
      }

      prepearFilter();
      print(searchResultModel?.data?.totalPackages);
      notifyListeners();
      return true;
    } else {
      if (jsonString["data"]["code"] == 400) {
        return false;
      } else {
        await Future.delayed(
          Duration(seconds: 2),
        );
        loadMorePackages();
      }
    }

    // bool stop = false;
    // int status = 422;
    // try {
    //   while (stop == false) {
    //     final jsonString = await response.body;

    //     print(jsonString);

    //     status = response.statusCode;

    //     if (response.statusCode == 200) {
    //       mainSarchFor = mainSarchForPackageFromJson(jsonString);
    //       print(mainSarchFor.data.secondAPISearch);
    //       context.read<AppData>().loadMorePackages(mainSarchFor);
    //       stop = true;
    //       if (mainSarchFor.data.secondAPISearch == false) {}
    //     } else if (response.statusCode == 400) {
    //       client.close();
    //       stop = true;
    //     } else {
    //       await Future.delayed(Duration(seconds: 30), () {
    //         print('delayed');
    //       });

    //       if (jsonString.isEmpty) {
    //         return null;
    //       }
    //     }
    //   }
    // } catch (e) {
    //   if (status == 400) {
    //     client.close();

    //     stop = true;
    //     return mainSarchFor;
    //   } else if (status == 422) {
    //     return loadMorePackages(id, context);
    //   }
    // }
    // return mainSarchFor;
  }

  Map<String, dynamic> transferPoints = {};

  Future<bool> makeSearchForTransfer() async {
    // print(transferPoints);
    final data = {
      "selling_currency": UtilityVar.genCurrency,
      "transfer_type": transferPoints['tripType'],
      "pickup_code": transferPoints['from']?.code,
      "pickup_mode": transferPoints['from']?.category,
      "dropoff_code": transferPoints['to']?.code,
      "dropoff_mode": transferPoints['to']?.category,
      "pax": {
        "adults": adultCount,
        "children": childCount,
        "children_age": childAges.map((key, value) => MapEntry(key.toString(), value.toString())),
      },
      "pickup": transferPoints["departure"],
      "return": transferPoints["return"],
      "country": {
        "pickup": transferPoints['from']?.country,
        "dropoff": transferPoints['to']?.country
      },
    };

    final jsonString =
        await ApiAdapter.postRequest(url: "transfer/search", version: '2', data: data);

    if (jsonString == null) return false;

    if (jsonString is String) {
      searchResultModel = searchResultModelFromJson(jsonString);
      return true;
    } else {
      return false;
    }
  }

  Future<String?> genarateDynamicLinks({required String id, required String level}) async {
    final jsonString = await ApiAdapter.getRequest(
        url:
            'share?$level=$id&currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}');

    if (jsonString == null) return null;

    if (jsonString is String) {
      final data = jsonDecode(jsonString);
      return data['data']['shortLink'];
    } else {
      return null;
    }
  }

  Map paxInformationForTravelInsuranceOrPrivetGet = {};
  void preparePaxInformation(ServiceType serviceType) {
    paxInformationForTravelInsuranceOrPrivetGet.clear();
    // if (serviceType == ServiceType.privetGet) {
    //   paxInformationForTravelInsuranceOrPrivetGet.putIfAbsent("Holder", () => null);
    // } else {
    for (int i = 1; i <= adultCount; i++) {
      paxInformationForTravelInsuranceOrPrivetGet.putIfAbsent("adult $i", () => null);
    }

    for (int i = 1; i <= childCount; i++) {
      paxInformationForTravelInsuranceOrPrivetGet.putIfAbsent("child $i", () => null);
    }
    for (int i = 1; i <= seniorTravelers; i++) {
      paxInformationForTravelInsuranceOrPrivetGet.putIfAbsent("senior Traveler $i", () => null);
    }
    // }
  }

  Map travelInsuranceHolder = {};

  void holderDetails(Map<String, dynamic> holder) {
    travelInsuranceHolder = holder;
  }

  Map<String, Map> travelInsuranceBeneficiaries = {};
  void travelInsuranceBeneficiariesDetails(key, Map<String, dynamic> data) {
    travelInsuranceBeneficiaries[key] = data;
  }

  Future<bool> sendToTravelInsurance() async {
    final data = {
      "from": payloadFrom?.countryCode,
      "to": payloadto?.countryCode,
      "departure": {"date": DateFormat('y-M-d').format(selectedDatas['start_date']!), "time": null},
      "return": {"date": DateFormat('y-M-d').format(selectedDatas['end_date']!), "time": null},
      "category_id": null,
      "holder": travelInsuranceHolder,
      "beneficiaries": travelInsuranceBeneficiaries.values.toList()
    };

    final jsonString =
        await ApiAdapter.postRequest(url: 'enquiry/travel-insurance/submit', data: data);
    if (jsonString == null) return false;

    if (jsonString is String) {
      return true;
    } else {
      return false;
    }
  }

  PrivateJetCategories? privateJetCategories;
  Future<bool> getPrivetJetCategories() async {
    final jsonString = await ApiAdapter.getRequest(url: 'enquiry/private-jet/categories');

    if (jsonString == null) return false;

    if (jsonString is String) {
      privateJetCategories = privateJetCategoriesFromJson(jsonString);
      privateJetCategory = privateJetCategories?.data?.first;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> sendToPrivetJet() async {
    if (transferPoints['tripType'].toString() == "one") {
      transferPoints.remove('return');
    }
    final privetJetRequestData = {
      "search_type": transferPoints['tripType'],
      "from": payloadFrom?.countryCode,
      "to": payloadto?.countryCode,
      "departure": transferPoints['departure'],
      "return": transferPoints['return'],
      "category_id": privateJetCategory?.id,
      "pax": paxCountForPrivetJet,
      "holder": travelInsuranceHolder,
    };

    final jsonString =
        await ApiAdapter.postRequest(url: "enquiry/private-jet/submit", data: privetJetRequestData);
    if (jsonString == null) return false;

    if (jsonString == String) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> searchFormTreanding({required String url, bool? withOutLoadder = false}) async {
    url = "${url.replaceAll(baseUrl, '')}&os=ios&app_version=33";
    final jsonString = await ApiAdapter.getRequest(url: url, withOutLoader: withOutLoadder);
    if (jsonString == null) return false;

    if (jsonString is String) {
      searchResultModel = searchResultModelFromJson(jsonString);

      prepearFilter();
      return true;
    } else {
      return false;
    }
  }

  Map filterData = {
    "3 star": true,
    "4 star": true,
    "5 star": true,
    "non stop": true,
    "1 stop": true,
    "multi stop": true,
    "max": 0,
    "min": 0
  };

  prepearFilter() {
    packages = searchResultModel?.data?.packages ?? <Package>[].map((e) => e).toList();
    filterData['min'] = searchResultModel?.data?.priceRange?.min ?? 0;
    filterData['max'] = searchResultModel?.data?.priceRange?.max ?? 0;
  }

  bool processedFilter() {
    packages = packages
        .where((element) => ((element.total ?? 1) <= filterData["max"] &&
            (element.total ?? 1) >= filterData["min"]))
        .where((element) =>
            ((filterData["3 star"]) && (element.hotelStar ?? 0) == 3) ||
            ((filterData["4 star"]) && (element.hotelStar ?? 0) == 4) ||
            ((filterData["5 star"]) && (element.hotelStar ?? 0) == 5) ||
            ((filterData["non stop"]) && (element.flightStop ?? 0) == 0) ||
            ((filterData["1 stop"]) && (element.flightStop ?? 1) == 1) ||
            ((filterData["multi stop"]) && (element.flightStop ?? 1) > 1))
        .toList();

    if (packages.isEmpty) {
      StaticVar().showToastMessage(message: 'They are no available packages');
      prepearFilter();
      notifyListeners();
      return false;
    } else {
      StaticVar().showToastMessage(message: '${packages.length} packages available');
      notifyListeners();
      return true;
    }
  }
}

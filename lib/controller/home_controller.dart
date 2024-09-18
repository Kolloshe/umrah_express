import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:umrah_by_lamar/common/request_manager.dart';
import 'package:umrah_by_lamar/common/utility_var.dart';

import '../model/common_models/geo_data_model.dart';
import '../model/home_models/home_data_model.dart';
import '../model/home_models/promotion_list_model.dart';

class HomeController extends ChangeNotifier {
  ApiGeoData? userGeoData;
  Future<ApiGeoData?> getGeoData() async {
    final jsonString = await ApiAdapter.getRequest(
        withOutLoader: true, url: 'geo-data?language=${UtilityVar.genLanguage}');

    if (jsonString == null) return null;
    if (jsonString is String) {
      userGeoData = apiGeoDataFromJson(jsonString);

      return userGeoData;
    } else {
      return null;
    }
  }

  HomeDataModel? homeDataModel;
  Future<HomeDataModel?> getHomeData() async {
    await getGeoData();
    print('object');
    final jsonString = await ApiAdapter.getRequest(
      withOutLoader: true,
      url:
          "global/app-home-links/${UtilityVar.genLanguage}/${UtilityVar.genCurrency}?city=${userGeoData?.city}&currency=${UtilityVar.genCurrency}&language=${UtilityVar.genLanguage}",
    );

    if (jsonString == null) {
      return null;
    } else if (jsonString is String) {
      homeDataModel = homeDataModelFromJson(jsonString);
      notifyListeners();
      return homeDataModel;
    } else {
      return null;
    }
  }

  Future getPromoPopupData() async {
    final jsonString = await ApiAdapter.getRequest(url: 'popup-promotions/mobile');

    if (jsonString == null) return;

    if (jsonString is String) {
    } else {}

    // if (response.statusCode == 200) {
    //   final promoPopup = promoPopupFromMap(jsonString);
    //   return promoPopup;
    // } else {
    //   print(response.reasonPhrase);
    //   return null;
    // }
  }

  PromotionDataModel? promotionDataModel;

  Future getPromotionList() async {
    final jsonString =
        await ApiAdapter.getRequest(url: 'mobile/promotions/list', withOutLoader: true);

    if (jsonString == null) return;

    if (jsonString is String) {
      promotionDataModel = promotionDataModelFromJson(jsonString);
      notifyListeners();
    } else {}
  }
}

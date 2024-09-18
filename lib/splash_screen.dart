import 'dart:io';

import 'package:flutter/material.dart';
import 'package:umrah_by_lamar/common/shear_pref.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:umrah_by_lamar/common/utility_var.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';

import 'controller/home_controller.dart';
import 'controller/search_controller.dart';
import 'screen/tab_bar_view.dart';
import 'screen/widgets/image_spinning.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  initApp() async {
    final token = LocalSavedData.getUserData();

    UtilityVar.userToken = token ?? "";

    await context.read<UserController>().getUserProfileData();
    if (context.read<HomeController>().homeDataModel == null) {
      await context.read<HomeController>().getHomeData();

      final userCityData = await context.read<PackSearchController>().searchForCity(
          context.read<HomeController>().userGeoData?.city ?? '',
          withOutLoader: true);
      if (userCityData.isNotEmpty) {
        context.read<PackSearchController>().payloadFromlocation = userCityData.first;
      }
    }
    if (context.read<HomeController>().promotionDataModel == null) {
      await context.read<HomeController>().getPromotionList();
    }
  }

  startapp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String version = packageInfo.version;
    String type = Platform.isIOS ? 'ios' : 'android';
    String buildNumber = packageInfo.buildNumber;
    final hasLatestVersion = true;
    //await AssistantMethods.checkVersion(type, buildNumber);
    if (hasLatestVersion) {
      await initApp();

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => TabBarScreen()), (route) => false);
    }
    // else {
    //   Dialogs.materialDialog(
    //       barrierDismissible: false,
    //       context: context,
    //       color: Colors.white,
    //       msg: 'Please update app for enjoying uninterrupted services',
    //       title: 'App update required',
    //       msgStyle: TextStyle(fontSize: 10.sp),
    //       lottieBuilder: Lottie.asset(
    //         'assets/images/loading/updateDialogAnimation.json',
    //         fit: BoxFit.contain,
    //       ),
    //       actions: [
    //         IconsButton(
    //           onPressed: () async {
    //             String url = type == 'ios'
    //                 ? 'https://apps.apple.com/app/i-book-holiday/id1601412493'
    //                 : 'https://play.google.com/store/apps/details?id=com.ibh.app';

    //             if (await canLaunchUrl(Uri.parse(url))) {
    //               await launchUrl(Uri.parse(url));
    //             }
    //           },
    //           text: 'Update',
    //           color: primaryblue,
    //           textStyle: TextStyle(color: Colors.white),
    //         ),
    //       ]);
    // }

    print(buildNumber);
  }

  @override
  void initState() {
    startapp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StaticVar().cardcolor,
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Positioned(
                top: 15.h,
                left: 9.w,
                child: SizedBox(
                  width: 80.w,
                  child: Image.asset(
                    'assets/images/lamarlogo/u.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 5.h,
                child: SizedBox(
                    width: 100.w,
                    height: 30.h,
                    child: Center(
                      child: ImageSpinning(
                        withOpasity: false,
                      ),
                    )),
              ),
              // Positioned(
              //             bottom: 300,
              //             left: 0.w,
              //             right: 0.w,
              //             child: SizedBox(
              //                 width: 80.w,
              //                 child: Text(baseUrl,
              //                     style: TextStyle(color: Colors.red,fontSize:80,))),
              //           )
            ],
          ),
        ),
      ),
    );
  }
}

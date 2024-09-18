import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glass/glass.dart';
import 'package:sizer/sizer.dart';
import 'package:umrah_by_lamar/common/utility_var.dart';

import '../screen/widgets/image_spinning.dart';

class StaticVar {
/*
******
    COLORS
******
*/

  final background = const Color.fromARGB(255, 241, 241, 241);
  final primaryColor = const Color.fromARGB(255, 233, 107, 53);
  final secondaryColor = const Color.fromARGB(255, 43, 33, 114);
  final cardcolor = const Color.fromARGB(255, 255, 255, 255);
  final gray = const Color.fromARGB(255, 151, 151, 151);
  final yellowColor = const Color.fromARGB(255, 249, 182, 41);
  final blackColor = const Color.fromARGB(255, 40, 40, 40);
  final footerbuttoncolor = const Color.fromARGB(255, 15, 41, 77);
  final redColor = const Color.fromARGB(255, 214, 0, 8);
  final greenColor = const Color.fromARGB(255, 0, 146, 0);

  /*
  ******
    DIMENSIONSåå
  ******
  */

  final defaultPadding = 7.0;
  final defaultRadius = 7.0;
  final defaultInnerRadius = 7.0 + 7.0;

  /*
  ******
    TEXT
  ******
  */

  final titleFontWeight = FontWeight.bold;
  final titleFontSize = 11.0;
  final subTitleFontWeight = FontWeight.w400;
  final subTitleFontSize = 9.0;

  void showToastMessage({required String message, bool isError = false}) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: isError ? redColor : greenColor,
      textColor: Colors.white,
      fontSize: titleFontSize.sp,
    );
  }

  void dismissTost() => Fluttertoast.cancel();

  /*
  ***************
  *  INDICATOR  *
  ***************
  */

  static showIndicator() {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..maskType = EasyLoadingMaskType.custom
      ..boxShadow = const [
        BoxShadow(
          offset: Offset(0, 0),
          spreadRadius: -20,
          blurRadius: 30,
          color: Color.fromRGBO(215, 215, 215, 0.8),
        )
      ]
      ..maskColor = Colors.white.withOpacity(0)
      ..backgroundColor = Colors.transparent
      ..indicatorColor = Colors.white.withOpacity(0)
      ..textColor = StaticVar().blackColor
      ..contentPadding = EdgeInsets.zero;

    return EasyLoading.show(
        indicator: SizedBox(
      width: 50.w,
      height: 10.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 10.w,
            height: 10.h,
            child: const ImageSpinning(
              withOpasity: false,
            ),
          ),
          Text(
            UtilityVar.genLanguage == "ar" ? "الرجاء الانتظار..." : "Please wait ...",
            style: TextStyle(color: StaticVar().cardcolor),
          )
        ],
      ),
    ).asGlass(clipBorderRadius: BorderRadius.circular(StaticVar().defaultInnerRadius)));
    //   instance..customAnimation = CustomAnimation();
  }

  static hideIndicator() {
    EasyLoading.dismiss();
  }

  BoxShadow shadow = BoxShadow(
      color: Colors.grey.withOpacity(0.2),
      blurRadius: 5,
      spreadRadius: 2,
      offset: const Offset(1, 1));
}

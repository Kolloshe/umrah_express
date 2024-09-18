import 'package:flutter/material.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/common/utility_var.dart';
import 'package:umrah_by_lamar/controller/home_controller.dart';
import 'package:umrah_by_lamar/controller/search_controller.dart';
import 'package:umrah_by_lamar/screen/search/search_result_screens/search_result_screen.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

import '../search_v2/search_stepper_v2.dart';

class SearchResultRouter extends StatefulWidget {
  const SearchResultRouter({super.key, required this.searchType});

  final ServiceType searchType;

  @override
  State<SearchResultRouter> createState() => _SearchResultRouterState();
}

class _SearchResultRouterState extends State<SearchResultRouter> {
  final _staticVar = StaticVar();

  String claculateTheDiscount() {
    final coins = Provider.of<PackSearchController>(context, listen: false).userCollectedPoint;

    final rate = context.read<HomeController>().homeDataModel?.data?.coinAmount ?? 1;
    num discount = (coins * rate);

    return AppLocalizations.of(context)!
        .congratsYouVeGot(discount.toString(), UtilityVar.genCurrency);

    // switch (gencurrency.toLowerCase()) {
    //   case 'usd':
    //     discount = (coins / 3.67).round();
    //     return AppLocalizations.of(context)!.congratsYouVeGot(discount.toString(), gencurrency);
    //   //    'Congrats! You’ve got $discount $gencurrency ... discount! :)';
    //   case 'eur':
    //     discount = (coins / 4.03).round();
    //     return AppLocalizations.of(context)!.congratsYouVeGot(discount.toString(), gencurrency);
    //   //'Congrats! You’ve got $discount $gencurrency ... discount! :)';
    //   case 'inr':
    //     discount = (coins * 20).round();
    //     return AppLocalizations.of(context)!.congratsYouVeGot(discount.toString(), gencurrency);
    //   //'Congrats! You’ve got $discount $gencurrency ... discount! :)';
    //   case 'gbp':
    //     discount = (coins / 4.83).round();
    //     return AppLocalizations.of(context)!.congratsYouVeGot(discount.toString(), gencurrency);
    //   //'Congrats! You’ve got $discount $gencurrency ... discount! :)';
    //   case 'kwd':
    //     discount = (coins / 12.09).round();
    //     return AppLocalizations.of(context)!.congratsYouVeGot(discount.toString(), gencurrency);
    //   //'Congrats! You’ve got $discount $gencurrency ... discount! :)';
    //   case 'omr':
    //     discount = (coins / 9.55).round();
    //     return AppLocalizations.of(context)!.congratsYouVeGot(discount.toString(), gencurrency);
    //   //'Congrats! You’ve got $discount $gencurrency ... discount! :)';
    //   default:
    //     return AppLocalizations.of(context)!.congratsYouVeGot(coins.toString(), gencurrency);
    //   //'Congrats! You’ve got $coins $gencurrency ... discount! :)';
    // }
  }

  showGameResultDialog() {
    if ((context.read<HomeController>().homeDataModel?.data?.isGameControlActive ?? false) &&
        (Provider.of<PackSearchController>(context, listen: false).userCollectedPoint > 0)) {
      showDialog(
          context: context,
          builder: (context) => Dialog(
                child: Container(
                    height: 50.h,
                    width: 95.w,
                    padding: EdgeInsets.all(_staticVar.defaultPadding),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(_staticVar.defaultRadius)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/loader-aiwa.png'),
                        SizedBox(height: 2.h),
                        Text(
                          AppLocalizations.of(context)?.congratulations ?? "Congratulations",
                          style: TextStyle(
                            fontSize: _staticVar.titleFontSize.sp,
                            fontWeight: _staticVar.titleFontWeight,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          claculateTheDiscount(),
                          style: TextStyle(
                            fontSize: _staticVar.subTitleFontSize.sp,
                            fontWeight: _staticVar.titleFontWeight,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        SizedBox(
                          width: 90.w,
                          child: CustomBTN(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              title: AppLocalizations.of(context)?.close ?? "Close"),
                        )
                      ],
                    )),
              ));
    }
  }

  getMorePackages() {
    if ((context.read<PackSearchController>().searchResultModel?.data?.secondAPISearch ?? false) ==
        true) {
      context.read<PackSearchController>().searchResultModel?.data?.packageId;
      context.read<PackSearchController>().loadMorePackages();
    }
  }

  @override
  void initState() {
    getMorePackages();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      showGameResultDialog();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.searchType) {
      case ServiceType.holiday:
        return const SearchResultScreen();
      // case ServiceType.flight:
      //   return const FlightResultScreen();
      case ServiceType.hotel:
        return const SearchResultScreen();
      // case ServiceType.transfer:
      //   return const TransferResultScreen();
      // case ServiceType.activity:
      //   return const ActivityResultScreen();
      // case ServiceType.privetGet:
      //   return const SizedBox();
      // case ServiceType.travelInsurance:
      //   return const SizedBox();
    }
  }
}

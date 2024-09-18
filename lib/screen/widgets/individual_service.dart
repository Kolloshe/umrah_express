import 'package:flutter/material.dart';
import 'package:umrah_by_lamar/controller/search_controller.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:ibookholiday1/screen/individual_services/ind_transfer/ind_transfer_screen.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../search/search_steper.dart';
import '../search/search_v2/search_stepper_v2.dart';

class IndividualProducts extends StatelessWidget {
  const IndividualProducts(
      {super.key, required this.title, required this.subtitle, required this.image});

  final String title;
  final String subtitle;
  final String image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        switch (title) {
          // SECTION NUMBER
          //{
          //-2 : GET Departure Code For TRANSFER,
          //-1 : GET Departure Code,
          // 0 : GET Arival Code,
          // 1 : GET DATE RANGE,
          // 2 : GET ROOMS AND PAX DETAILS,
          // 3 : GET ADVANCED SEARCH OPTION,
          // 4 : GET PRIVET GET INFORMATIONS
          // 5 : GET TRAVEL INSURANCE INFORMATION,
          //}
          case 'Holiday packages':
            {
              context.read<PackSearchController>().searchMode = '';
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SearchStepperV2(
                        serviceType: ServiceType.holiday,
                      )));

              break;
            }
          // case 'Flights':
          //   {
          //     context.read<PackSearchController>().searchMode = 'flight';

          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) => const SearchStepperV2(
          //               serviceType: ServiceType.flight,
          //             )));
          //     break;
          //   }
          case 'Hotels':
            {
              context.read<PackSearchController>().searchMode = 'hotel';

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SearchStepperV2(
                        serviceType: ServiceType.hotel,
                      )));
              break;
            }
          // case 'Transfers':
          //   {
          //     context.read<PackSearchController>().searchMode = 'transfer';

          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) => const SearchStepperV2(
          //               serviceType: ServiceType.transfer,
          //             )));
          //     break;
          //   }
          // case 'Activities':
          //   {
          //     context.read<PackSearchController>().searchMode = 'activity';
          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) => const SearchStepperV2(
          //               serviceType: ServiceType.activity,
          //             )));
          //     break;
          //   }
          // case 'Travel insurance':
          //   {
          //     context.read<PackSearchController>().searchMode = 'Travel insurance';
          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) => const SearchStepperV2(
          //               serviceType: ServiceType.travelInsurance,
          //             )));
          //     break;
          //   }
          // case 'Privet jet':
          //   {
          //     context.read<PackSearchController>().searchMode = 'privet jet';
          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) => const SearchStepperV2(
          //               serviceType: ServiceType.privetGet,
          //             )));
          //     break;
          //   }

          default:
            {
              break;
            }
        }
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            width: 25.w,
            height: 25.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                )),
            child: Stack(
              children: [
                Positioned(
                    top: 10,
                    left: 10,
                    right: 10,
                    child: Text('',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: context.read<UserController>().locale == const Locale('en')
                                ? 'Lato'
                                : 'Bhaijaan'))),
                //   Positioned(bottom: 0, left: 0, right: 0, child: Text(hundelSectionName(this.subtitle,context)))
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(hundelSectionName(title, context),
              style: TextStyle(
                  fontSize: 10.sp,
                  fontFamily: context.read<UserController>().locale == const Locale('en')
                      ? 'Lato'
                      : 'Bhaijaan'))
        ],
      ),
    );
  }

  String hundelSectionName(String sectionName, BuildContext context) {
    switch (sectionName) {
      case 'Flights':
        {
          return AppLocalizations.of(context)!.flights;
        }
      case 'Hotels':
        {
          return AppLocalizations.of(context)!.hotels;
        }
      case 'Transfers':
        {
          return AppLocalizations.of(context)!.transfers;
        }
      case 'Activities':
        {
          return AppLocalizations.of(context)!.activities;
        }
      case 'Privet jet':
        {
          return AppLocalizations.of(context)!.privetJet;
        }
      case 'Travel insurance':
        {
          return AppLocalizations.of(context)!.travelInsurance;
        }
      default:
        {
          return sectionName;
        }
    }
  }
}

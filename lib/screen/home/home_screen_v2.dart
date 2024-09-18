import 'dart:math';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glass/glass.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/controller/customize_controller.dart';
import 'package:umrah_by_lamar/controller/search_controller.dart';
import 'package:umrah_by_lamar/screen/search/search_v2/search_stepper_v2.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';

import '../../controller/home_controller.dart';
import '../customize/customize_v2/customize_details.dart';
import '../search/search_result_screens/search_result_router.dart';
import '../search_v2/umrah_search_stepper.dart';

class HomeScreenV2 extends StatefulWidget {
  const HomeScreenV2({super.key});

  @override
  State<HomeScreenV2> createState() => _HomeScreenV2State();
}

class _HomeScreenV2State extends State<HomeScreenV2> {
  final _staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      top: false,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            toolbarHeight: 10.h,
            elevation: 0,
            expandedHeight: 40.h,
            pinned: true,
            leading: null,
            leadingWidth: 0,
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(vertical: 5),
              // background: Container(
              //   decoration: BoxDecoration(
              //       image: DecorationImage(
              //         fit: BoxFit.cover,
              //         image: AssetImage(
              //           "assets/images/icon/afdhallul.jpg",
              //         ),
              //       ),
              //       color: _staticVar.primaryblue,
              //       borderRadius:
              //           BorderRadius.vertical(bottom: Radius.circular(_staticVar.defaultRadius))),
              // ),
              title: Container(
                padding: EdgeInsets.all(_staticVar.defaultPadding),
                alignment: Alignment.bottomCenter,
                width: 100.w,
                height: 30.h,
                decoration: BoxDecoration(
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        "assets/images/icon/afdhallul.jpg",
                      ),
                    ),
                    //  color: _staticVar.primaryColor,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(_staticVar.defaultRadius))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomBTN(
                      color: _staticVar.gray,
                      onTap: () async {
                        context.read<PackSearchController>().searchMode = '';
                        context.read<PackSearchController>().initPayloadTo();
                        await context.read<PackSearchController>().getUmrahArrivalLocation();

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const CollectSearchDataScreen(serviceType: ServiceType.holiday)));

                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) =>
                        //         const SearchStepperV2(serviceType: ServiceType.holiday)));
                      },

                      title: AppLocalizations.of(context)?.umrah ?? "عمره",

                      // child:
                      //  Container(
                      //   alignment: Alignment.center,
                      //   padding: EdgeInsets.all(_staticVar.defaultPadding),
                      //   width: 15.w,
                      //   height: 15.w,
                      //   decoration: BoxDecoration(
                      //     //  color: _staticVar.background,
                      //     borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
                      //   ),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Image.asset(
                      //         "assets/images/icon/religion.png",
                      //         width: 10.w,
                      //         height: 10.w,
                      //       ),
                      //       // Text(
                      //       //   "عمره",
                      //       //   style: TextStyle(
                      //       //     fontSize: _staticVar.subTitleFontSize.sp - 2,
                      //       //   ),
                      //       // )
                      //     ],
                      //   ),
                      // ).asGlass(
                      //     clipBorderRadius: BorderRadius.circular(_staticVar.defaultRadius),
                      //     tintColor: Colors.transparent),
                    ),
                    CustomBTN(
                      color: _staticVar.gray,
                      onTap: () async {
                        context.read<PackSearchController>().initPayloadTo();
                        context.read<PackSearchController>().searchMode = 'hotel';
                        await context.read<PackSearchController>().getUmrahArrivalLocation();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const CollectSearchDataScreen(serviceType: ServiceType.hotel)));
                      },

                      title: AppLocalizations.of(context)?.hotels ?? "فنادق",

                      // child: Container(
                      //   padding: EdgeInsets.all(_staticVar.defaultPadding * 2),
                      //   width: 15.w,
                      //   height: 15.w,
                      //   decoration: BoxDecoration(
                      //     // color: _staticVar.background,
                      //     borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
                      //   ),
                      //   child: Image.asset(
                      //     "assets/images/icon/hotel.png",
                      //     width: 10.w,
                      //     height: 10.w,
                      //   ),
                      // ).asGlass(
                      //     clipBorderRadius: BorderRadius.circular(_staticVar.defaultRadius),
                      //     tintColor: Colors.transparent),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(child: Consumer<HomeController>(builder: (context, data, child) {
            return SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.all(_staticVar.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 1.h),
                  Text(
                    AppLocalizations.of(context)?.umrahPackages ?? "باقات العمره",
                    style: TextStyle(
                      fontSize: _staticVar.titleFontSize.sp,
                      fontWeight: _staticVar.titleFontWeight,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  SizedBox(
                      height: 46.h,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildUmrahCard(1),
                          _buildUmrahCard(0),
                          _buildUmrahCard(1),
                          _buildUmrahCard(0),
                          _buildUmrahCard(1),
                        ],
                      )),
                  SizedBox(height: 4.h),
                  Text(
                    AppLocalizations.of(context)?.umrahAndActivities ?? "عمره و عطلات",
                    style: TextStyle(
                      fontSize: _staticVar.titleFontSize.sp,
                      fontWeight: _staticVar.titleFontWeight,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  SizedBox(
                      height: 47.h,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildUmrahCard(0),
                          _buildUmrahCard(1),
                          _buildUmrahCard(0),
                          _buildUmrahCard(0),
                          _buildUmrahCard(1),
                        ],
                      )),
                ],
              ),
            ));
          }))
        ],
      ),
    ));
  }

  List<String> x = ["assets/images/icon/1.jpg", "assets/images/icon/kaaba1.jpg"];

  Widget _buildUmrahCard(int i) {
    return Container(
      margin: EdgeInsets.all(_staticVar.defaultPadding),
      width: 75.w,
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
        color: _staticVar.cardcolor,
        boxShadow: [_staticVar.shadow],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Stack(
              children: [
                Positioned(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
                    child: Image.asset(
                      x[i],
                      width: 80.w,
                      height: 25.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 5,
                  child: Container(
                      padding: EdgeInsets.all(_staticVar.defaultPadding),
                      width: 31.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
                      ),
                      child: Text(
                        "${AppLocalizations.of(context)?.nightCount(2)}، ${AppLocalizations.of(context)?.dayCount(3)}",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: _staticVar.background),
                      )).asGlass(
                    frosted: false,
                    clipBorderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
                    blurX: 10,
                    blurY: 10,
                    tileMode: TileMode.clamp,
                    tintColor: _staticVar.secondaryColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            "باقه العمره - مكه (ميقات الطائف)",
            style: TextStyle(
              fontSize: _staticVar.titleFontSize.sp,
              fontWeight: _staticVar.titleFontWeight,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIconWithService(
                  icon: Icons.flight,
                  title: AppLocalizations.of(context)?.flights ?? "رحلات الطيران"),
              _buildIconWithService(
                  icon: Icons.hotel, title: AppLocalizations.of(context)?.hotels ?? "فنادق"),
              _buildIconWithService(
                  icon: Icons.transfer_within_a_station,
                  title: AppLocalizations.of(context)?.transfer ?? "الترحيل"),
            ],
          ),
          SizedBox(height: 1.h),
          Container(decoration: DottedDecoration(color: _staticVar.gray)),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomBTN(
                  onTap: () async {
                    final result = await context.read<PackSearchController>().searchFormTreanding(
                        url:
                            "holiday/search?os=ios&app_version=33&package_start=01/10/2024&package_end=10/10/2024&departure_code=12673&arrival_code=26377&hotelCode=&flightCode=&search_Type=1&flightClass=Y&rooms[1]=1&adults[1]=1&children[1]=0&hotelStar=&currency=SAR&language=ar&selling_currency=SAR&searchRequest=1&searchMode=");

                    if (result) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SearchResultRouter(
                                searchType: ServiceType.holiday,
                              )));
                    }

                    // context
                    //     .read<CustomizeController>()
                    //     .customizePackage("66cb0f4838c7acbded087cf6");
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => const CustomizeDetials(
                    //           heroTag: "assets/images/icon/kaaba1.jpg",
                    //         )));
                  },
                  title: AppLocalizations.of(context)?.viewDetails ?? "عرض التفاصيل"),
              Column(
                children: [
                  Text(
                    "SAR 3800",
                    style: TextStyle(
                        fontSize: _staticVar.subTitleFontSize.sp,
                        color: _staticVar.gray,
                        decoration: TextDecoration.lineThrough),
                  ),
                  Text(
                    "SAR 2500",
                    style: TextStyle(
                      color: _staticVar.primaryColor,
                      fontSize: _staticVar.titleFontSize.sp + 1,
                      fontWeight: _staticVar.titleFontWeight,
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconWithService({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(
          icon,
          color: _staticVar.secondaryColor,
        ),
        Text(
          "  $title",
          style: TextStyle(
            fontSize: _staticVar.subTitleFontSize.sp,
          ),
        )
      ],
    );
  }
}

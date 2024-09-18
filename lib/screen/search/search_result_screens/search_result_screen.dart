import 'dart:ui';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glass/glass.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/common/utility_var.dart';
import 'package:umrah_by_lamar/controller/search_controller.dart';
import 'package:umrah_by_lamar/model/search_models/search_result_models/search_result_model.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_map_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/customize_controller.dart';
import '../../customize/customize_slider.dart';
import '../../customize/customize_v2/customize_details.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/street_view_screen.dart';
import 'filter_screen.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  bool isScrollingup = false;

  final _staticVar = StaticVar();

  final _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < 60) {
        setState(() {
          isScrollingup = false;
        });
      } else {
        setState(() {
          isScrollingup = true;
        });
      }
    });

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   context.read<PackSearchController>().loadMorePackages();
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PackSearchController>(
        builder: (context, data, child) {
          return Stack(
            children: [
              // Positioned(
              //     top: 0,
              //     left: 0,
              //     right: 0,
              //     bottom: 0,
              //     child: Image.asset(
              //       "assets/images/vectors/vector_v2/2.jpg",
              //       fit: BoxFit.cover,
              //     )),
              _buildPackages(data.packages),
              !isScrollingup
                  ? const SizedBox()
                  : SizedBox(
                      height: 14.h,
                      width: 100.w,
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Colors.black.withOpacity(0.1),
                                  Colors.black.withOpacity(0.0),
                                  Colors.black.withOpacity(0.0),
                                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                                //  color: Colors.black.withOpacity(0.1),
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20))),
                          ),
                        ),
                      ),
                    ),
              _buildSearchDetails(data.searchResultModel?.data?.searchData),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchDetails(SearchData? data) {
    return Positioned(
        left: 5,
        right: 5,
        top: 8.h,
        child: Container(
          decoration: BoxDecoration(
              // color: _staticVar.cardcolor,
              borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
              boxShadow: [
                BoxShadow(
                    color: _staticVar.blackColor.withAlpha(20),
                    spreadRadius: 5,
                    offset: const Offset(0, 0),
                    blurRadius: 5)
              ]),
          child: AnimatedCrossFade(
            firstChild: Container(
              color: _staticVar.cardcolor,
              padding: EdgeInsets.all(_staticVar.defaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: _staticVar.defaultPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            size: 18,
                          ),
                        ),
                        Image.asset(
                          'assets/images/dollar.png',
                          width: 6.w,
                          color: _staticVar.gray,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    AppLocalizations.of(context)?.destination ?? 'Destination',
                    style:
                        TextStyle(color: _staticVar.gray, fontSize: _staticVar.subTitleFontSize.sp),
                  ),
                  SizedBox(height: 1.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 100.w,
                      padding: EdgeInsets.all(_staticVar.defaultPadding),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
                          color: _staticVar.gray.withAlpha(100)),
                      child: Text(data?.arrivalName ?? ''),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 30.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context)?.dates ?? 'Dates',
                                style: TextStyle(
                                    color: _staticVar.gray,
                                    fontSize: _staticVar.subTitleFontSize.sp)),
                            SizedBox(height: 1.h),
                            Text(
                              "${dateFormatter(data?.packageStart ?? "")} - ${dateFormatter(data?.packageEnd ?? "")}",
                              style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 35.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)?.rooms ?? 'الغرف',
                              style: TextStyle(
                                  color: _staticVar.gray, fontSize: _staticVar.subTitleFontSize.sp),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              "${AppLocalizations.of(context)?.roomCount(data?.roomsCount ?? 1).toString()} , ${AppLocalizations.of(context)?.passenger((data?.childrenCount ?? 0) + (data?.adultsCount ?? 0)) ?? 1}",
                              style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => const FilterScreen()));
                        },
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset('assets/images/filter.png',
                                  width: 6.w, color: _staticVar.primaryColor),
                              SizedBox(width: 2.w),
                              Text(
                                AppLocalizations.of(context)?.filters ?? 'Filters',
                                style: TextStyle(
                                    fontSize: _staticVar.subTitleFontSize.sp,
                                    color: _staticVar.primaryColor,
                                    fontWeight: _staticVar.titleFontWeight),
                              ),
                            ]),
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => Container(
                                    padding: EdgeInsets.all(_staticVar.defaultPadding),
                                    height: 30.h,
                                    decoration: BoxDecoration(
                                        color: _staticVar.cardcolor,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(_staticVar.defaultRadius),
                                            topRight: Radius.circular(_staticVar.defaultRadius))),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 2.h),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(AppLocalizations.of(context)?.sort ?? "Sort"),
                                            GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Icon(Icons.close,
                                                    color: _staticVar.primaryColor)),
                                          ],
                                        ),
                                        SizedBox(height: 2.h),
                                        GestureDetector(
                                          onTap: () {
                                            (context.read<PackSearchController>().packages).sort(
                                                (a, b) => (b.total ?? 0).compareTo(a.total ?? 0));
                                            setState(() {});
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)?.highestToLowest ??
                                                "Higthest to Lowest",
                                            style: TextStyle(
                                              fontSize: _staticVar.titleFontSize.sp,
                                              color: _staticVar.primaryColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3.h),
                                        GestureDetector(
                                          onTap: () {
                                            (context.read<PackSearchController>().packages).sort(
                                                (a, b) => (a.total ?? 0).compareTo(b.total ?? 0));
                                            setState(() {});
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)?.lowestToHighest ??
                                                "Lowest to Higthest",
                                            style: TextStyle(
                                              fontSize: _staticVar.titleFontSize.sp,
                                              color: _staticVar.primaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                        },
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset('assets/images/sort.png',
                                  width: 6.w, color: _staticVar.primaryColor),
                              SizedBox(width: 2.w),
                              Text(
                                AppLocalizations.of(context)?.sort ?? 'Sort',
                                style: TextStyle(
                                    fontSize: _staticVar.subTitleFontSize.sp,
                                    color: _staticVar.primaryColor,
                                    fontWeight: _staticVar.titleFontWeight),
                              ),
                            ]),
                      ),
                    ],
                  )
                ],
              ),
            ),
            secondChild: Container(
              padding: EdgeInsets.all(_staticVar.defaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(_staticVar.defaultPadding),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: _staticVar.cardcolor,
                          size: 18,
                        )),
                  ),
                  Center(
                    child: Text(
                      data?.arrivalName ?? '',
                      style: TextStyle(
                        fontSize: _staticVar.titleFontSize.sp,
                        fontWeight: _staticVar.titleFontWeight,
                      ),
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Center(
                    child: Text(
                      "${dateFormatter(data?.packageStart ?? '')} - ${dateFormatter(data?.packageEnd ?? '')} , ${AppLocalizations.of(context)!.passenger(data?.totalPassengers ?? 1)}",
                      style: TextStyle(
                          fontSize: _staticVar.subTitleFontSize.sp,
                          fontWeight: _staticVar.titleFontWeight),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => const FilterScreen()));
                        },
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset('assets/images/filter.png',
                                  width: 6.w, color: _staticVar.primaryColor),
                              SizedBox(width: 2.w),
                              Text(
                                AppLocalizations.of(context)?.filters ?? 'Filters',
                                style: TextStyle(
                                    fontSize: _staticVar.subTitleFontSize.sp,
                                    color: _staticVar.primaryColor,
                                    fontWeight: _staticVar.titleFontWeight),
                              ),
                            ]),
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => Container(
                                    padding: EdgeInsets.all(_staticVar.defaultPadding),
                                    height: 30.h,
                                    decoration: BoxDecoration(
                                        color: _staticVar.cardcolor,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(_staticVar.defaultRadius),
                                            topRight: Radius.circular(_staticVar.defaultRadius))),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 2.h),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(AppLocalizations.of(context)?.sort ?? "Sort"),
                                            GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Icon(Icons.close,
                                                    color: _staticVar.primaryColor)),
                                          ],
                                        ),
                                        SizedBox(height: 2.h),
                                        GestureDetector(
                                          onTap: () {
                                            (context.read<PackSearchController>().packages).sort(
                                                (a, b) => (b.total ?? 0).compareTo(a.total ?? 0));
                                            setState(() {});
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)?.highestToLowest ??
                                                "Higthest to Lowest",
                                            style: TextStyle(
                                              fontSize: _staticVar.titleFontSize.sp,
                                              color: _staticVar.primaryColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3.h),
                                        GestureDetector(
                                          onTap: () {
                                            (context.read<PackSearchController>().packages).sort(
                                                (a, b) => (a.total ?? 0).compareTo(b.total ?? 0));
                                            setState(() {});
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)?.lowestToHighest ??
                                                "Lowest to Higthest",
                                            style: TextStyle(
                                              fontSize: _staticVar.titleFontSize.sp,
                                              color: _staticVar.primaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                        },
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset('assets/images/sort.png',
                                  width: 6.w, color: _staticVar.primaryColor),
                              SizedBox(width: 2.w),
                              Text(
                                AppLocalizations.of(context)?.sort ?? 'Sort',
                                style: TextStyle(
                                    fontSize: _staticVar.subTitleFontSize.sp,
                                    color: _staticVar.primaryColor,
                                    fontWeight: _staticVar.titleFontWeight),
                              ),
                            ]),
                      ),
                    ],
                  )
                ],
              ),
            ).asGlass(),
            crossFadeState: isScrollingup ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: 200.milliseconds,
          ),
        ));
  }

  Widget _buildPackages(List<Package> packages) {
    return ListView(
      padding: EdgeInsets.only(
          top: 40.h,
          left: _staticVar.defaultPadding,
          right: _staticVar.defaultPadding,
          bottom: 2.h),
      controller: _scrollController,
      children: [
        for (var pack in packages) ...[
          _buildPackageV2(pack),
          SizedBox(
            height: 1.h,
          )
        ]
      ],
    );
  }

  Widget _buildPackage(Package pack) {
    return Container(
      margin: EdgeInsets.only(bottom: _staticVar.defaultPadding * 2),
      decoration: BoxDecoration(
        color: _staticVar.cardcolor,
        boxShadow: [
          BoxShadow(
              offset: Offset.zero,
              color: _staticVar.gray.withAlpha(40),
              blurRadius: 5,
              spreadRadius: 5)
        ],
        borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(_staticVar.defaultRadius),
                bottomLeft: Radius.circular(_staticVar.defaultRadius)),
            child: CustomImage(
              url: pack.hotelImage ?? '',
              width: 30.w,
              height: 35.h,
              boxFit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: _staticVar.defaultPadding, right: _staticVar.defaultPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 54.w,
                      height: 30.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pack.packageName ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: _staticVar.titleFontWeight,
                                fontSize: _staticVar.subTitleFontSize.sp + 1.5),
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              for (int s = 0; s < (pack.hotelStar ?? 0); s++)
                                Text(
                                  '★',
                                  style: TextStyle(color: _staticVar.yellowColor),
                                )
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          (pack.hotelName != null && (pack.hotelName ?? '').isNotEmpty)
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 20,
                                      color: _staticVar.blackColor,
                                    ),
                                    SizedBox(width: 1.w),
                                    GestureDetector(
                                      onTap: () {
                                        if (pack.latitude != null && pack.longitude != null) {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) => CustomStreetView(
                                                    lat: double.tryParse(pack.latitude ?? "0") ?? 0,
                                                    lon:
                                                        double.tryParse(pack.longitude ?? "0") ?? 0,
                                                    isFromCus: false,
                                                    isfromHotel: false,
                                                  )));
                                        }
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)?.streetview ?? 'Street view',
                                        style: TextStyle(
                                            fontSize: _staticVar.subTitleFontSize.sp,
                                            color: _staticVar.primaryColor,
                                            decoration: TextDecoration.underline),
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => CustomMapView(
                                                  lat: double.tryParse(pack.latitude ?? "0") ?? 0,
                                                  lon: double.tryParse(pack.longitude ?? "0") ?? 0,
                                                )));
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)?.mapView ?? 'Map view',
                                        style: TextStyle(
                                            fontSize: _staticVar.subTitleFontSize.sp,
                                            color: _staticVar.primaryColor,
                                            decoration: TextDecoration.underline),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          (pack.hotelName != null && (pack.hotelName ?? '').isNotEmpty)
                              ? _buildServiceWithIcon(
                                  icon: Icons.hotel, title: pack.hotelName ?? '')
                              : const SizedBox(),
                          pack.flights != null
                              ? _buildServiceWithIcon(
                                  icon: Icons.airplanemode_active, title: pack.flights?.name ?? '')
                              : const SizedBox(),
                          (pack.activities ?? []).isNotEmpty
                              ? _buildServiceWithIcon(
                                  icon: Icons.directions_walk,
                                  title: pack.activities
                                          ?.map((e) => e.name ?? '')
                                          .take(2)
                                          .join('\n') ??
                                      '')
                              : const SizedBox(),
                          (pack.transfer ?? []).isNotEmpty
                              ? _buildServiceWithIcon(
                                  icon: Icons.directions_car,
                                  title: (pack.transfer ?? []).first.type ?? '')
                              : const SizedBox(),
                          pack.esim != null
                              ? _buildServiceWithIcon(
                                  icon: Icons.sim_card, title: pack.esim?.description ?? '')
                              : const SizedBox(),
                          SizedBox(height: 1.h)
                        ],
                      ),
                    ),
                    Container(
                      height: 15.h,
                      padding: EdgeInsets.symmetric(
                          horizontal: _staticVar.defaultPadding,
                          vertical: _staticVar.defaultPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final result = await context
                                  .read<PackSearchController>()
                                  .genarateDynamicLinks(id: pack.id ?? '', level: "packageId");
                              if (result != null) {
                                Share.share(result, subject: pack.packageName ?? '');
                              }
                            },
                            child: Icon(
                              Icons.share_rounded,
                              size: 20,
                              color: _staticVar.gray,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final result = await context
                                  .read<CustomizeController>()
                                  .customizePackage(pack.id ?? '');

                              if (result && mounted) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const CustomizeSlider()));
                              }
                            },
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: _staticVar.gray,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 65.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)?.totalP ?? ''),
                    Column(
                      children: [
                        pack.oldPrice == 0
                            ? const SizedBox()
                            : Text(
                                ' ${pack.sellingCurrency} ${pack.oldPrice.toString()}',
                                style: TextStyle(
                                    decorationThickness: 2,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: _staticVar.subTitleFontSize.sp,
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Colors.red),
                              ),
                        Text('${pack.sellingCurrency ?? ''} ${pack.total ?? ''}'),
                        pack.oldPrice == 0
                            ? const SizedBox()
                            : Text(
                                '${AppLocalizations.of(context)!.uSaving} ${(pack.total ?? 0) - (pack.oldPrice ?? 0)}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 9.sp,
                                    color: _staticVar.greenColor),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1.h),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceWithIcon({required String title, required IconData icon}) {
    return Container(
      margin: EdgeInsets.only(bottom: _staticVar.defaultPadding - 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: _staticVar.blackColor,
          ),
          SizedBox(width: 1.w),
          SizedBox(
            width: 45.w,
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: _staticVar.subTitleFontSize.sp,
                color: _staticVar.blackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageV2(Package package) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: _staticVar.defaultPadding),
      width: 75.w,
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
        color: _staticVar.cardcolor,
        boxShadow: [_staticVar.shadow],
      ),
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Stack(
              children: [
                Positioned(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
                    child: CustomImage(
                      url: package.hotelImage ?? "",
                      width: 100.w,
                      height: 45.h,
                      boxFit: BoxFit.cover,
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
                        "${AppLocalizations.of(context)?.nightCount((package.packageDays ?? 2) - 1)}، ${AppLocalizations.of(context)?.dayCount(package.packageDays ?? 2)}",
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(_staticVar.defaultPadding),
              //  decoration: BoxDecoration(color: _staticVar.cardcolor),
              width: 100.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  Text(
                    package.packageName ?? "",
                    style: TextStyle(
                        fontSize: _staticVar.titleFontSize.sp,
                        fontWeight: _staticVar.titleFontWeight,
                        color: _staticVar.cardcolor),
                  ),
                  SizedBox(height: 1.h),
                  SizedBox(
                    height: 4.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        if ((package.noFlight ?? false) == false)
                          _buildIconWithService(
                              icon: Icons.flight,
                              title: AppLocalizations.of(context)?.flights ?? "رحله الطيران"),
                        if ((package.hotelName != null) && ((package.hotelName ?? "").isNotEmpty))
                          _buildIconWithService(
                              icon: Icons.hotel,
                              title: AppLocalizations.of(context)?.hotels ?? "فنادق"),
                        if ((package.transfer ?? []).isNotEmpty)
                          _buildIconWithService(
                              icon: Icons.transfer_within_a_station,
                              title: AppLocalizations.of(context)?.transfers ?? "الترحيل"),
                        if ((package.esim != null))
                          _buildIconWithService(
                              icon: Icons.sim_card,
                              title: AppLocalizations.of(context)?.esimCard ?? "شريحه إتصال"),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(decoration: DottedDecoration(color: _staticVar.gray)),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          if ((package.oldPrice ?? 0) != 0)
                            Text(
                              (package.oldPrice ?? 0).toString(),
                              style: TextStyle(
                                  fontSize: _staticVar.subTitleFontSize.sp,
                                  color: _staticVar.gray,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          Text(
                            "${package.sellingCurrency ?? UtilityVar.genCurrency} ${package.total ?? 0}",
                            style: TextStyle(
                              color: _staticVar.primaryColor,
                              fontSize: _staticVar.titleFontSize.sp + 1,
                              fontWeight: _staticVar.titleFontWeight,
                            ),
                          )
                        ],
                      ),
                      CustomBTN(
                          onTap: () async {
                            final result = await context
                                .read<CustomizeController>()
                                .customizePackage(package.id ?? "");

                            if (result) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const CustomizeDetials()));
                            }
                          },
                          title: AppLocalizations.of(context)?.viewDetails ?? "عرض التفاصيل"),
                    ],
                  ),
                ],
              ),
            ).asGlass(
                tintColor: _staticVar.blackColor,
                clipBorderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius)),
          ),
        ],
      ),
    );
  }

  Widget _buildIconWithService({required IconData icon, required String title}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: _staticVar.defaultPadding),
      child: Row(
        children: [
          Icon(
            icon,
            color: _staticVar.cardcolor,
          ),
          Text(
            "  $title",
            style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp, color: _staticVar.cardcolor),
          )
        ],
      ),
    );
  }

  String dateFormatter(String date) =>
      DateFormat('MMM dd', UtilityVar.genLanguage).format(DateFormat('dd/MM/y').parse(date));
}

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:glass/glass.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:umrah_by_lamar/common/shear_pref.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
import 'package:umrah_by_lamar/screen/search/search_v2/search_stepper_v2.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_search_form_with_debouncer.dart';

import '../../controller/search_controller.dart';
import '../../model/search_models/payload.dart';
import '../search/search_result_screens/search_result_router.dart';
import '../search/search_v2/holiday_search/holiday_search_stepper.dart';

class CollectSearchDataScreen extends StatefulWidget {
  const CollectSearchDataScreen({super.key, required this.serviceType});
  final ServiceType serviceType;

  @override
  State<CollectSearchDataScreen> createState() => _CollectSearchDataScreenState();
}

class _CollectSearchDataScreenState extends State<CollectSearchDataScreen> {
  SearchSections currentSection = SearchSections.whereFrom;

  final _staticVar = StaticVar();

  final childAgesList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

  final searchController = TextEditingController();

  List<PayloadElement> searchResultList = [];

  @override
  void initState() {
    if (widget.serviceType == ServiceType.hotel) {
      currentSection = SearchSections.toWhere;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PackSearchController>(
        builder: (context, data, child) {
          return Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/vectors/vector_v2/1.jpg',
                    ),
                    fit: BoxFit.cover)),
            width: 100.w,
            height: 100.h,
            child: Stack(
              children: [_buildViewbinding()],
            ),
          );
        },
      ),
    );
  }

  final resentUrl = LocalSavedData.getSearchData();

  Widget _buildDepatureLocation() {
    return Positioned(
      top: 10.h,
      left: 5.w,
      right: 5.w,
      bottom: 10.h,
      child: Container(
        padding: EdgeInsets.all(_staticVar.defaultPadding * 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.all(_staticVar.defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back_ios_outlined,
                      color: _staticVar.cardcolor,
                    ),
                  ),
                  if (canMakeUmrahRecentSearch())
                    GestureDetector(
                        onTap: () async {
                          final result = await context
                              .read<PackSearchController>()
                              .makeSearchData(url: LocalSavedData.getSearchData());
                          if (result && mounted) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SearchResultRouter(
                                      searchType: widget.serviceType,
                                    )));
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.history,
                              color: _staticVar.cardcolor,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              AppLocalizations.of(context)?.recentSearch ?? "",
                              style: TextStyle(
                                color: _staticVar.cardcolor,
                                fontSize: _staticVar.titleFontSize.sp,
                              ),
                            )
                          ],
                        )),
                ],
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              AppLocalizations.of(context)?.departureLocation ?? "مكان المغادره",
              style: TextStyle(
                  fontSize: _staticVar.titleFontSize.sp + 10,
                  fontWeight: _staticVar.titleFontWeight,
                  color: _staticVar.cardcolor),
            ),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: _staticVar.defaultPadding),
              width: 70.w,
              height: 6.h,
              child: CustomSearchFormDebouncer(
                  title: AppLocalizations.of(context)?.departureLocation ?? "مكان المغادره",
                  method: (c) async {
                    searchResultList = await context
                        .read<PackSearchController>()
                        .getSectionSearchData(SearchSections.whereFrom, c, false);
                    setState(() {});
                  },
                  controller: searchController),
            ).asGlass(
                clipBorderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
                tintColor: Colors.black),
            Expanded(
              child: ListView(
                children: [
                  for (var city in searchResultList) _buildCityTile(city),
                ],
              ),
            ),
          ],
        ),
      )
          .asGlass(
              clipBorderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
              tintColor: Colors.black)
          .animate()
          .fadeIn(),
    );
  }

  Widget _buildDatesPickers() {
    return Positioned(
      top: 20.h,
      left: 5.w,
      right: 5.w,
      bottom: 15.h,
      child: Column(
        children: [
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.all(_staticVar.defaultPadding),
            child: InkWell(
              onTap: () {
                taggleSearchSection(SearchSections.toWhere);
              },
              child: Align(
                alignment: context.read<UserController>().isAR()
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: _staticVar.cardcolor,
                ),
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            widget.serviceType == ServiceType.hotel
                ? AppLocalizations.of(context)?.bookingDate ?? ""
                : AppLocalizations.of(context)?.departureDate ?? "تاريخ المغادره ",
            style: TextStyle(
              color: _staticVar.cardcolor,
              fontSize: _staticVar.titleFontSize.sp * 2,
            ),
          ),
          SizedBox(height: 1.h),
          CalendarDatePicker2(
            config: CalendarDatePicker2Config(
              disabledDayTextStyle: TextStyle(color: _staticVar.gray),
              lastMonthIcon: Icon(
                Icons.arrow_back_ios_rounded,
                color: _staticVar.cardcolor,
              ),
              nextMonthIcon: Icon(
                Icons.arrow_forward_ios_rounded,
                color: _staticVar.cardcolor,
              ),
              dynamicCalendarRows: false,
              controlsTextStyle: TextStyle(
                color: _staticVar.cardcolor,
                fontWeight: _staticVar.titleFontWeight,
              ),
              weekdayLabelTextStyle: TextStyle(
                color: _staticVar.cardcolor,
                fontWeight: _staticVar.titleFontWeight,
              ),
              yearTextStyle: TextStyle(
                color: _staticVar.cardcolor,
                fontWeight: _staticVar.titleFontWeight,
              ),
              selectedYearTextStyle: TextStyle(
                color: _staticVar.cardcolor,
                fontWeight: _staticVar.titleFontWeight,
              ),
              selectedMonthTextStyle: TextStyle(
                color: _staticVar.cardcolor,
                fontWeight: _staticVar.titleFontWeight,
              ),
              calendarViewMode: CalendarDatePicker2Mode.day,
              monthTextStyle: TextStyle(
                color: _staticVar.cardcolor,
              ),
              calendarType: CalendarDatePicker2Type.range,
              dayTextStyle: TextStyle(
                color: _staticVar.cardcolor,
              ),
              selectedDayTextStyle: TextStyle(
                fontWeight: _staticVar.titleFontWeight,
                color: _staticVar.cardcolor,
                fontSize: _staticVar.titleFontSize.sp + 4,
              ),
              selectedDayHighlightColor: _staticVar.secondaryColor,
              selectedRangeDayTextStyle: TextStyle(
                color: _staticVar.background,
                fontWeight: _staticVar.titleFontWeight,
              ),
              selectableYearPredicate: (year) {
                if (year < DateTime.now().year) {
                  return false;
                } else {
                  return true;
                }
              },
              selectableDayPredicate: (day) {
                if (day.isBefore(DateTime.now())) {
                  return false;
                } else {
                  return true;
                }
              },
            ),
            value: (context.read<PackSearchController>().selectedDatas.values.toList()
                as List<DateTime?>),
            onValueChanged: (dates) {
              if (dates.length < 2) return;
              final selectedDates = {
                "start_date": dates.first,
                "end_date": dates.last,
              };
              context.read<PackSearchController>().selectedDateRage(selectedDates);
            },
          ),
          SizedBox(height: 2.h),
          SizedBox(
              width: 70.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 30.w,
                    child: OutlinedButton(
                      onPressed: () {
                        taggleSearchSection(SearchSections.whereFrom);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: _staticVar.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)?.back ?? "رجوع",
                        style: TextStyle(
                          color: _staticVar.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      width: 30.w,
                      child: CustomBTN(
                          onTap: () {
                            taggleSearchSection(SearchSections.pax);
                          },
                          title: AppLocalizations.of(context)?.next ?? "التالي ")),
                ],
              )),
          SizedBox(height: 1.h),
        ],
      ).asGlass(
          clipBorderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
          tintColor: _staticVar.blackColor),
    ).animate().fadeIn();
  }

  Widget _buildCityTile(PayloadElement city) {
    return InkWell(
      onTap: () {
        context.read<PackSearchController>().payloadFrom = city;

        taggleSearchSection(SearchSections.toWhere);
      },
      child: Container(
        margin: EdgeInsets.all(_staticVar.defaultPadding),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(_staticVar.defaultPadding),
              margin: EdgeInsets.only(left: _staticVar.defaultPadding),
              decoration: BoxDecoration(
                  color: _staticVar.secondaryColor,
                  borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius)),
              child: Icon(
                Icons.location_on,
                color: _staticVar.primaryColor,
              ),
            ),
            SizedBox(width: 2.w),
            Text(
              city.cityName ?? "",
              style: TextStyle(
                color: _staticVar.cardcolor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaxs() {
    return Positioned(
      top: 10.h,
      left: 5.w,
      right: 5.w,
      bottom: 10.h,
      child: Consumer<PackSearchController>(builder: (context, data, child) {
        return Container(
          padding: EdgeInsets.all(_staticVar.defaultPadding),
          child: Column(
            children: [
              SizedBox(height: 1.h),
              Padding(
                padding: EdgeInsets.all(_staticVar.defaultPadding),
                child: InkWell(
                  onTap: () {
                    taggleSearchSection(SearchSections.date);
                  },
                  child: Align(
                    alignment: context.read<UserController>().isAR()
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Icon(
                      Icons.arrow_back_ios_outlined,
                      color: _staticVar.cardcolor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                AppLocalizations.of(context)?.passengers ?? "عدد المسافرين",
                style: TextStyle(
                    fontSize: _staticVar.titleFontSize.sp + 10,
                    fontWeight: _staticVar.titleFontWeight,
                    color: _staticVar.cardcolor),
              ),
              SizedBox(height: 1.h),
              Expanded(
                // width: 100.w,
                // height: 60.h,
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)?.rooms ?? "",
                              style: TextStyle(
                                color: _staticVar.cardcolor,
                                fontSize: _staticVar.titleFontSize.sp + 5,
                              ),
                            ),
                            SizedBox(
                              width: 30.w,
                              height: 6.h,
                              child: CustomNumberPicker<num>(
                                onValue: (v) {
                                  data.roomsCount = v.toInt();
                                  setState(() {});
                                },
                                initialValue: 1,
                                maxValue: 4,
                                minValue: 1,
                                step: 1,
                                valueTextStyle: TextStyle(
                                  color: _staticVar.cardcolor,
                                  fontWeight: _staticVar.titleFontWeight,
                                  fontSize: _staticVar.titleFontSize.sp,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(_staticVar.defaultInnerRadius),
                                  side: BorderSide(
                                    color: _staticVar.primaryColor,
                                  ),
                                ),
                                customAddButton: Icon(
                                  Icons.add_rounded,
                                  color: _staticVar.cardcolor,
                                ),
                                customMinusButton: Icon(
                                  Icons.remove_rounded,
                                  color: _staticVar.cardcolor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)?.adults ?? "",
                              style: TextStyle(
                                color: _staticVar.cardcolor,
                                fontSize: _staticVar.titleFontSize.sp + 5,
                              ),
                            ),
                            SizedBox(
                              width: 30.w,
                              height: 6.h,
                              child: CustomNumberPicker<num>(
                                onValue: (v) {
                                  data.adultCount = v.toInt();
                                  setState(() {});
                                },
                                initialValue: 1,
                                maxValue: 4,
                                minValue: 1,
                                step: 1,
                                valueTextStyle: TextStyle(
                                  color: _staticVar.cardcolor,
                                  fontWeight: _staticVar.titleFontWeight,
                                  fontSize: _staticVar.titleFontSize.sp,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(_staticVar.defaultInnerRadius),
                                  side: BorderSide(
                                    color: _staticVar.primaryColor,
                                  ),
                                ),
                                customAddButton: Icon(
                                  Icons.add_rounded,
                                  color: _staticVar.cardcolor,
                                ),
                                customMinusButton: Icon(
                                  Icons.remove_rounded,
                                  color: _staticVar.cardcolor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)?.children ?? "",
                              style: TextStyle(
                                color: _staticVar.cardcolor,
                                fontSize: _staticVar.titleFontSize.sp + 5,
                              ),
                            ),
                            SizedBox(
                              width: 30.w,
                              height: 6.h,
                              child: CustomNumberPicker<num>(
                                onValue: (v) {
                                  print(v);
                                  data.childCount = v.toInt();
                                  setState(() {});
                                },
                                initialValue: data.childCount,
                                maxValue: 4,
                                minValue: 0,
                                step: 1,
                                valueTextStyle: TextStyle(
                                  color: _staticVar.cardcolor,
                                  fontWeight: _staticVar.titleFontWeight,
                                  fontSize: _staticVar.titleFontSize.sp,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(_staticVar.defaultInnerRadius),
                                  side: BorderSide(
                                    color: _staticVar.primaryColor,
                                  ),
                                ),
                                customAddButton: Icon(
                                  Icons.add_rounded,
                                  color: _staticVar.cardcolor,
                                ),
                                customMinusButton: Icon(
                                  Icons.remove_rounded,
                                  color: _staticVar.cardcolor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    if (data.childCount > 0) ...[
                      Text(
                        AppLocalizations.of(context)?.childAges ?? "",
                        style: TextStyle(
                          color: _staticVar.cardcolor,
                          fontSize: _staticVar.titleFontSize.sp + 5,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      for (var i = 0; i < data.childCount; i++) ...[
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(),
                              child: Text(
                                "${AppLocalizations.of(context)?.childAges ?? ""} رقم ${i + 1} : ",
                                style: TextStyle(
                                  color: _staticVar.cardcolor,
                                  fontSize: _staticVar.titleFontSize.sp,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 25.w,
                              child: DropdownButton<int>(
                                padding: EdgeInsets.all(_staticVar.defaultPadding),
                                value: data.childAges[i + 1] ?? 1,
                                isExpanded: true,
                                iconSize: 18,
                                itemHeight: 6.h,
                                underline: const SizedBox(),
                                dropdownColor: _staticVar.secondaryColor,
                                items: childAgesList.map<DropdownMenuItem<int>>((value) {
                                  return DropdownMenuItem<int>(
                                    alignment: Alignment.centerLeft,
                                    value: value,
                                    child: SizedBox(
                                      width: 25.w,
                                      child: Text(
                                        value == 0
                                            ? "اقل من سنه واحده"
                                            : value == 1
                                                ? "عام $value"
                                                : "$value اعوام",
                                        style: TextStyle(
                                            fontSize: _staticVar.subTitleFontSize.sp,
                                            color: _staticVar.cardcolor),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  data.getChildrenAges(key: i + 1, age: value ?? 1);
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ]
                  ],
                ),
              ),
              SizedBox(height: 3.h),
              SizedBox(
                  width: 50.w,
                  child: CustomBTN(
                      onTap: () {
                        taggleSearchSection(SearchSections.advanceFillter);
                      },
                      title: AppLocalizations.of(context)?.next ?? "التالي"))
            ],
          ),
        )
            .asGlass(
                clipBorderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
                tintColor: Colors.black)
            .animate()
            .fadeIn();
      }),
    );
  }

  FlightClass selectedFlightClass = FlightClass.economy;

  String countryCode = "AE";
  String countryName = "United Arab Emirates";

  double stars = 4;
  Widget _buildFlightClassAndStars() {
    return Positioned(
      top: 10.h,
      left: 5.w,
      right: 5.w,
      bottom: 10.h,
      child: Consumer<PackSearchController>(
        builder: (context, data, child) {
          return Container(
            padding: EdgeInsets.all(_staticVar.defaultPadding),
            child: Column(
              children: [
                SizedBox(height: 1.h),
                Padding(
                  padding: EdgeInsets.all(_staticVar.defaultPadding),
                  child: InkWell(
                    onTap: () {
                      taggleSearchSection(SearchSections.pax);
                    },
                    child: Align(
                      alignment: context.read<UserController>().isAR()
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        color: _staticVar.cardcolor,
                      ),
                    ),
                  ),
                ),
                Text(
                  AppLocalizations.of(context)?.nationality ?? "",
                  style: TextStyle(
                      fontSize: _staticVar.titleFontSize.sp + 10,
                      fontWeight: _staticVar.titleFontWeight,
                      color: _staticVar.cardcolor),
                ),
                SizedBox(height: 1.h),
                GestureDetector(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      onSelect: (c) {
                        countryCode = c.countryCode;
                        countryName = c.name;
                        setState(() {});
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(_staticVar.defaultPadding),
                    width: 100.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          countryName,
                          style: TextStyle(color: _staticVar.cardcolor),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: _staticVar.cardcolor,
                        ),
                      ],
                    ),
                  ).asGlass(clipBorderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius)),
                ),
                SizedBox(height: 2.h),
                Divider(color: _staticVar.cardcolor),
                SizedBox(height: 2.h),
                if (widget.serviceType != ServiceType.hotel) ...[
                  Text(
                    AppLocalizations.of(context)?.flightClass ?? "",
                    style: TextStyle(
                        fontSize: _staticVar.titleFontSize.sp + 10,
                        fontWeight: _staticVar.titleFontWeight,
                        color: _staticVar.cardcolor),
                  ),
                  SizedBox(height: 1.h),
                  _buidFlightClassRadioData(
                      AppLocalizations.of(context)?.economic ?? "", FlightClass.economy),
                  _buidFlightClassRadioData(
                      AppLocalizations.of(context)?.business ?? "", FlightClass.business),
                  _buidFlightClassRadioData(
                      AppLocalizations.of(context)?.firstClass ?? "", FlightClass.firstClass),
                  _buidFlightClassRadioData(AppLocalizations.of(context)?.premiumEconomy ?? "",
                      FlightClass.premiumEconomy),
                  SizedBox(height: 2.h),
                  Divider(color: _staticVar.cardcolor),
                  SizedBox(height: 2.h),
                ],
                Text(
                  AppLocalizations.of(context)?.hotelStars ?? "",
                  style: TextStyle(
                      fontSize: _staticVar.titleFontSize.sp + 10,
                      fontWeight: _staticVar.titleFontWeight,
                      color: _staticVar.cardcolor),
                ),
                SizedBox(height: 1.h),
                SmoothStarRating(
                    allowHalfRating: false,
                    onRatingChanged: (v) {
                      stars = v;
                      data.hotelStar = v.toInt();
                      setState(() {});
                    },
                    starCount: 5,
                    rating: data.hotelStar.toDouble(),
                    size: 40.0,
                    filledIconData: Icons.star_rounded,
                    halfFilledIconData: Icons.blur_on,
                    defaultIconData: Icons.star_border_rounded,
                    color: _staticVar.yellowColor,
                    borderColor: _staticVar.yellowColor,
                    spacing: 0.0),
                const Spacer(),
                SizedBox(
                    width: 60.w,
                    child: CustomBTN(
                        onTap: () async {
                          final result = await data.makeSearchData();

                          if (result) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SearchResultRouter(
                                      searchType: ServiceType.holiday,
                                    )));
                          }
                        },
                        title: AppLocalizations.of(context)?.search ?? "")),
                SizedBox(height: 3.h),
              ],
            ),
          )
              .asGlass(
                  clipBorderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
                  tintColor: Colors.black)
              .animate()
              .fadeIn();
        },
      ),
    );
  }

  Widget _buidFlightClassRadioData(String title, FlightClass value) {
    return InkWell(
      onTap: () {
        selectedFlightClass = value;
        context.read<PackSearchController>().getFlightClass(value);

        setState(() {});
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: _staticVar.titleFontSize.sp, color: _staticVar.cardcolor),
          ),
          Radio<FlightClass>(
              activeColor: _staticVar.primaryColor,
              value: value,
              groupValue: selectedFlightClass,
              onChanged: (v) {
                if (v != null) {
                  selectedFlightClass = v;
                  context.read<PackSearchController>().getFlightClass(value);
                  setState(() {});
                }
              })
        ],
      ),
    );
  }

  Widget _buildViewbinding() {
    switch (currentSection) {
      case SearchSections.whereFrom:
        return _buildDepatureLocation();
      case SearchSections.toWhere:
        return _buildArrivalLocation();
      case SearchSections.date:
        return _buildDatesPickers();

      case SearchSections.pax:
        return _buildPaxs();
      case SearchSections.advanceFillter:
        return _buildFlightClassAndStars();
      default:
        return _buildDepatureLocation();
    }
  }

  Widget _buildArrivalLocation() {
    return Positioned(
      top: 20.h,
      left: 5.w,
      right: 5.w,
      bottom: 15.h,
      child: Column(
        children: [
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.all(_staticVar.defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    if (widget.serviceType == ServiceType.hotel) {
                      Navigator.of(context).pop();
                    } else {
                      taggleSearchSection(SearchSections.whereFrom);
                    }
                  },
                  child: Align(
                    alignment: context.read<UserController>().isAR()
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Icon(
                      Icons.arrow_back_ios_outlined,
                      color: _staticVar.cardcolor,
                    ),
                  ),
                ),
                if (canMakeHotelRecentSearch())
                  GestureDetector(
                    onTap: () async {
                      final result = await context
                          .read<PackSearchController>()
                          .makeSearchData(url: LocalSavedData.getSearchData());
                      if (result && mounted) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SearchResultRouter(
                                  searchType: widget.serviceType,
                                )));
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.history,
                          color: _staticVar.cardcolor,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          AppLocalizations.of(context)?.recentSearch ?? "",
                          style: TextStyle(
                            color: _staticVar.cardcolor,
                            fontSize: _staticVar.titleFontSize.sp,
                          ),
                        )
                      ],
                    ),
                  )
              ],
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            AppLocalizations.of(context)?.arrivalLocation ?? "مكان الوصول",
            style: TextStyle(
              color: _staticVar.cardcolor,
              fontSize: _staticVar.titleFontSize.sp * 2,
            ),
          ),
          SizedBox(height: 1.h),
          for (var toWhere in context.read<PackSearchController>().umrahDistnations) ...[
            _buildArrivalLocationsData(toWhere),
            SizedBox(height: 1.h),
          ],
          SizedBox(height: 2.h),
          SizedBox(
              width: 70.w,
              child: CustomBTN(
                  onTap: () {
                    taggleSearchSection(SearchSections.date);
                  },
                  title: AppLocalizations.of(context)?.next ?? "التالي ")),
          SizedBox(height: 1.h),
        ],
      ).asGlass(
          clipBorderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
          tintColor: _staticVar.blackColor),
    ).animate().fadeIn();
  }

  _buildArrivalLocationsData(PayloadElement payload) {
    return InkWell(
      onTap: () {
        context.read<PackSearchController>().payloadto = payload;
        setState(() {});
      },
      child: Padding(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              payload.cityName ?? "",
              style: TextStyle(
                fontSize: _staticVar.titleFontSize.sp + 2,
                color: _staticVar.cardcolor,
              ),
            ),
            Radio(
                activeColor: _staticVar.primaryColor,
                value: payload,
                groupValue: context.read<PackSearchController>().payloadto,
                onChanged: (c) {
                  context.read<PackSearchController>().payloadto = c;
                  setState(() {});
                })
          ],
        ),
      ),
    );
  }

  bool canMakeUmrahRecentSearch() {
    final resentUrl = LocalSavedData.getSearchData();
    bool canMake = false;
    print(resentUrl);
    if (resentUrl != null) {
      if (widget.serviceType == ServiceType.holiday) {
        final lastUrl = resentUrl.split("searchMode=");

        if (lastUrl.isNotEmpty && lastUrl.last == '') {
          canMake = true;
        } else {
          canMake = false;
        }
      }
    }
    return canMake;
  }

  canMakeHotelRecentSearch() {
    final resentUrl = LocalSavedData.getSearchData();
    bool canMake = false;
    if (widget.serviceType == ServiceType.hotel) {
      if (resentUrl != null) {
        if (resentUrl.contains("searchMode=hotel")) {
          canMake = true;
        } else {
          canMake = false;
        }
      }
      return canMake;
    } else {
      return false;
    }
  }

  taggleSearchSection(SearchSections section) {
    setState(() {
      currentSection = section;
    });
  }
}

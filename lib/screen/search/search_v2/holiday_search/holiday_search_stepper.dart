// ignore_for_file: unused_element

import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/home_controller.dart';
import 'package:umrah_by_lamar/screen/tab_bar_view.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../controller/search_controller.dart';
import '../../../../model/common_models/privet_jet_category_model.dart';
import '../../../../model/home_models/home_data_model.dart';
import '../../../../model/search_models/ind_transfer_search_model.dart';
import '../../../../model/search_models/payload.dart';
import '../../../widgets/custom_date_picker.dart';
import '../../../widgets/custom_search_form_with_debouncer.dart';
import '../../search_result_screens/search_result_router.dart';
import '../search_stepper_v2.dart';
import '../travel_insurance_search/travel_insurance_form.dart';

enum TransferTripType {
  one,
  round,
}

enum FlightClass {
  economy,
  premiumEconomy,
  business,
  firstClass,
}

enum SearchSections {
  whereFrom,
  toWhere,
  date,
  pax,
  advanceFillter,
  selectCity,
  paxInformation,
}

class HolidayPackageSearch extends StatefulWidget {
  const HolidayPackageSearch(
      {super.key,
      required this.onSelect,
      required this.serviceType,
      this.initSection = SearchSections.whereFrom});
  final ServiceType serviceType;

  final ValueChanged<int> onSelect;

  final SearchSections initSection;

  @override
  State<HolidayPackageSearch> createState() => _HolidayPackageSearchState();
}

class _HolidayPackageSearchState extends State<HolidayPackageSearch> {
  final _staticVar = StaticVar();

  final controller = TextEditingController();

  List<PayloadElement> searchResultList = [];

  List<IndTransferSearchResultData> searchResultListForTransfer = [];

  PayloadElement? selectedPayload;

  SearchSections currentStep = SearchSections.whereFrom;

  TransferTripType selectedTransferType = TransferTripType.one;

  String transferDepartureDate = DateFormat('y-MM-dd').format(DateTime.now().add(1.days));

  String transferReturnDate = DateFormat('y-MM-dd').format(DateTime.now().add(2.days));

  Time firstTransferTime = Time(hour: 12, minute: 0);
  String formattedFirstTransferTime = '12:00';
  Time secTransferTime = Time(hour: 14, minute: 0);
  String formattedSecTransferTime = '14:00';

  final PageController passengerInformationPageController = PageController();

  List<SearchSections> stepper = [
    SearchSections.whereFrom,
    SearchSections.date,
    SearchSections.pax,
    SearchSections.advanceFillter
  ];

  CategoryData? privetJetCategory;

  // getPrivetJetCategories() async {
  //   if (widget.serviceType == ServiceType.privetGet) {
  //     await context.read<PackSearchController>().getPrivetJetCategories();
  //     if (!mounted) return;
  //     privetJetCategory = context.read<PackSearchController>().privateJetCategories?.data?.first;
  //   }
  // }

  @override
  void initState() {
    // getPrivetJetCategories();
    currentStep = widget.initSection;
    if (widget.initSection == SearchSections.toWhere) {
      widget.onSelect(1);
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        switch (currentStep) {
          SearchSections.whereFrom => _buildGetPayloads(),
          SearchSections.date => _buildGetDates(),
          SearchSections.pax => _buildPaxAndRooms(),
          SearchSections.selectCity => _buildSelectCity(),
          SearchSections.paxInformation => _buildPaxInformation(),
          _ => const SizedBox()
        }
      ],
    );
  }

  String getTitle(SearchSections section) {
    String title = '...';

    switch (section) {
      case SearchSections.whereFrom:
        title = AppLocalizations.of(context)?.fromWhichCity ?? "مكان المغادره ؟";
        break;
      case SearchSections.toWhere:
        title = 'Where are you going ?';
        break;
      case SearchSections.date:
        title = widget.serviceType == ServiceType.hotel
            ? AppLocalizations.of(context)?.bookingDate ?? 'تاريخ الحجز'
            : AppLocalizations.of(context)?.departureDate ?? 'تاريخ المغادره';
        break;
      case SearchSections.pax:
        title = AppLocalizations.of(context)?.passengers ?? "عدد المسافرين";
        break;
      case SearchSections.advanceFillter:
        title = '';
        break;
      case SearchSections.selectCity:
        title = '';
        break;
      case SearchSections.paxInformation:
        title = 'Passenger information';
        break;
    }
    return title;
  }

  getPayloadData({IndTransferSearchResultData? transferPoint, PayloadElement? city}) {
    switch (currentStep) {
      case SearchSections.whereFrom:
        context.read<PackSearchController>().getpayloadFrom(city!);
        currentStep = SearchSections.date;
        searchResultList.clear();
        controller.clear();
        widget.onSelect(1);
        // if
        // (widget.serviceType == ServiceType.transfer) {
        //   context.read<PackSearchController>().transferPoints["from"] = transferPoint;
        //   currentStep = SearchSections.toWhere;
        //   searchResultList.clear();
        //   controller.clear();
        //   widget.onSelect(1);
        // } else {
        //   context.read<PackSearchController>().getpayloadFrom(city!);
        //   currentStep = SearchSections.toWhere;
        //   searchResultList.clear();
        //   controller.clear();
        //   widget.onSelect(1);
        // }

        break;
      case SearchSections.toWhere:
        context.read<PackSearchController>().getpayloadTo(city!);
        currentStep = SearchSections.date;
        searchResultList.clear();
        controller.clear();
        widget.onSelect(2);

        // if (widget.serviceType == ServiceType.transfer) {
        //   context.read<PackSearchController>().transferPoints["to"] = transferPoint;
        //   currentStep = SearchSections.date;
        //   searchResultList.clear();
        //   controller.clear();
        //   widget.onSelect(2);
        // } else {
        //   context.read<PackSearchController>().getpayloadTo(city!);
        //   currentStep = SearchSections.date;
        //   searchResultList.clear();
        //   controller.clear();
        //   widget.onSelect(2);
        // }

        break;
      case SearchSections.selectCity:
        context.read<PackSearchController>().getpayloadFrom(city!);
        currentStep = SearchSections.whereFrom;
        searchResultList.clear();
        controller.clear();
        widget.onSelect(0);
      default:
        break;
    }
  }

  Widget _buildGetDates() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 1.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: _staticVar.defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.serviceType == ServiceType.hotel) {
                    Navigator.of(context).pop();
                  } else {
                    currentStep = SearchSections.whereFrom;
                    widget.onSelect(0);
                    setState(() {});
                  }
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: _staticVar.primaryColor,
                  size: 24,
                ),
              ),
              SizedBox(
                child: Text(
                  getTitle(currentStep),
                  style: TextStyle(
                      fontSize: _staticVar.titleFontSize.sp,
                      fontWeight: _staticVar.titleFontWeight),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        // ((widget.serviceType == ServiceType.transfer) ||
        //         (widget.serviceType == ServiceType.privetGet))
        //     ? SizedBox(
        //         height: 50.h,
        //         width: 100.w,
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             Text(
        //               'Select trip type',
        //               style: TextStyle(
        //                 fontSize: _staticVar.titleFontSize.sp,
        //                 fontWeight: _staticVar.titleFontWeight,
        //               ),
        //             ),
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //               children: [
        //                 SizedBox(
        //                   width: 45.w,
        //                   child: RadioListTile<TransferTripType>(
        //                       title: Text(
        //                         AppLocalizations.of(context)?.one ?? "One",
        //                         style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
        //                       ),
        //                       value: TransferTripType.one,
        //                       groupValue: selectedTransferType,
        //                       activeColor: _staticVar.primaryblue,
        //                       onChanged: (v) {
        //                         selectedTransferType = v ?? TransferTripType.one;
        //                         context.read<PackSearchController>().transferPoints['tripType'] =
        //                             'one';
        //                         setState(() {});
        //                       }),
        //                 ),
        //                 SizedBox(
        //                   width: 45.w,
        //                   child: RadioListTile<TransferTripType>(
        //                       title: Text(
        //                         AppLocalizations.of(context)?.round ?? "Round",
        //                         style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
        //                       ),
        //                       value: TransferTripType.round,
        //                       activeColor: _staticVar.primaryblue,
        //                       groupValue: selectedTransferType,
        //                       onChanged: (v) {
        //                         selectedTransferType = v ?? TransferTripType.round;
        //                         context.read<PackSearchController>().transferPoints['tripType'] =
        //                             'round';
        //                         setState(() {});
        //                       }),
        //                 ),
        //               ],
        //             ),
        //             SizedBox(height: 1.h),
        //             const Divider(),
        //             SizedBox(height: 1.h),
        //             Text(
        //               AppLocalizations.of(context)?.departureInformation ?? "Departure information",
        //               style: TextStyle(
        //                 fontSize: _staticVar.titleFontSize.sp,
        //                 fontWeight: _staticVar.titleFontWeight,
        //               ),
        //             ),
        //             SizedBox(height: 2.h),
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceAround,
        //               children: [
        //                 Container(
        //                   width: 40.w,
        //                   padding: EdgeInsets.all(_staticVar.defaultPadding),
        //                   decoration: BoxDecoration(
        //                       borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
        //                       boxShadow: [_staticVar.shadow],
        //                       color: _staticVar.cardcolor),
        //                   child: Column(
        //                     children: [
        //                       Text(AppLocalizations.of(context)?.departureDate ?? "Departure date"),
        //                       SizedBox(height: 1.h),
        //                       GestureDetector(
        //                         onTap: () {
        //                           showModalBottomSheet(
        //                               isScrollControlled: true,
        //                               context: context,
        //                               builder: (context) => SizedBox(
        //                                     width: 100.w,
        //                                     height: 60.h,
        //                                     child: Column(
        //                                       children: [
        //                                         SizedBox(height: 1.h),
        //                                         Text(
        //                                           AppLocalizations.of(context)
        //                                                   ?.selectDepartureTimes ??
        //                                               "",
        //                                           style: TextStyle(
        //                                               fontSize: _staticVar.titleFontSize.sp,
        //                                               fontWeight: _staticVar.titleFontWeight),
        //                                         ),
        //                                         SizedBox(height: 1.h),
        //                                         CustomDatePicker(
        //                                           onSelect: (value) {
        //                                             transferDepartureDate = DateFormat("y-MM-dd")
        //                                                 .format(value['start_date']);
        //                                             if (context
        //                                                 .read<PackSearchController>()
        //                                                 .transferPoints
        //                                                 .containsKey('departure')) {
        //                                               context
        //                                                       .read<PackSearchController>()
        //                                                       .transferPoints['departure']["date"] =
        //                                                   transferDepartureDate;
        //                                             } else {
        //                                               context
        //                                                   .read<PackSearchController>()
        //                                                   .transferPoints['departure'] = {
        //                                                 "date": transferDepartureDate
        //                                               };
        //                                             }
        //                                             Navigator.of(context).pop();
        //                                             setState(() {});
        //                                           },
        //                                           selectionMode:
        //                                               DateRangePickerSelectionMode.single,
        //                                         ),
        //                                       ],
        //                                     ),
        //                                   ));
        //                         },
        //                         child: Text(
        //                           transferDepartureDate,
        //                           style: TextStyle(
        //                               fontSize: _staticVar.titleFontSize.sp,
        //                               fontWeight: _staticVar.titleFontWeight),
        //                         ),
        //                       )
        //                     ],
        //                   ),
        //                 ),
        //                 Container(
        //                   width: 40.w,
        //                   padding: EdgeInsets.all(_staticVar.defaultPadding),
        //                   decoration: BoxDecoration(
        //                       borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
        //                       boxShadow: [_staticVar.shadow],
        //                       color: _staticVar.cardcolor),
        //                   child: Column(
        //                     children: [
        //                       Text(AppLocalizations.of(context)?.departureTime ?? "Departure time"),
        //                       SizedBox(height: 1.h),
        //                       GestureDetector(
        //                         onTap: () {
        //                           Navigator.of(context).push(showPicker(
        //                             context: context,
        //                             value: firstTransferTime,
        //                             sunrise: const TimeOfDay(hour: 6, minute: 0), // optional
        //                             sunset: const TimeOfDay(hour: 18, minute: 0), // optional
        //                             duskSpanInMinutes: 120, // optional
        //                             onChangeDateTime: ((time) {
        //                               formattedFirstTransferTime = DateFormat('HH:mm').format(time);
        //                               if (context
        //                                   .read<PackSearchController>()
        //                                   .transferPoints
        //                                   .containsKey("departure")) {
        //                                 context
        //                                         .read<PackSearchController>()
        //                                         .transferPoints['departure']['time'] =
        //                                     formattedFirstTransferTime;
        //                               } else {
        //                                 context
        //                                     .read<PackSearchController>()
        //                                     .transferPoints['departure'] = {
        //                                   'time': formattedFirstTransferTime
        //                                 };
        //                               }
        //                               print(context.read<PackSearchController>().transferPoints);
        //                               setState(() {});
        //                             }),
        //                             onChange: (Time) {},
        //                           ));
        //                         },
        //                         child: Text(
        //                           formattedFirstTransferTime,
        //                           style: TextStyle(
        //                               fontSize: _staticVar.titleFontSize.sp,
        //                               fontWeight: _staticVar.titleFontWeight),
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             if (selectedTransferType == TransferTripType.round) ...[
        //               SizedBox(height: 1.h),
        //               Text(
        //                 AppLocalizations.of(context)?.returnInformation ?? "Return information",
        //                 style: TextStyle(
        //                   fontSize: _staticVar.titleFontSize.sp,
        //                   fontWeight: _staticVar.titleFontWeight,
        //                 ),
        //               ),
        //               SizedBox(height: 2.h),
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                 children: [
        //                   Container(
        //                     width: 40.w,
        //                     padding: EdgeInsets.all(_staticVar.defaultPadding),
        //                     decoration: BoxDecoration(
        //                         borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
        //                         boxShadow: [_staticVar.shadow],
        //                         color: _staticVar.cardcolor),
        //                     child: Column(
        //                       children: [
        //                         Text(AppLocalizations.of(context)?.returnDate ?? "Return date"),
        //                         SizedBox(height: 1.h),
        //                         GestureDetector(
        //                           onTap: () {
        //                             showModalBottomSheet(
        //                                 isScrollControlled: true,
        //                                 context: context,
        //                                 builder: (context) => SizedBox(
        //                                       width: 100.w,
        //                                       height: 60.h,
        //                                       child: Column(
        //                                         children: [
        //                                           SizedBox(height: 1.h),
        //                                           Text(
        //                                             AppLocalizations.of(context)
        //                                                     ?.selectDepartureTimes ??
        //                                                 "",
        //                                             style: TextStyle(
        //                                                 fontSize: _staticVar.titleFontSize.sp,
        //                                                 fontWeight: _staticVar.titleFontWeight),
        //                                           ),
        //                                           SizedBox(height: 1.h),
        //                                           CustomDatePicker(
        //                                             selectableDayPredicate: (date) {
        //                                               if (date.isBefore(DateFormat("y-MM-dd")
        //                                                   .parse(transferDepartureDate))) {
        //                                                 return false;
        //                                               } else {
        //                                                 return true;
        //                                               }
        //                                             },
        //                                             onSelect: (value) {
        //                                               transferReturnDate = DateFormat("y-MM-dd")
        //                                                   .format(value['start_date']);
        //                                               if (context
        //                                                   .read<PackSearchController>()
        //                                                   .transferPoints
        //                                                   .containsKey('return')) {
        //                                                 context
        //                                                         .read<PackSearchController>()
        //                                                         .transferPoints['return']['date'] =
        //                                                     transferReturnDate;
        //                                               } else {
        //                                                 context
        //                                                     .read<PackSearchController>()
        //                                                     .transferPoints['return'] = {
        //                                                   'date': transferReturnDate
        //                                                 };
        //                                               }
        //                                               setState(() {});
        //                                             },
        //                                             selectionMode:
        //                                                 DateRangePickerSelectionMode.single,
        //                                           ),
        //                                         ],
        //                                       ),
        //                                     ));
        //                           },
        //                           child: Text(
        //                             transferReturnDate,
        //                             style: TextStyle(
        //                                 fontSize: _staticVar.titleFontSize.sp,
        //                                 fontWeight: _staticVar.titleFontWeight),
        //                           ),
        //                         )
        //                       ],
        //                     ),
        //                   ),
        //                   Container(
        //                     width: 40.w,
        //                     padding: EdgeInsets.all(_staticVar.defaultPadding),
        //                     decoration: BoxDecoration(
        //                         borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
        //                         boxShadow: [_staticVar.shadow],
        //                         color: _staticVar.cardcolor),
        //                     child: Column(
        //                       children: [
        //                         Text(AppLocalizations.of(context)?.returnTime ?? "Return time"),
        //                         SizedBox(height: 1.h),
        //                         GestureDetector(
        //                           onTap: () {
        //                             Navigator.of(context).push(showPicker(
        //                               context: context,
        //                               value: secTransferTime,
        //                               sunrise: const TimeOfDay(hour: 6, minute: 0), // optional
        //                               sunset: const TimeOfDay(hour: 18, minute: 0), // optional
        //                               duskSpanInMinutes: 120, // optional
        //                               onChangeDateTime: ((time) {
        //                                 formattedSecTransferTime = DateFormat('HH:mm').format(time);
        //                                 if (context
        //                                     .read<PackSearchController>()
        //                                     .transferPoints
        //                                     .containsKey('return')) {
        //                                   context
        //                                           .read<PackSearchController>()
        //                                           .transferPoints['return']['time'] =
        //                                       formattedSecTransferTime;
        //                                 } else {
        //                                   context
        //                                       .read<PackSearchController>()
        //                                       .transferPoints['return'] = {
        //                                     "time": formattedSecTransferTime
        //                                   };
        //                                 }
        //                                 setState(() {});
        //                               }),
        //                               onChange: (Time) {},
        //                             ));
        //                           },
        //                           child: Text(
        //                             formattedSecTransferTime,
        //                             style: TextStyle(
        //                                 fontSize: _staticVar.titleFontSize.sp,
        //                                 fontWeight: _staticVar.titleFontWeight),
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ]
        //           ],
        //         ),
        //       )
        //     :

        SizedBox(
          height: 42.h,
          child: CustomDatePicker(
            selectionMode:
                // widget.serviceType == ServiceType.activity
                //     ? DateRangePickerSelectionMode.single
                //     :
                DateRangePickerSelectionMode.range,
            onSelect: (value) {
              context.read<PackSearchController>().selectedDateRage(value);
            },
            initData: context.read<PackSearchController>().selectedDatas,
          ),
        ),
        SizedBox(height: 1.h),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 30.w,
            height: 6.h,
            child: CustomBTN(
              onTap: () {
                currentStep = SearchSections.pax;
                widget.onSelect(2);

                setState(() {});
              },
              title: AppLocalizations.of(context)?.next ?? 'متابعه',
            ),
          ),
        )
      ],
    );
  }

  _buildGetPayloads() {
    return Column(
      children: [
        SizedBox(height: 1.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: _staticVar.defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  controller.clear();
                  searchResultList.clear();
                  if (currentStep == SearchSections.whereFrom) {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const TabBarScreen()),
                          (route) => false);
                    }
                  } else {
                    if (widget.initSection == SearchSections.toWhere) {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const TabBarScreen()),
                            (route) => false);
                      }
                    } else {
                      currentStep = SearchSections.whereFrom;
                      widget.onSelect(0);
                      setState(() {});
                    }
                  }
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 24,
                  color: _staticVar.primaryColor,
                ),
              ),
              SizedBox(
                  width: 85.w,
                  height: 5.h,
                  child: CustomSearchFormDebouncer(
                    controller: controller,
                    title: getTitle(currentStep),
                    method: (c) async {
                      // if (widget.serviceType == ServiceType.transfer) {
                      //   final searchResult =
                      //       await context.read<PackSearchController>().getSectionSearchData(
                      //             SearchSections.selectCity,
                      //             c,
                      //             widget.serviceType == ServiceType.transfer,
                      //           );

                      //   if (searchResult is IndTransferSearchModel) {
                      //     searchResultListForTransfer = searchResult.data ?? [];
                      //   }
                      // } else {
                      //   searchResultList = await context
                      //       .read<PackSearchController>()
                      //       .getSectionSearchData(
                      //           currentStep, c,
                      //           false
                      //          // widget.serviceType == ServiceType.transfer

                      //           );
                      // }
                      searchResultList = await context
                          .read<PackSearchController>()
                          .getSectionSearchData(currentStep, c, false
                              // widget.serviceType == ServiceType.transfer

                              );
                      setState(() {});
                    },
                  ))
            ],
          ),
        ),
        SizedBox(height: 2.h),
        // widget.serviceType == ServiceType.transfer
        //     ? const SizedBox()
        //     :

        currentStep == SearchSections.toWhere
            ? const SizedBox()
            : searchResultList.isEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مكانك الحالي' '\n',
                        style: TextStyle(
                            fontSize: _staticVar.titleFontSize.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      ),
                      InkWell(
                        onTap: () {
                          getPayloadData(
                              city: context.read<PackSearchController>().payloadFromlocation!);
                          controller.clear();

                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(_staticVar.defaultPadding),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: _staticVar.primaryColor,
                              ),
                              child: const Icon(
                                Icons.my_location,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            context.read<PackSearchController>().payloadFromlocation != null
                                ? GestureDetector(
                                    onTap: () {
                                      getPayloadData(
                                          city: context
                                              .read<PackSearchController>()
                                              .payloadFromlocation!);
                                      controller.clear();

                                      setState(() {});
                                    },
                                    child: Text(
                                      '${context.read<PackSearchController>().payloadFromlocation?.cityName ?? ''} ${context.read<PackSearchController>().payloadFromlocation?.countryName ?? ''}',
                                      style:
                                          TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                                    ),
                                  )
                                : const Text('Add Your Location')
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
        SizedBox(
          height: 65.h,
          child: ListView(
            padding: EdgeInsets.all(_staticVar.defaultPadding),
            children: [
              // if (widget.serviceType == ServiceType.transfer) ...[
              //   for (var city in searchResultListForTransfer)
              //     GestureDetector(
              //       onTap: () {
              //         getPayloadData(transferPoint: city);
              //         controller.clear();
              //         setState(() {});
              //       },
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           Container(
              //             margin: EdgeInsets.all(_staticVar.defaultPadding).copyWith(right: 20),
              //             padding: const EdgeInsets.all(10),
              //             decoration: BoxDecoration(
              //                 color: _staticVar.primaryblue,
              //                 borderRadius: BorderRadius.circular(15)),
              //             child: const Icon(
              //               Icons.location_on,
              //               color: Colors.white,
              //             ),
              //           ),
              //           SizedBox(
              //               width: 70.w, child: Text("${city.label ?? ''}\n${city.category ?? ''}"))
              //         ],
              //       ),
              //     )
              // ] else

              ...[
                if ((searchResultList.isEmpty || controller.text.isEmpty) &&
                    currentStep == SearchSections.toWhere) ...[
                  for (var city
                      in context.read<HomeController>().homeDataModel?.data?.sectionOne?.data ??
                          <SectionData>[])
                    GestureDetector(
                      onTap: () async {
                        final result = await context
                            .read<PackSearchController>()
                            .searchForCity(city.city ?? "");

                        final selectedCity =
                            result.where((e) => e.cityName == (city.city ?? "")).toList();

                        getPayloadData(
                            city: selectedCity.isEmpty ? result.first : selectedCity.first);
                        controller.clear();
                        setState(() {});
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: _staticVar.defaultPadding),
                        decoration: BoxDecoration(
                          boxShadow: [_staticVar.shadow],
                          color: _staticVar.cardcolor,
                          borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(_staticVar.defaultRadius),
                                  bottomLeft: Radius.circular(_staticVar.defaultRadius)),
                              child: CustomImage(
                                url: city.image ?? "",
                                boxFit: BoxFit.cover,
                                height: 10.h,
                                width: 20.w,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  city.cityFullName ?? "",
                                  style: TextStyle(
                                      fontSize: _staticVar.titleFontSize.sp,
                                      fontWeight: _staticVar.titleFontWeight),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  city.label ?? "",
                                  style: TextStyle(
                                      fontSize: _staticVar.titleFontSize.sp,
                                      color: _staticVar.gray),
                                ),
                                SizedBox(height: 1.h),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                ] else ...[
                  for (var city in searchResultList)
                    GestureDetector(
                      onTap: () {
                        getPayloadData(city: city);
                        controller.clear();
                        setState(() {});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.all(_staticVar.defaultPadding).copyWith(right: 20),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: _staticVar.primaryColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                          ),
                          Text("${city.cityName ?? ''}\n${city.countryName ?? ''}")
                        ],
                      ),
                    )
                ]
              ]
            ],
          ),
        )
      ],
    );
  }

  _buildSelectCity() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (currentStep == SearchSections.selectCity) {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const TabBarScreen()),
                        (route) => false);
                  }
                } else if (currentStep == SearchSections.whereFrom) {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const TabBarScreen()),
                        (route) => false);
                  }
                } else {
                  if (widget.initSection == SearchSections.toWhere) {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const TabBarScreen()),
                          (route) => false);
                    }
                  } else {
                    currentStep = SearchSections.whereFrom;
                    widget.onSelect(1);
                    setState(() {});
                  }
                }
              },
              child: Icon(
                Icons.keyboard_arrow_left,
                size: 30,
                color: _staticVar.primaryColor,
              ),
            ),
            SizedBox(
                width: 85.w,
                height: 5.h,
                child: CustomSearchFormDebouncer(
                  controller: controller,
                  title: getTitle(currentStep),
                  method: (c) async {
                    searchResultList = await context
                        .read<PackSearchController>()
                        .getSectionSearchData(currentStep, c, false);

                    setState(() {});
                  },
                ))
          ],
        ),
        SizedBox(height: 2.h),
        currentStep == SearchSections.toWhere
            ? const SizedBox()
            : searchResultList.isEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Current Location' '\n',
                        style: TextStyle(
                            fontSize: _staticVar.titleFontSize.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(_staticVar.defaultPadding),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: _staticVar.primaryColor,
                              ),
                              child: const Icon(
                                Icons.my_location,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            context.read<PackSearchController>().payloadFromlocation != null
                                ? GestureDetector(
                                    onTap: () {
                                      getPayloadData(
                                          city: context
                                              .read<PackSearchController>()
                                              .payloadFromlocation!);

                                      setState(() {});
                                    },
                                    child: Text(
                                      '${context.read<PackSearchController>().payloadFromlocation?.cityName ?? ''} ${context.read<PackSearchController>().payloadFromlocation?.countryName ?? ''}',
                                      style:
                                          TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                                    ),
                                  )
                                : const Text('Add Your Location')
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
        SizedBox(
          height: 68.h,
          child: ListView(
            padding: EdgeInsets.all(_staticVar.defaultPadding),
            children: [
              for (var city in searchResultList)
                GestureDetector(
                  onTap: () {
                    getPayloadData(city: city);

                    setState(() {});
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.all(_staticVar.defaultPadding).copyWith(right: 20),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: _staticVar.primaryColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                      ),
                      Text("${city.cityName ?? ''}\n${city.countryName ?? ''}")
                    ],
                  ),
                )
            ],
          ),
        )
      ],
    );
  }

  _buildPaxAndRooms() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 1.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: _staticVar.defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  widget.onSelect(1);
                  currentStep = SearchSections.date;
                  setState(() {});
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: _staticVar.primaryColor,
                  size: 24,
                ),
              ),
              Text(
                getTitle(currentStep),
                style: TextStyle(
                    fontSize: _staticVar.titleFontSize.sp, fontWeight: _staticVar.titleFontWeight),
              ),
              SizedBox(width: 5.w)
            ],
          ),
        ),
        SizedBox(height: 0.5.h), //if (widget.serviceType == ServiceType.privetGet) ...[
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       AppLocalizations.of(context)?.pax ?? "Pax",
        //       style: TextStyle(
        //           fontSize: _staticVar.titleFontSize.sp, fontWeight: _staticVar.titleFontWeight),
        //     ),
        //     SizedBox(
        //       width: 35.w,
        //       child: CustomNumberPicker(
        //         initialValue: context.read<PackSearchController>().paxCountForPrivetJet,
        //         maxValue: 10,
        //         minValue: 1,
        //         step: 1,
        //         onValue: (num value) {
        //           context.read<PackSearchController>().paxCountForPrivetJet = value.toInt();
        //         },
        //         customAddButton: customNumberPickerIcon(iconData: Icons.add),
        //         customMinusButton: customNumberPickerIcon(iconData: Icons.remove),
        //       ),
        //     ),
        //   ],
        // ),
        // SizedBox(height: 1.h),
        // const Divider(),
        // SizedBox(height: 1.h),
        // InkWell(
        //   onTap: () async {
        //     await showCategoryBottomSheet();
        //     context.read<PackSearchController>().privateJetCategory = privetJetCategory;
        //   },
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       Column(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text(
        //             AppLocalizations.of(context)?.minCategory ?? 'Min Category',
        //             style: TextStyle(
        //                 fontSize: _staticVar.titleFontSize.sp,
        //                 fontWeight: _staticVar.titleFontWeight),
        //           ),
        //           SizedBox(height: 2.h),
        //           Text(
        //             privetJetCategory?.name ?? "",
        //             style: TextStyle(color: _staticVar.inCardColor),
        //           )
        //         ],
        //       ),
        //       Icon(
        //         Icons.keyboard_arrow_down,
        //         color: _staticVar.inCardColor,
        //       )
        //     ],
        //   ),
        // ),
        // SizedBox(height: 37.h),
        //]

        //else
        ...[
          //  if (widget.serviceType == ServiceType.flight) ...[_buildFlightClass()],

          // SizedBox(height: 1.h),
          // (widget.serviceType == ServiceType.flight) ||
          //         (widget.serviceType == ServiceType.transfer) ||
          //         (widget.serviceType == ServiceType.travelInsurance) ||
          //         (widget.serviceType == ServiceType.privetGet)
          //     ? const SizedBox()
          //     :
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)?.rooms ?? 'عدد الغرف',
                style: TextStyle(
                    fontSize: _staticVar.titleFontSize.sp, fontWeight: _staticVar.titleFontWeight),
              ),
              SizedBox(
                width: 35.w,
                child: CustomNumberPicker(
                  initialValue: context.read<PackSearchController>().roomsCount,
                  maxValue: 10,
                  minValue: 1,
                  step: 1,
                  onValue: (num value) {
                    context.read<PackSearchController>().roomsCount = value.toInt();
                  },
                  customAddButton: customNumberPickerIcon(iconData: Icons.add),
                  customMinusButton: customNumberPickerIcon(iconData: Icons.remove),
                ),
              )
            ],
          ),
          SizedBox(height: 0.5.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)?.adults ?? 'عدد البالغين',
                style: TextStyle(
                    fontSize: _staticVar.titleFontSize.sp, fontWeight: _staticVar.titleFontWeight),
              ),
              SizedBox(
                width: 35.w,
                child: CustomNumberPicker(
                  initialValue: context.read<PackSearchController>().adultCount,
                  maxValue: 10,
                  minValue: 1,
                  step: 1,
                  onValue: (num value) {
                    context.read<PackSearchController>().adultCount = value.toInt();
                  },
                  customAddButton: customNumberPickerIcon(iconData: Icons.add),
                  customMinusButton: customNumberPickerIcon(iconData: Icons.remove),
                ),
              )
            ],
          ),
          SizedBox(height: 0.5.h),
          // ((widget.serviceType == ServiceType.travelInsurance) ||
          //         (widget.serviceType == ServiceType.privetGet))
          //     ? Row(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             AppLocalizations.of(context)?.seniorTravelers ?? "Senior Travelers",
          //             style: TextStyle(
          //                 fontSize: _staticVar.titleFontSize.sp,
          //                 fontWeight: _staticVar.titleFontWeight),
          //           ),
          //           SizedBox(
          //             width: 35.w,
          //             child: CustomNumberPicker(
          //               initialValue: context.read<PackSearchController>().seniorTravelers,
          //               maxValue: 10,
          //               minValue: 1,
          //               step: 1,
          //               onValue: (num value) {
          //                 context.read<PackSearchController>().seniorTravelers = value.toInt();
          //               },
          //               customAddButton: customNumberPickerIcon(iconData: Icons.add),
          //               customMinusButton: customNumberPickerIcon(iconData: Icons.remove),
          //             ),
          //           )
          //         ],
          //       )
          //     :

          const SizedBox(),
          SizedBox(height: 0.5.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)?.children ?? 'عدد الاطفال',
                style: TextStyle(
                    fontSize: _staticVar.titleFontSize.sp, fontWeight: _staticVar.titleFontWeight),
              ),
              SizedBox(
                width: 35.w,
                child: CustomNumberPicker(
                  initialValue: context.read<PackSearchController>().childCount,
                  maxValue: 10,
                  minValue: 0,
                  step: 1,
                  onValue: (num value) {
                    context.read<PackSearchController>().childCountSetter = value.toInt();
                    setState(() {});
                  },
                  customAddButton: customNumberPickerIcon(iconData: Icons.add),
                  customMinusButton: customNumberPickerIcon(iconData: Icons.remove),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          // widget.serviceType == ServiceType.travelInsurance ||
          //         widget.serviceType == ServiceType.privetGet
          //     ? const SizedBox()
          //     :

          context.read<PackSearchController>().childCount > 0
              ? Text(
                  AppLocalizations.of(context)?.childAges ?? 'اعمار الاطفال',
                  style: TextStyle(
                      fontSize: _staticVar.titleFontSize.sp,
                      fontWeight: _staticVar.titleFontWeight),
                )
              : const SizedBox(),
          SizedBox(height: 1.h),
          const Divider(),
          // widget.serviceType == ServiceType.travelInsurance ||
          //         widget.serviceType == ServiceType.privetGet
          //     ? SizedBox(height: 20.h)
          //     :

          SizedBox(
            width: 100.w,
            height: 20.h,
            child: ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: _staticVar.defaultPadding, vertical: _staticVar.defaultPadding),
              children: [
                for (int i = 0; i < context.read<PackSearchController>().childCount; i++)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ' ${AppLocalizations.of(context)?.child ?? "عمر الطفل"} ${i + 1}',
                        style: TextStyle(
                            fontSize: _staticVar.titleFontSize.sp,
                            fontWeight: _staticVar.titleFontWeight),
                      ),
                      SizedBox(
                        width: 34.w,
                        child: CustomNumberPicker(
                          initialValue: context.read<PackSearchController>().childAges[i + 1] ?? 1,
                          maxValue: 10,
                          minValue: 1,
                          step: 1,
                          onValue: (num value) {
                            context
                                .read<PackSearchController>()
                                .getChildrenAges(key: i + 1, age: value.toInt());
                          },
                          customAddButton: customNumberPickerIcon(iconData: Icons.add),
                          customMinusButton: customNumberPickerIcon(iconData: Icons.remove),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Align(
          //     alignment: Alignment.centerRight,
          //     child: SizedBox(
          //       width: 40.w,
          //       height: 5.h,
          //       child: CustomBTN(
          //           onTap: () async {
          //             if (widget.serviceType == ServiceType.privetGet ||
          //                 widget.serviceType == ServiceType.travelInsurance) {
          //               context
          //                   .read<PackSearchController>()
          //                   .preparePaxInformation(widget.serviceType);
          //               currentStep = SearchSections.paxInformation;
          //               widget.onSelect(4);
          //               setState(() {});
          //             } else if (widget.serviceType == ServiceType.activity) {
          //               final result = await context.read<PackSearchController>().makeSearchData();
          //               await context.read<CustomizeController>().customizePackage(context
          //                       .read<PackSearchController>()
          //                       .searchResultModel
          //                       ?.data
          //                       ?.packages
          //                       ?.first
          //                       .id ??
          //                   "");
          //               await context.read<CustomizeController>().getActivityList(context
          //                   .read<CustomizeController>()
          //                   .packageCustomize
          //                   ?.result
          //                   ?.activities
          //                   ?.values
          //                   .first
          //                   .first
          //                   .day);
          //               Navigator.of(context)
          //                 ..push(MaterialPageRoute(builder: (context) => const ActivityManager()))
          //                 ..push(MaterialPageRoute(
          //                     builder: (context) => ActivityListingView(
          //                           activityDay: context
          //                                   .read<CustomizeController>()
          //                                   .packageCustomize
          //                                   ?.result
          //                                   ?.activities
          //                                   ?.values
          //                                   .first
          //                                   .first
          //                                   .day ??
          //                               1,
          //                         )));
          //             } else if (widget.serviceType == ServiceType.transfer) {
          //               final result =
          //                   await context.read<PackSearchController>().makeSearchForTransfer();
          //               if (result) {
          //                 Navigator.of(context).push(MaterialPageRoute(
          //                     builder: (context) => SearchResultRouter(
          //                           searchType: widget.serviceType,
          //                         )));
          //               }
          //             } else {
          //               final result = await context.read<PackSearchController>().makeSearchData();
          //               if (result) {
          //                 Navigator.of(context).push(MaterialPageRoute(
          //                     builder: (context) => SearchResultRouter(
          //                           searchType: widget.serviceType,
          //                         )));
          //               }
          //             }
          //           },
          //           title: (widget.serviceType == ServiceType.privetGet ||
          //                   widget.serviceType == ServiceType.travelInsurance)
          //               ? (AppLocalizations.of(context)?.next ?? "Next")
          //               : (AppLocalizations.of(context)?.search ?? 'Search')),
          //     ))
        ],
        Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 40.w,
              height: 5.h,
              child: CustomBTN(
                  onTap: () async {
                    // if (widget.serviceType == ServiceType.privetGet) {
                    //   currentStep = SearchSections.paxInformation;
                    //   widget.onSelect(4);
                    //   context
                    //       .read<PackSearchController>()
                    //       .preparePaxInformation(widget.serviceType);
                    //   setState(() {});
                    // } else if (widget.serviceType == ServiceType.travelInsurance) {
                    //   context
                    //       .read<PackSearchController>()
                    //       .preparePaxInformation(widget.serviceType);
                    //   currentStep = SearchSections.paxInformation;
                    //   widget.onSelect(4);
                    //   setState(() {});
                    // } else if (widget.serviceType == ServiceType.activity) {
                    //   Navigator.of(context)
                    //       .push(MaterialPageRoute(builder: (context) => const LoadingWidgetMain()));
                    //   final result = await context
                    //       .read<PackSearchController>()
                    //       .makeSearchData(withOutLoadder: true);
                    //   await context.read<CustomizeController>().customizePackage(context
                    //           .read<PackSearchController>()
                    //           .searchResultModel
                    //           ?.data
                    //           ?.packages
                    //           ?.first
                    //           .id ??
                    //       "");
                    //   await context.read<CustomizeController>().getActivityList(context
                    //       .read<CustomizeController>()
                    //       .packageCustomize
                    //       ?.result
                    //       ?.activities
                    //       ?.values
                    //       .first
                    //       .first
                    //       .day);
                    //   Navigator.of(context).pop();
                    //   Navigator.of(context)
                    //     ..push(MaterialPageRoute(builder: (context) => const ActivityManager()))
                    //     ..push(MaterialPageRoute(
                    //         builder: (context) => ActivityListingView(
                    //               activityDay: context
                    //                       .read<CustomizeController>()
                    //                       .packageCustomize
                    //                       ?.result
                    //                       ?.activities
                    //                       ?.values
                    //                       .first
                    //                       .first
                    //                       .day ??
                    //                   1,
                    //             )));
                    // } else if (widget.serviceType == ServiceType.transfer) {
                    //   Navigator.of(context)
                    //       .push(MaterialPageRoute(builder: (context) => const LoadingWidgetMain()));
                    //   final result =
                    //       await context.read<PackSearchController>().makeSearchForTransfer();
                    //   Navigator.of(context).pop();
                    //   if (result) {
                    //     Navigator.of(context).push(MaterialPageRoute(
                    //         builder: (context) => SearchResultRouter(
                    //               searchType: widget.serviceType,
                    //             )));
                    //   }
                    // } else {

                    final result = await context
                        .read<PackSearchController>()
                        .makeSearchData(withOutLoadder: false);

                    if (result) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SearchResultRouter(
                                searchType: widget.serviceType,
                              )));
                    }
                    // }
                  },
                  title:
                      // (widget.serviceType == ServiceType.privetGet ||
                      //         widget.serviceType == ServiceType.travelInsurance)
                      //     ? (AppLocalizations.of(context)?.next ?? "Next")
                      //     :
                      (AppLocalizations.of(context)?.search ?? 'Search')),
            )),
        SizedBox(
          height: 4.h,
        )
      ],
    );
  }

  _buildPaxInformation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                widget.onSelect(3);
                currentStep = SearchSections.pax;
                setState(() {});
              },
              child: Icon(
                Icons.keyboard_arrow_left,
                color: _staticVar.primaryColor,
                size: 30,
              ),
            ),
            Text(
              getTitle(currentStep),
              style: TextStyle(
                  fontSize: _staticVar.titleFontSize.sp, fontWeight: _staticVar.titleFontWeight),
            ),
            SizedBox(width: 5.w)
          ],
        ),
        SizedBox(height: 1.h),
        SizedBox(
            height: 65.h,
            width: 100.w,
            child: PageView.builder(
              controller: passengerInformationPageController,
              itemCount: context
                  .read<PackSearchController>()
                  .paxInformationForTravelInsuranceOrPrivetGet
                  .length,
              itemBuilder: (context, index) {
                final paxKey = context
                    .read<PackSearchController>()
                    .paxInformationForTravelInsuranceOrPrivetGet
                    .keys
                    .toList()[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      paxKey,
                      style: TextStyle(
                          fontSize: _staticVar.titleFontSize.sp,
                          fontWeight: _staticVar.titleFontWeight),
                    ),
                    SizedBox(height: 2.h),
                    TranvelInsuranceFroms(
                        paxKey: paxKey,
                        goNext: (value) async {
                          final total = context
                              .read<PackSearchController>()
                              .paxInformationForTravelInsuranceOrPrivetGet
                              .length;

                          // if (widget.serviceType == ServiceType.privetGet) {
                          //   final result =
                          //       await context.read<PackSearchController>().sendToPrivetJet();
                          //   handleResult(result);
                          // } else {
                          if (total <= index + 1) {
                            final result =
                                await context.read<PackSearchController>().sendToTravelInsurance();
                            handleResult(result);
                          } else {
                            passengerInformationPageController.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.fastOutSlowIn);
                          }
                          // }
                        },
                        preData: context
                            .read<PackSearchController>()
                            .paxInformationForTravelInsuranceOrPrivetGet[paxKey]),
                  ],
                );
              },
            ))
      ],
    );
  }

  FlightClass selectedFlightClass = FlightClass.economy;
  Widget _buildFlightComp(FlightClass value, String title) {
    return GestureDetector(
      onTap: () {
        selectedFlightClass = value;
        context.read<PackSearchController>().getFlightClass(selectedFlightClass);
        setState(() {});
      },
      child: Container(
        width: 40.w,
        height: 5.h,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(
                color:
                    value == selectedFlightClass ? _staticVar.primaryColor : Colors.grey.shade500,
                width: value == selectedFlightClass ? 3 : 1),
            borderRadius: BorderRadius.circular(10)),
        child: Text(title),
      ),
    );
  }

  Widget _buildFlightClass() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cabin class',
          style: TextStyle(
            fontSize: _staticVar.titleFontSize.sp,
            fontWeight: _staticVar.titleFontWeight,
          ),
        ),
        SizedBox(
          width: 100.w,
          child: Wrap(
            spacing: 15,
            runAlignment: WrapAlignment.start,
            alignment: WrapAlignment.spaceBetween,
            children: [
              _buildFlightComp(FlightClass.economy, 'Economy'),
              _buildFlightComp(FlightClass.premiumEconomy, 'Premium Economy'),
              _buildFlightComp(FlightClass.business, 'Business'),
              _buildFlightComp(FlightClass.firstClass, 'First Class')
            ],
          ),
        ),
      ],
    );
  }

  Widget customNumberPickerIcon({required IconData iconData}) => Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          iconData,
          color: Colors.grey,
          size: 18.sp,
        ),
      );

  void handleResult(bool result) {
    if (result) {
      showDialog(
          context: context,
          builder: (context) => Dialog(
                child: Container(
                  height: 50.h,
                  padding: EdgeInsets.all(_staticVar.defaultPadding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
                    color: _staticVar.cardcolor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/animation/done.json", width: 80.w),
                      SizedBox(height: 1.h),
                      Text(
                        AppLocalizations.of(context)?.hurray ?? "Hurray",
                        style: TextStyle(
                          fontWeight: _staticVar.titleFontWeight,
                          fontSize: _staticVar.titleFontSize.sp,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        AppLocalizations.of(context)?.successToFormattingTravelIn ??
                            "Your request has been submitted\nWe will contact you shortly",
                        style: TextStyle(
                          fontSize: _staticVar.titleFontSize.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      SizedBox(
                          width: 100.w,
                          child: CustomBTN(
                              onTap: () {
                                Navigator.of(context).pop();
                                if (Navigator.of(context).canPop()) {
                                  Navigator.of(context).pop();
                                } else {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) => const TabBarScreen()),
                                      (route) => false);
                                }
                              },
                              title: AppLocalizations.of(context)?.close ?? "Close"))
                    ],
                  ),
                ),
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => Dialog(
                child: Container(
                  height: 60.h,
                  padding: EdgeInsets.all(_staticVar.defaultPadding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
                    color: _staticVar.cardcolor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/animation/failed.json", width: 80.w),
                      SizedBox(height: 1.h),
                      Text(
                        AppLocalizations.of(context)?.errorHappened ?? "An error occurred",
                        style: TextStyle(
                          fontWeight: _staticVar.titleFontWeight,
                          fontSize: _staticVar.titleFontSize.sp,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        AppLocalizations.of(context)?.failedToFormatTravelIN ??
                            "Failed to format request please try again later or\nMail us on info@ibookholiday.com",
                        style: TextStyle(
                          fontSize: _staticVar.titleFontSize.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      SizedBox(
                          width: 100.w,
                          child: CustomBTN(
                              onTap: () {
                                Navigator.of(context).pop();
                                if (Navigator.of(context).canPop()) {
                                  Navigator.of(context).pop();
                                } else {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) => const TabBarScreen()),
                                      (route) => false);
                                }
                              },
                              title: AppLocalizations.of(context)?.close ?? "Close"))
                    ],
                  ),
                ),
              ));
    }
  }

  showCategoryBottomSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
              padding: EdgeInsets.all(_staticVar.defaultPadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
                color: _staticVar.cardcolor,
              ),
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)?.minCategory ?? "Min Category",
                    style: TextStyle(
                      fontSize: _staticVar.titleFontSize.sp,
                      fontWeight: _staticVar.titleFontWeight,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Expanded(
                      child: ListView(
                    children: [
                      for (var category in Provider.of<PackSearchController>(context, listen: false)
                              .privateJetCategories
                              ?.data ??
                          <CategoryData>[])
                        ListTileTheme(
                          selectedTileColor: _staticVar.primaryColor,
                          selectedColor: _staticVar.primaryColor,
                          child: ListTile(
                            onTap: () {
                              privetJetCategory = category;
                              setState(() {});
                              Navigator.pop(context);
                            },
                            horizontalTitleGap: 0,
                            minVerticalPadding: 0,
                            minLeadingWidth: 1,
                            selected: category == privetJetCategory ? true : false,
                            leading: category == privetJetCategory ? const Icon(Icons.done) : null,
                            title: Text(
                              category.name ?? "",
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ),
                        ),
                    ],
                  ))
                ],
              ),
            ));
  }
}

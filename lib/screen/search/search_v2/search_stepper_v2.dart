import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/search_controller.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../model/search_models/payload.dart';
import '../../widgets/custom_search_form_with_debouncer.dart';
import 'holiday_search/holiday_search_stepper.dart';

enum ServiceType {
  holiday,
//  flight,
  hotel,
  // transfer,
  // activity,
  // privetGet,
  // travelInsurance,
}

class SearchStepperV2 extends StatefulWidget {
  const SearchStepperV2({super.key, required this.serviceType});

  final ServiceType serviceType;

  @override
  State<SearchStepperV2> createState() => _SearchStepperV2State();
}

class _SearchStepperV2State extends State<SearchStepperV2> {
  final carouselController = CarouselController();

  final _staticVar = StaticVar();

  final List<String> images = [
    'assets/images/vectors/vector_v2/1.jpg',
    'assets/images/vectors/vector_v2/2.jpg',
    'assets/images/vectors/vector_v2/4.jpg',
    // 'assets/images/vectors/vector_v2/2.jpg',
    // 'assets/images/vectors/vector_v2/5.jpg',
    // 'assets/images/vectors/vector_v2/1.jpg',

    // 'assets/images/vectors/from.png',
    // 'assets/images/vectors/to.png',
    // 'assets/images/vectors/dates.png',
    // 'assets/images/vectors/pax.png',
    // 'assets/images/vectors/pref.png',
    // 'assets/images/vectors/pref.png',
    // 'assets/images/vectors/pref.png'
  ];

  late List<String> sections = [
    AppLocalizations.of(context)?.where_From ?? 'Where From',
    AppLocalizations.of(context)?.when_will_you_be_there ?? 'date range',
    AppLocalizations.of(context)?.who_Coming ?? "Who's coming",
    '',
    '',
    ''
  ];
  int i = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              child: IgnorePointer(
            ignoring: true,
            child: CarouselSlider(
                carouselController: carouselController,
                items: images.map<Widget>((e) => _buildCustomImage(image: e)).toList(),
                options: CarouselOptions(
                  height: 50.h,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    i = index;
                    setState(() {});
                  },
                  reverse: false,
                )),
          )),
          Positioned(
              top: 15.h,
              right: 4.w,
              child: Text(
                sections[i],
                style: TextStyle(
                    fontSize: _staticVar.titleFontSize.sp * 2,
                    fontWeight: FontWeight.w900,
                    color: _staticVar.cardcolor),
              )).animate().fadeIn(),
          Positioned(
              child: DraggableScrollableSheet(
            maxChildSize: 0.9,
            minChildSize: 0.60,
            initialChildSize: 0.70,
            snap: true,
            builder: (context, scrollController) => SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              controller: scrollController,
              child: Container(
                height: 90.h,
                padding: EdgeInsets.all(_staticVar.defaultPadding),
                decoration: BoxDecoration(
                  color: _staticVar.cardcolor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(_staticVar.defaultRadius * 5),
                    topRight: Radius.circular(_staticVar.defaultRadius * 5),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 1.h),
                    Container(
                      width: 25.w,
                      height: 1.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            _staticVar.defaultRadius,
                          ),
                          color: _staticVar.primaryColor),
                    ),
                    SizedBox(height: 1.h),
                    getSearchStartingPointForService()
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  _buildCustomImage({required String image}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
      ),
    );
  }

  List<PayloadElement> data = [];

  Widget _buildSearchForContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.keyboard_arrow_left,
              color: _staticVar.primaryColor,
            ),
            SizedBox(
                width: 85.w,
                height: 5.h,
                child: CustomSearchFormDebouncer(
                  title: 'Where From ?',
                  controller: TextEditingController(),
                  method: (c) async {
                    data = await context.read<PackSearchController>().searchForCity(c);
                    setState(() {});
                  },
                ))
          ],
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 78.h,
          child: ListView(
            padding: EdgeInsets.all(_staticVar.defaultPadding),
            children: [
              data.isEmpty
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
                          onTap: () {
                            // if (Provider.of<AppData>(context, listen: false)
                            //         .payloadFromlocation ==
                            //     null) {

                            //   return;
                            // }
                            // context.read<AppData>().getPayloadWhichCityForTransfer(
                            //     Provider.of<AppData>(context, listen: false)
                            //         .payloadFromlocation!);
                            // widget.toRechangeCitiy();
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
                                  ? Text(
                                      '${context.read<PackSearchController>().payloadFromlocation?.cityName ?? ''} ${context.read<PackSearchController>().payloadFromlocation?.countryName ?? ''}',
                                      style:
                                          TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                                    )
                                  : const Text('Add Your Location')
                            ],
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              for (var city in data)
                GestureDetector(
                  onTap: () {
                    context.read<PackSearchController>().getpayloadFromlocation(city);

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

  getSearchStartingPointForService() {
    switch (widget.serviceType) {
      case ServiceType.holiday:
        return HolidayPackageSearch(
          serviceType: widget.serviceType,
          onSelect: (value) {
            carouselController.animateToPage(value);
          },
        );

      // case ServiceType.flight:
      //   return HolidayPackageSearch(
      //     serviceType: widget.serviceType,
      //     onSelect: (value) {
      //       carouselController.animateToPage(value);
      //     },
      //   );

      case ServiceType.hotel:
        return HolidayPackageSearch(
          serviceType: widget.serviceType,
          initSection: SearchSections.date,
          onSelect: (value) {
            carouselController.animateToPage(value);
          },
        );

      // case ServiceType.transfer:
      //   return HolidayPackageSearch(
      //     serviceType: widget.serviceType,
      //     initSection: SearchSections.selectCity,
      //     onSelect: (value) {
      //       carouselController.animateToPage(value);
      //     },
      //   );
      // case ServiceType.activity:
      //   return HolidayPackageSearch(
      //     serviceType: widget.serviceType,
      //     initSection: SearchSections.toWhere,
      //     onSelect: (value) {
      //       carouselController.animateToPage(value);
      //     },
      //   );

      // case ServiceType.privetGet:
      //   return HolidayPackageSearch(
      //     serviceType: widget.serviceType,
      //     initSection: SearchSections.whereFrom,
      //     onSelect: (value) {
      //       carouselController.animateToPage(value);
      //     },
      //   );

      // case ServiceType.travelInsurance:
      //   return HolidayPackageSearch(
      //     serviceType: widget.serviceType,
      //     initSection: SearchSections.whereFrom,
      //     onSelect: (value) {
      //       carouselController.animateToPage(value);
      //     },
      //   );
    }
  }
}

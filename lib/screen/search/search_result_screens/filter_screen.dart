import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../controller/search_controller.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final _staticVar = StaticVar();

  late final _min =
      context.read<PackSearchController>().searchResultModel?.data?.priceRange?.min ?? 1000;
  late final _max =
      context.read<PackSearchController>().searchResultModel?.data?.priceRange?.max ?? 10000;

  late SfRangeValues _values = SfRangeValues(_min, _max);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.filters ?? "Filters",
          style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
        ),
        elevation: 0.1,
        backgroundColor: _staticVar.cardcolor,
        foregroundColor: _staticVar.primaryColor,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        child: Consumer<PackSearchController>(builder: (context, data, child) {
          return ListView(
            children: [
              _buildFillterTitle(
                  title: AppLocalizations.of(context)?.preferredBudgets ?? "Preferred Budgets"),
              SizedBox(height: 1.h),
              _buildPriceRange(min: _min.toDouble(), max: _max.toDouble()),
              SizedBox(height: 1.h),
              _buildFillterTitle(title: AppLocalizations.of(context)?.fStops ?? "Flight Stops"),
              SizedBox(height: 1.h),
              _buldFlightStops(),
              SizedBox(height: 1.h),
              _buildFillterTitle(title: AppLocalizations.of(context)?.hotelStars ?? "Hotel stars"),
              SizedBox(height: 1.h),
              _buildHotelStars(),
            ],
          );
        }),
      )),
      bottomSheet: Padding(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 45.w,
              child: CustomBTN(
                onTap: () {
                  context.read<PackSearchController>().prepearFilter();
                },
                title: 'Clear',
                color: _staticVar.redColor,
              ),
            ),
            SizedBox(
              width: 45.w,
              child: CustomBTN(
                  onTap: () {
                    final result = context.read<PackSearchController>().processedFilter();
                    if (result) {
                      Navigator.pop(context);
                    }
                  },
                  title: 'apply'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRange({required double min, required double max}) {
    return Padding(
      padding: EdgeInsets.all(_staticVar.defaultPadding * 2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)?.min ?? "Min",
                    style: TextStyle(
                        fontSize: _staticVar.titleFontSize.sp,
                        color: _staticVar.primaryColor,
                        fontWeight: _staticVar.titleFontWeight),
                  ),
                  SizedBox(
                      width: 15.w,
                      child: Text(
                        "${(_values.start).round()}",
                        style: TextStyle(
                            fontSize: _staticVar.titleFontSize.sp,
                            color: _staticVar.primaryColor,
                            fontWeight: _staticVar.titleFontWeight),
                        textAlign: TextAlign.start,
                      ))
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    AppLocalizations.of(context)?.max ?? "Max",
                    style: TextStyle(
                        fontSize: _staticVar.titleFontSize.sp,
                        color: _staticVar.primaryColor,
                        fontWeight: _staticVar.titleFontWeight),
                  ),
                  SizedBox(
                      width: 15.w,
                      child: Text(
                        "${(_values.end).round()}",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: _staticVar.titleFontSize.sp,
                            color: _staticVar.primaryColor,
                            fontWeight: _staticVar.titleFontWeight),
                      ))
                ],
              )
            ],
          ),
          SfRangeSlider(
            max: max,
            min: min,
            values: _values,
            showTicks: false,
            showLabels: false,
            showDividers: false,
            enableTooltip: false,
            shouldAlwaysShowTooltip: false,
            enableIntervalSelection: false,
            interval: 1000,
            stepSize: 50,
            activeColor: _staticVar.primaryColor,
            startThumbIcon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _staticVar.cardcolor,
                boxShadow: [_staticVar.shadow],
              ),
            ),
            endThumbIcon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _staticVar.cardcolor,
                boxShadow: [_staticVar.shadow],
              ),
            ),
            onChanged: (value) {
              context.read<PackSearchController>().filterData['max'] = value.end;
              context.read<PackSearchController>().filterData['min'] = value.start;

              setState(() {
                _values = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFillterTitle({required String title}) => SizedBox(
        width: 100.w,
        child: Text(title,
            style: TextStyle(
                color: Colors.black,
                fontWeight: _staticVar.titleFontWeight,
                fontSize: _staticVar.titleFontSize.sp)),
      );

  Widget _buldFlightStops() {
    return Padding(
      padding: EdgeInsets.all(_staticVar.defaultPadding * 2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)?.nonStop ?? "Non Stop",
                style: TextStyle(
                  fontSize: _staticVar.titleFontSize.sp,
                ),
              ),
              Checkbox.adaptive(
                value: context.read<PackSearchController>().filterData['non stop'],
                onChanged: (v) {
                  context.read<PackSearchController>().filterData['non stop'] = v;
                  setState(() {});
                },
                activeColor: _staticVar.primaryColor,
              )
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)?.oneStop ?? "One Stop",
                style: TextStyle(
                  fontSize: _staticVar.titleFontSize.sp,
                ),
              ),
              Checkbox.adaptive(
                value: context.read<PackSearchController>().filterData['1 stop'],
                onChanged: (v) {
                  context.read<PackSearchController>().filterData['1 stop'] = v;

                  setState(() {});
                },
                activeColor: _staticVar.primaryColor,
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)?.mutliStop ?? "Multi Stop",
                style: TextStyle(
                  fontSize: _staticVar.titleFontSize.sp,
                ),
              ),
              Checkbox.adaptive(
                value: context.read<PackSearchController>().filterData['multi stop'],
                onChanged: (v) {
                  context.read<PackSearchController>().filterData['multi stop'] = v;

                  setState(() {});
                },
                activeColor: _staticVar.primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHotelStars() {
    return Padding(
      padding: EdgeInsets.all(_staticVar.defaultPadding * 2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "★  ★  ★",
                style: TextStyle(
                    color: _staticVar.yellowColor,
                    fontSize: _staticVar.titleFontSize.sp,
                    fontWeight: _staticVar.titleFontWeight),
              ),
              Checkbox.adaptive(
                value: context.read<PackSearchController>().filterData['3 star'],
                onChanged: (v) {
                  context.read<PackSearchController>().filterData['3 star'] = v;
                  setState(() {});
                },
                activeColor: _staticVar.primaryColor,
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "★  ★  ★  ★",
                style: TextStyle(
                    color: _staticVar.yellowColor,
                    fontSize: _staticVar.titleFontSize.sp,
                    fontWeight: _staticVar.titleFontWeight),
              ),
              Checkbox.adaptive(
                value: context.read<PackSearchController>().filterData['4 star'],
                onChanged: (v) {
                  context.read<PackSearchController>().filterData['4 star'] = v;
                  setState(() {});
                },
                activeColor: _staticVar.primaryColor,
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "★  ★  ★  ★  ★",
                style: TextStyle(
                    color: _staticVar.yellowColor,
                    fontSize: _staticVar.titleFontSize.sp,
                    fontWeight: _staticVar.titleFontWeight),
              ),
              Checkbox.adaptive(
                value: context.read<PackSearchController>().filterData['5 star'],
                onChanged: (v) {
                  context.read<PackSearchController>().filterData['5 star'] = v;
                  setState(() {});
                },
                activeColor: _staticVar.primaryColor,
              ),
            ],
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({
    super.key,
    required this.selectionMode,
    required this.onSelect,
    this.selectableDayPredicate,
    this.enablePastDates,
    this.initData,
  });

  final ValueChanged<Map<String, DateTime>> onSelect;

  final DateRangePickerSelectionMode selectionMode;

  final bool Function(DateTime)? selectableDayPredicate;

  final bool? enablePastDates;

  final Map<dynamic, dynamic>? initData;

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  final _staticVar = StaticVar();

  final controller = DateRangePickerController();

  @override
  void initState() {
    if (widget.initData != null) {
      controller.selectedRange =
          PickerDateRange(widget.initData?["start_date"], widget.initData?["end_date"]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfDateRangePicker(
      selectionColor: _staticVar.primaryColor,
      allowViewNavigation: true,
      navigationMode: widget.selectionMode == DateRangePickerSelectionMode.single
          ? DateRangePickerNavigationMode.snap
          : DateRangePickerNavigationMode.scroll,
      navigationDirection: DateRangePickerNavigationDirection.vertical,

      enablePastDates: widget.enablePastDates ?? false,

      controller: controller,

      //    enableMultiView: true,
      onViewChanged: (v) {},
      onSubmit: (v) {},
      onCancel: () {
        controller.dispose();
      },
      onSelectionChanged: (DateRangePickerSelectionChangedArgs v) {
        if (widget.selectionMode == DateRangePickerSelectionMode.range &&
            v.value.startDate != null &&
            v.value.endDate != null) {
          widget.onSelect({
            "start_date": v.value.startDate,
            "end_date": v.value.endDate,
          });
        } else if (widget.selectionMode == DateRangePickerSelectionMode.single) {
          widget.onSelect({"start_date": v.value});
        }
      },
      selectionTextStyle: const TextStyle(
        color: Colors.black,
      ),
      selectionShape: DateRangePickerSelectionShape.circle,
      headerStyle: DateRangePickerHeaderStyle(
          textStyle: TextStyle(
              color: Colors.black,
              fontSize: _staticVar.titleFontSize.sp,
              fontFamily: context.read<UserController>().locale == const Locale('en')
                  ? 'Lato'
                  : 'Bhaijaan')),
      monthCellStyle: DateRangePickerMonthCellStyle(
          textStyle: TextStyle(
            fontSize: _staticVar.titleFontSize.sp,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
          todayTextStyle: TextStyle(color: _staticVar.yellowColor)),
      startRangeSelectionColor: _staticVar.primaryColor,
      endRangeSelectionColor: _staticVar.primaryColor,
      rangeSelectionColor: Colors.grey.shade200,

      rangeTextStyle: TextStyle(
          fontSize: _staticVar.titleFontSize.sp,
          color: Colors.black,
          fontFamily:
              context.read<UserController>().locale == const Locale('en') ? 'Lato' : 'Bhaijaan'),
      showNavigationArrow: false,
      showActionButtons: false,
      showTodayButton: false,
      initialDisplayDate: DateTime.now().add(const Duration(days: 3)),
      monthViewSettings: const DateRangePickerMonthViewSettings(
        showTrailingAndLeadingDates: false,
      ),

      selectableDayPredicate: (date) {
        if (widget.selectableDayPredicate != null) {
          return widget.selectableDayPredicate!(date);
        } else {
          if (date.isAtSameMomentAs(DateTime.now())) {
            return false;
          } else if (date.isBefore(DateTime.now())) {
            return false;
          } else {
            return true;
          }
        }
      },
      selectionMode: widget.selectionMode,
      initialSelectedRange: PickerDateRange(
          DateTime.now().add(const Duration(days: 1)), DateTime.now().add(const Duration(days: 4))),
    );
  }
}

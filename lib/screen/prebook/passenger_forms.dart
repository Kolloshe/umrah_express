import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
import 'package:umrah_by_lamar/model/user_models/user_model.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_user_form.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../controller/prebook_controller.dart';
import '../../model/prebook_models/passengers_for_prebook_models.dart';
import 'prebook_stepper.dart';

class PassengerFroms extends StatefulWidget {
  const PassengerFroms({super.key, required this.updateCurrentStep});

  final ValueChanged<Steppers> updateCurrentStep;

  @override
  State<PassengerFroms> createState() => _PassengerFromsState();
}

class _PassengerFromsState extends State<PassengerFroms> {
  final controller = PageController();

  final _staticVar = StaticVar();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final nationalityController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final passportNumberController = TextEditingController();
  final passportExpiryDateController = TextEditingController();

  var items = ['Mr.', 'Mrs.', 'Miss.', 'Mstr.'];

  String selectedTitle = 'Mr.';

  String selectedPhoneCode = '971';

  final pickerController = DateRangePickerController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getpassengerIfExisted(context.read<PrebookController>().pax.keys.toList()[0]);
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    nationalityController.dispose();
    dateOfBirthController.dispose();
    passportNumberController.dispose();
    passportExpiryDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.h,
      child: Consumer<PrebookController>(
        builder: (context, data, child) {
          return Form(
            key: _formKey,
            child: PageView.builder(
              controller: controller,
              itemCount: data.pax.keys.toList().length,
              itemBuilder: (context, index) => _buildForm(data.pax.keys.toList()[index],
                  currentIndex: index, totalpax: data.pax.keys.toList().length),
              onPageChanged: (value) {
                getpassengerIfExisted(data.pax.keys.toList()[value]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm(String id, {required int currentIndex, required int totalpax}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 1.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                if ((controller.page ?? 0).toInt() > 0) {
                  controller.previousPage(duration: 300.ms, curve: Curves.fastOutSlowIn);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: _staticVar.primaryColor,
                size: 20.sp,
              ),
            ),
            SizedBox(
              width: 80.w,
              child: Text(
                " ${localizePassAgeType(id.split(' ').first)} ${_buildpassingername(num.tryParse((id.split(' ').last)) ?? 0)}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: _staticVar.titleFontSize.sp,
                    color: _staticVar.cardcolor,
                    fontWeight: _staticVar.titleFontWeight),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // GestureDetector(
            //   onTap: () {
            //     showTitleSelector();
            //   },
            //   child: Text(selectedTitle,
            //       style: TextStyle(
            //           fontSize: _staticVar.titleFontSize.sp,
            //           fontWeight: _staticVar.titleFontWeight)),
            // ),
            DropdownButton<String>(
              value: selectedTitle,
              icon: const SizedBox(),
              //    dropdownColor: _staticVar.secondaryColor,
              elevation: 16,
              style:
                  TextStyle(color: _staticVar.blackColor, fontWeight: _staticVar.titleFontWeight),
              underline: const SizedBox(),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  selectedTitle = value!;
                });
              },
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: _staticVar.blackColor),
                  ),
                );
              }).toList(),
            ),
            SizedBox(
              width: 40.w,
              child: CustomUserForm(
                  controller: firstNameController,
                  hintText: AppLocalizations.of(context)?.firstName ?? "First name"),
            ),
            SizedBox(
              width: 40.w,
              child: CustomUserForm(
                  validator: (v) {
                    if (v == null) {
                      return AppLocalizations.of(context)?.thisFiledIsRequired;
                    } else if (v.isEmpty) {
                      return AppLocalizations.of(context)?.thisFiledIsRequired;
                    } else {
                      return null;
                    }
                  },
                  controller: lastNameController,
                  hintText: AppLocalizations.of(context)?.lastName ?? "Last name"),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        currentIndex < 1
            ? SizedBox(
                width: 100.w,
                child: CustomUserForm(
                  controller: emailController,
                  hintText: AppLocalizations.of(context)?.email ?? "Email",
                ),
              )
            : const SizedBox(),
        currentIndex < 1 ? SizedBox(height: 1.h) : const SizedBox(),
        currentIndex < 1
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      showCountryPicker(
                          context: context,
                          onSelect: (c) {
                            selectedPhoneCode = c.phoneCode;
                            setState(() {});
                          });
                    },
                    child: Text("+$selectedPhoneCode",
                        style: TextStyle(
                            fontSize: _staticVar.titleFontSize.sp,
                            color: _staticVar.blackColor,
                            fontWeight: _staticVar.titleFontWeight)),
                  ),
                  SizedBox(
                    width: 80.w,
                    child: CustomUserForm(
                      controller: phoneController,
                      hintText: AppLocalizations.of(context)?.phone ?? "Phone",
                    ),
                  ),
                ],
              )
            : const SizedBox(),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: 45.w,
                child: CustomUserForm(
                    onTap: () {
                      showCountryPicker(
                          context: context,
                          onSelect: (c) {
                            nationalityController.text = c.countryCode;
                            print(c.countryCode);
                          });
                    },
                    readOnly: true,
                    controller: nationalityController,
                    hintText: AppLocalizations.of(context)?.nationality ?? "nationality")),
            SizedBox(
                width: 45.w,
                child: CustomUserForm(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                                padding: EdgeInsets.all(_staticVar.defaultPadding),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 20.w,
                                      height: 1.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(_staticVar.defaultInnerRadius),
                                        color: _staticVar.primaryColor.withAlpha(150),
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    SizedBox(
                                        width: 100.w,
                                        child: SfDateRangePicker(
                                          selectionColor: _staticVar.primaryColor,
                                          allowViewNavigation: true,
                                          navigationMode: DateRangePickerNavigationMode.snap,
                                          initialSelectedDate: DateTime(2000),
                                          navigationDirection:
                                              DateRangePickerNavigationDirection.vertical,

                                          enablePastDates: true,

                                          controller: pickerController,

                                          //    enableMultiView: true,
                                          onViewChanged: (v) {},
                                          onSubmit: (v) {},
                                          onCancel: () {
                                            controller.dispose();
                                          },
                                          onSelectionChanged:
                                              (DateRangePickerSelectionChangedArgs v) {
                                            final date = v.value;
                                            if (date is DateTime) {
                                              dateOfBirthController.text =
                                                  DateFormat("y-MM-dd").format(date);
                                            }

                                            Navigator.of(context).pop();
                                          },
                                          selectionTextStyle: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          selectionShape: DateRangePickerSelectionShape.circle,
                                          headerStyle: DateRangePickerHeaderStyle(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: _staticVar.titleFontSize.sp,
                                                  fontFamily:
                                                      context.read<UserController>().locale ==
                                                              const Locale('en')
                                                          ? 'Lato'
                                                          : 'Bhaijaan')),
                                          monthCellStyle: DateRangePickerMonthCellStyle(
                                              textStyle: TextStyle(
                                                fontSize: _staticVar.titleFontSize.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              todayTextStyle:
                                                  TextStyle(color: _staticVar.yellowColor)),
                                          startRangeSelectionColor: _staticVar.primaryColor,
                                          endRangeSelectionColor: _staticVar.primaryColor,
                                          rangeSelectionColor: Colors.grey.shade200,

                                          rangeTextStyle: TextStyle(
                                              fontSize: _staticVar.titleFontSize.sp,
                                              color: Colors.black,
                                              fontFamily: context.read<UserController>().locale ==
                                                      const Locale('en')
                                                  ? 'Lato'
                                                  : 'Bhaijaan'),
                                          showNavigationArrow: false,
                                          showActionButtons: false,
                                          showTodayButton: false,
                                          initialDisplayDate:
                                              DateTime.now().add(const Duration(days: 3)),
                                          monthViewSettings: const DateRangePickerMonthViewSettings(
                                            showTrailingAndLeadingDates: false,
                                          ),

                                          selectableDayPredicate: (date) {
                                            if (date.isAtSameMomentAs(DateTime.now())) {
                                              return false;
                                            } else if (date.isAfter(DateTime.now())) {
                                              return false;
                                            } else {
                                              return true;
                                            }
                                          },
                                          selectionMode: DateRangePickerSelectionMode.single,
                                          initialSelectedRange: PickerDateRange(
                                              DateTime.now().add(const Duration(days: 1)),
                                              DateTime.now().add(const Duration(days: 4))),
                                        ))
                                  ],
                                ),
                              ));
                    },
                    readOnly: true,
                    controller: dateOfBirthController,
                    hintText: AppLocalizations.of(context)?.dOfB ?? "Date of birth")),
          ],
        ),
        SizedBox(height: 1.h),
        SizedBox(
          width: 100.w,
          child: CustomUserForm(
            controller: passportNumberController,
            hintText: AppLocalizations.of(context)?.passportNumber ?? "Passport number",
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          width: 100.w,
          child: CustomUserForm(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                        padding: EdgeInsets.all(_staticVar.defaultPadding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 20.w,
                              height: 1.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
                                color: _staticVar.primaryColor.withAlpha(150),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            SizedBox(
                                width: 100.w,
                                child: SfDateRangePicker(
                                  selectionColor: _staticVar.primaryColor,
                                  allowViewNavigation: true,
                                  navigationMode: DateRangePickerNavigationMode.snap,
                                  initialSelectedDate: DateTime.now(),
                                  navigationDirection: DateRangePickerNavigationDirection.vertical,

                                  enablePastDates: false,

                                  controller: pickerController,

                                  //    enableMultiView: true,
                                  onViewChanged: (v) {},
                                  onSubmit: (v) {},
                                  onCancel: () {
                                    controller.dispose();
                                  },
                                  onSelectionChanged: (DateRangePickerSelectionChangedArgs v) {
                                    final date = v.value;
                                    if (date is DateTime) {
                                      passportExpiryDateController.text =
                                          DateFormat("y-MM-dd").format(date);
                                    }

                                    Navigator.of(context).pop();
                                  },
                                  selectionTextStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  selectionShape: DateRangePickerSelectionShape.circle,
                                  headerStyle: DateRangePickerHeaderStyle(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: _staticVar.titleFontSize.sp,
                                          fontFamily: context.read<UserController>().locale ==
                                                  const Locale('en')
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
                                      fontFamily: context.read<UserController>().locale ==
                                              const Locale('en')
                                          ? 'Lato'
                                          : 'Bhaijaan'),
                                  showNavigationArrow: false,
                                  showActionButtons: false,
                                  showTodayButton: false,
                                  initialDisplayDate: DateTime.now().add(const Duration(days: 3)),
                                  monthViewSettings: const DateRangePickerMonthViewSettings(
                                    showTrailingAndLeadingDates: false,
                                  ),

                                  selectableDayPredicate: (date) {
                                    if (date.isAtSameMomentAs(DateTime.now())) {
                                      return false;
                                    } else if (date.isBefore(DateTime.now())) {
                                      return false;
                                    } else {
                                      return true;
                                    }
                                  },
                                  selectionMode: DateRangePickerSelectionMode.single,
                                  initialSelectedRange: PickerDateRange(
                                      DateTime.now().add(const Duration(days: 1)),
                                      DateTime.now().add(const Duration(days: 4))),
                                ))
                          ],
                        ),
                      ));
            },
            readOnly: true,
            controller: passportExpiryDateController,
            hintText: AppLocalizations.of(context)?.passportExpiry ?? "Passport Expiry date",
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    textStyle: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                    side: BorderSide(width: 2.0, color: _staticVar.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(_staticVar.defaultInnerRadius),
                      ),
                    ),
                    fixedSize: Size(46.w, 5.h)),
                onPressed: () {},
                child: Text(
                  AppLocalizations.of(context)?.scanUrDoc ?? "Scan your documents",
                  style: TextStyle(color: _staticVar.cardcolor),
                )),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    textStyle: TextStyle(fontSize: _staticVar.subTitleFontSize.sp - 1),
                    side: BorderSide(width: 2.0, color: _staticVar.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(_staticVar.defaultInnerRadius),
                      ),
                    ),
                    fixedSize: Size(46.w, 5.h)),
                onPressed: () {
                  _buildPassengerList(id.split(' ').first);
                },
                child: Text(
                  AppLocalizations.of(context)?.chooseFromPassList ?? "Choose from passenger list",
                  style: TextStyle(color: _staticVar.cardcolor),
                )),
          ],
        ),
        SizedBox(height: 1.h),
        SizedBox(
            width: 100.w,
            height: 6.h,
            child: CustomBTN(
                onTap: () {
                  if ((_formKey.currentState?.validate() ?? false) == true) {
                    filledPaxCollector(id);

                    if ((currentIndex + 1) == totalpax) {
                      widget.updateCurrentStep(Steppers.roomRequest);
                    } else {
                      controller.nextPage(duration: 300.milliseconds, curve: Curves.fastOutSlowIn);
                    }
                  }
                },
                title: AppLocalizations.of(context)?.next ?? 'Next'))
      ],
    );
  }

  String _buildpassingername(num i) {
    String name = '';
    switch (i) {
      case 1:
        name = AppLocalizations.of(context)!.first;
        break;
      case 2:
        name = AppLocalizations.of(context)!.second;
        break;
      case 3:
        name = AppLocalizations.of(context)!.third({i + 1}.toString());
        break;

      default:
        name = AppLocalizations.of(context)!
            .lastpass({i + 1}.toString().replaceAll('{', '').replaceAll('}', ''));
    }
    return name;
  }

  String localizePassAgeType(String title) {
    String text = '';

    switch (title.toLowerCase()) {
      case 'adult':
        text = AppLocalizations.of(context)?.adult ?? "adult";
        break;

      case 'child':
        text = AppLocalizations.of(context)?.child ?? "child";
        break;
      default:
        text = "مسافر";
    }
    return text;
  }

  _buildPassengerList(currentPaxType) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
              decoration: BoxDecoration(
                  color: _staticVar.cardcolor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(_staticVar.defaultRadius),
                      topRight: Radius.circular(_staticVar.defaultRadius))),
              padding: EdgeInsets.all(_staticVar.defaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            AppLocalizations.of(context)?.close ?? "Close",
                            style: TextStyle(
                                color: _staticVar.primaryColor,
                                fontSize: _staticVar.titleFontSize.sp,
                                fontWeight: _staticVar.titleFontWeight),
                          )),
                      Text(AppLocalizations.of(context)?.passengers ?? "Passengers"),
                      SizedBox(width: 1.h),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(_staticVar.defaultPadding),
                      child: ListView(
                        children: [
                          for (var passenger in (getPassengerList()).where((element) =>
                              (element.personType ?? '').contains(currentPaxType))) ...[
                            GestureDetector(
                              onTap: () {
                                fillPassengerFromList(passenger);
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "${passenger.name ?? ''} ${passenger.surname ?? ""}",
                                style: TextStyle(
                                    fontSize: _staticVar.titleFontSize.sp,
                                    fontWeight: _staticVar.titleFontWeight),
                              ),
                            ),
                            SizedBox(height: 1.h),
                            const Divider()
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }

  String selectedPassengerID = '';

  void fillPassengerFromList(PassengersDetail passenger) {
    selectedPhoneCode = passenger.phoneCode ?? "971";
    selectedTitle = passenger.title ?? "Mr.";
    firstNameController.text = passenger.name ?? "";

    lastNameController.text = passenger.surname ?? "";

    emailController.text = passenger.email ?? "";

    phoneController.text = passenger.phone ?? "";

    nationalityController.text = passenger.nationality ?? "";

    dateOfBirthController.text =
        DateFormat("y-MM-d").format(passenger.dateOfBirth ?? DateTime.now());

    passportNumberController.text = passenger.passportNumber ?? "";

    passportExpiryDateController.text =
        DateFormat("y-MM-d").format(passenger.passportExpDate ?? DateTime.now());
    selectedPassengerID = (passenger.id ?? 0).toString();

    setState(() {});
  }

  getpassengerIfExisted(paxKey) {
    final pax = context.read<PrebookController>().pax[paxKey];

    if (pax != null) {
      selectedPhoneCode = pax.phoneCode ?? '971';
      selectedTitle = pax.type;

      firstNameController.text = pax.firstName;

      lastNameController.text = pax.surname;

      emailController.text = pax.email;

      phoneController.text = pax.phone;

      nationalityController.text = pax.nationality;

      dateOfBirthController.text =
          DateFormat("y-MM-d").format((DateTime.tryParse(pax.dateofbirth) ?? DateTime.now()));

      passportNumberController.text = pax.passportnumber;

      passportExpiryDateController.text = DateFormat("y-MM-d")
          .format((DateTime.tryParse(pax.passportexpirydate) ?? DateTime.now()));
    } else {
      firstNameController.clear();
      lastNameController.clear();
      emailController.clear();
      phoneController.clear();
      nationalityController.clear();
      dateOfBirthController.clear();
      passportNumberController.clear();
      passportExpiryDateController.clear();
    }
  }

  void filledPaxCollector(String paxKey) {
    if ((_formKey.currentState?.validate() ?? false) == false) return;

    final pax = PrebookPassengerDataModel(
      firstName: firstNameController.text,
      surname: lastNameController.text,
      email: emailController.text,
      phone: phoneController.text,
      dateofbirth: dateOfBirthController.text,
      nationality: nationalityController.text,
      passportissuedcountry: nationalityController.text,
      passportnumber: passportNumberController.text,
      passportexpirydate: passportExpiryDateController.text,
      holderType: '',
      id: selectedPassengerID,
      ageType: paxKey.split(' ').first,
      type: selectedTitle,
      phoneCode: selectedPhoneCode,
    );

    context.read<PrebookController>().pax[paxKey] = pax;

    context.read<UserController>().updatePassengerData(data: pax.updatePassengerToUserTOJSON());
    selectedPassengerID = '';
  }

  List<PassengersDetail> getPassengerList() {
    final filledPaxList = context
        .read<PrebookController>()
        .pax
        .values
        .where((element) => element != null)
        .map((e) => (e?.id).toString())
        .toList();

    final userPaxList = (context.read<UserController>().userModel?.data?.passengersDetails ?? [])
        .map((e) => e)
        .toList();
    final x = userPaxList
        .where((element) => filledPaxList.contains(element.id.toString()) == false)
        .toList();

    return x;
  }

  showTitleSelector() {}
}

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
import 'package:umrah_by_lamar/model/user_models/user_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_user_form.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EditPassengerData extends StatefulWidget {
  const EditPassengerData({super.key, required this.passenger});
  final PassengersDetail passenger;

  @override
  State<EditPassengerData> createState() => _EditPassengerDataState();
}

class _EditPassengerDataState extends State<EditPassengerData> {
  final _staticVar = StaticVar();

  final firstNameController = TextEditingController();
  final surNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final passportNumberController = TextEditingController();
  final passportExpiryDateController = TextEditingController();
  final nationalityController = TextEditingController();

  List<String> titleList = ['Mr.', 'Mrs.', 'Ms.', 'Miss.', 'Mstr.'];
  String passingerTitle = 'Mr.';

  String phoneCode = '971';

  String nationality = 'AE';

  getData() {
    firstNameController.text = widget.passenger.name ?? '';
    surNameController.text = widget.passenger.surname ?? '';
    emailController.text = widget.passenger.email ?? '';
    phoneNumberController.text = widget.passenger.phone ?? '';

    phoneCode = widget.passenger.phoneCode ?? '971';

    passportNumberController.text = widget.passenger.passportNumber ?? '';

    nationalityController.text = widget.passenger.nationality ?? 'AE';

    passingerTitle = widget.passenger.title ?? 'Mr.';

    if (widget.passenger.dateOfBirth != null) {
      dateOfBirthController.text =
          DateFormat('y-MM-dd').format(widget.passenger.dateOfBirth ?? DateTime.now());
    }
    if (widget.passenger.passportExpDate != null) {
      passportExpiryDateController.text =
          DateFormat('y-MM-dd').format(widget.passenger.passportExpDate ?? DateTime.now());
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    surNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    dateOfBirthController.dispose();
    passportNumberController.dispose();
    passportExpiryDateController.dispose();
    nationalityController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.2,
        backgroundColor: _staticVar.cardcolor,
        foregroundColor: _staticVar.primaryColor,
        title: Text(
          AppLocalizations.of(context)?.editPassenger ?? 'Edit passenger',
          style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        child: ListView(
          children: [
            CustomUserForm(
              controller: firstNameController,
              hintText: AppLocalizations.of(context)?.firstName ?? "First name",
              prefix: SizedBox(
                height: 2.h,
                child: DropdownButton<String>(
                  hint: const SizedBox(),
                  disabledHint: const SizedBox(),
                  value: passingerTitle,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    size: 0,
                  ),
                  elevation: 16,
                  style: TextStyle(color: _staticVar.primaryColor),
                  underline: const SizedBox(),
                  onChanged: (String? newValue) async {
                    if (newValue != null) {
                      setState(() {
                        passingerTitle = newValue;
                      });
                    }
                  },
                  items: titleList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 0.7.h),
            CustomUserForm(
                controller: surNameController,
                hintText: AppLocalizations.of(context)?.surname ?? 'Surname'),
            SizedBox(height: 0.7.h),
            CustomUserForm(
                controller: emailController,
                hintText: AppLocalizations.of(context)?.email ?? 'Email'),
            SizedBox(height: 0.7.h),
            CustomUserForm(
              controller: phoneNumberController,
              hintText: AppLocalizations.of(context)?.phone ?? 'Phone number',
              prefix: GestureDetector(
                onTap: () {
                  getPhoneCodePicker(false);
                },
                child: Text(
                  "+$phoneCode ",
                  style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                ),
              ),
            ),
            SizedBox(height: 0.7.h),
            CustomUserForm(
              readOnly: true,
              controller: dateOfBirthController,
              hintText: AppLocalizations.of(context)?.dOfB ?? 'Date of birth',
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Container(
                        decoration: BoxDecoration(
                            color: _staticVar.cardcolor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(_staticVar.defaultRadius),
                                topRight: Radius.circular(_staticVar.defaultRadius))),
                        padding: EdgeInsets.all(_staticVar.defaultPadding),
                        child: _buildCalenderPicker(
                            isDob: true,
                            initDate: widget.passenger.dateOfBirth ?? DateTime.now())));
              },
            ),
            SizedBox(height: 0.7.h),
            CustomUserForm(
                controller: passportNumberController,
                hintText: AppLocalizations.of(context)?.passportNumber ?? 'Passport number'),
            SizedBox(height: 0.7.h),
            CustomUserForm(
              controller: passportExpiryDateController,
              readOnly: true,
              hintText: AppLocalizations.of(context)?.passportExpiry ?? 'Passport expiry date',
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Container(
                        decoration: BoxDecoration(
                            color: _staticVar.cardcolor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(_staticVar.defaultRadius),
                                topRight: Radius.circular(_staticVar.defaultRadius))),
                        padding: EdgeInsets.all(_staticVar.defaultPadding),
                        child: _buildCalenderPicker(
                            isDob: false,
                            initDate: widget.passenger.passportExpDate ?? DateTime.now())));
              },
            ),
            SizedBox(height: 0.7.h),
            CustomUserForm(
              readOnly: true,
              controller: nationalityController,
              hintText: AppLocalizations.of(context)?.nationality ?? 'Nationality',
              onTap: () {
                getPhoneCodePicker(true);
              },
            ),
            SizedBox(height: 10.h),
          ],
        ),
      )),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _staticVar.defaultPadding * 2, vertical: _staticVar.defaultPadding * 2),
        child: SizedBox(
            height: 6.h,
            width: 100.w,
            child: CustomBTN(
                onTap: () async {
                  await collectUserData();
                },
                title: AppLocalizations.of(context)?.update ?? 'Update')),
      ),
    );
  }

  collectUserData() async {
    final passengerdataInput = {
      "passenger_id": widget.passenger.id,
      "title": passingerTitle,
      "email": emailController.text,
      "first_name": firstNameController.text,
      "last_name": surNameController.text,
      "dob": dateOfBirthController.text,
      "phone": phoneNumberController.text,
      "phone_code": phoneCode,
      "passport_number": passportNumberController.text,
      "passport_expiry": passportExpiryDateController.text,
      "nationality": nationality,
      'type': "passenger"
    };

    final result =
        await context.read<UserController>().updatePassengerData(data: passengerdataInput);

    if (result) {
      _staticVar.showToastMessage(
          message: AppLocalizations.of(context)?.passengerHasBeenUpdatedSuccessfully ??
              'Passenger has been update successfully');
    }
  }

  getPhoneCodePicker(bool isNationality) {
    showCountryPicker(
      context: context,
      onSelect: (c) {
        if (isNationality) {
          nationality = c.countryCode;
          nationalityController.text = nationality;
        }

        phoneCode = c.phoneCode;

        setState(() {});
      },
      countryListTheme: CountryListThemeData(
          searchTextStyle: TextStyle(
            color: _staticVar.blackColor,
            fontSize: _staticVar.subTitleFontSize.sp,
          ),
          flagSize: 20,
          backgroundColor: _staticVar.cardcolor,
          textStyle:
              TextStyle(fontSize: _staticVar.subTitleFontSize.sp, color: _staticVar.blackColor),
          bottomSheetHeight: 75.h,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_staticVar.defaultRadius),
              topRight: Radius.circular(_staticVar.defaultRadius)),
          inputDecoration: InputDecoration(
              labelStyle: TextStyle(color: _staticVar.gray),
              floatingLabelStyle: TextStyle(color: _staticVar.blackColor),
              fillColor: _staticVar.gray.withAlpha(50),
              floatingLabelAlignment: FloatingLabelAlignment.start,
              isDense: true,
              //   contentPadding: EdgeInsets.all(_staticVar.defaultPadding),
              label: Text(
                'Search',
                style: TextStyle(
                  color: _staticVar.blackColor,
                  fontSize: _staticVar.subTitleFontSize.sp,
                ),
              ),
              filled: true,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: _staticVar.gray.withAlpha(50))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: _staticVar.gray.withAlpha(50), width: 0.7)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: _staticVar.gray.withAlpha(50))))),
    );
  }

  Widget _buildCalenderPicker({required bool isDob, required DateTime initDate}) {
    return Column(
      children: [
        SfDateRangePicker(
          initialDisplayDate: initDate,
          enablePastDates: true,
          selectionMode: DateRangePickerSelectionMode.single,
          selectableDayPredicate: (date) {
            if (isDob) {
              if (date.isBefore(DateTime.now())) {
                return true;
              } else {
                return false;
              }
            } else {
              if (date.isAfter(DateTime.now())) {
                return true;
              } else {
                return false;
              }
            }
          },
          onSelectionChanged: (date) {
            if (isDob) {
              dateOfBirthController.text = DateFormat('y-MM-dd').format(date.value);
            } else {
              passportExpiryDateController.text = DateFormat('y-MM-dd').format(date.value);
            }
            setState(() {});
          },
        ),
        SizedBox(height: 10.h),
        Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
                width: 40.w,
                height: 5.h,
                child: CustomBTN(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    title: AppLocalizations.of(context)?.select ?? "Select")))
      ],
    );
  }
}

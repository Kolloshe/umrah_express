import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/search_controller.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_user_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../widgets/custom_date_picker.dart';

class TranvelInsuranceFroms extends StatefulWidget {
  const TranvelInsuranceFroms(
      {super.key, this.preData, required this.paxKey, required this.goNext});
  final Map? preData;
  final String paxKey;
  final ValueChanged<bool> goNext;

  @override
  State<TranvelInsuranceFroms> createState() => _TranvelInsuranceFromsState();
}

class _TranvelInsuranceFromsState extends State<TranvelInsuranceFroms> {
  final _staticVar = StaticVar();
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final middelNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final nationalityController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  String phoneCode = '971';
  var items = ['Mr.', 'Mrs.', 'Miss.', 'Mstr.'];
  String title = 'Mr.';

  @override
  void dispose() {
    firstNameController.dispose();
    middelNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    nationalityController.dispose();
    dateOfBirthController.dispose();

    super.dispose();
  }

  getData() {
    if (widget.preData == null) return;

    title = widget.preData?['title'] ?? "";
    phoneCode = widget.preData?['phone']?["prefix"] ?? "";
    firstNameController.text = widget.preData?['first_name'] ?? "";
    middelNameController.text = widget.preData?['middle_name'] ?? "";
    lastNameController.text = widget.preData?['last_name'] ?? "";
    emailController.text = widget.preData?['email'] ?? "";
    phoneController.text = widget.preData?['phone']?["number"] ?? "";
    nationalityController.text = widget.preData?['nationality'] ?? "";
    dateOfBirthController.text = widget.preData?['birth_date'] ?? "";
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 7.h,
                padding: EdgeInsets.all(_staticVar.defaultPadding),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15), color: Colors.grey.shade200),
                child: DropdownButton<String>(
                  value: title,
                  icon: const SizedBox(),
                  elevation: 16,
                  style: TextStyle(
                      color: _staticVar.blackColor, fontWeight: _staticVar.titleFontWeight),
                  underline: const SizedBox(),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      title = value!;
                    });
                  },
                  items: items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                width: 80.w,
                child: CustomUserForm(
                  controller: firstNameController,
                  hintText: AppLocalizations.of(context)?.firstName ?? "First name",
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return AppLocalizations.of(context)?.thisFiledIsRequired ??
                          "This field is required";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: 47.w,
                  child: CustomUserForm(
                    controller: middelNameController,
                    hintText: AppLocalizations.of(context)?.middleName ?? "Middle name",
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return AppLocalizations.of(context)?.thisFiledIsRequired ??
                            "This field is required";
                      } else {
                        return null;
                      }
                    },
                  )),
              SizedBox(
                  width: 47.w,
                  child: CustomUserForm(
                    controller: lastNameController,
                    hintText: AppLocalizations.of(context)?.lastName ?? "Last name",
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return AppLocalizations.of(context)?.thisFiledIsRequired ??
                            "This field is required";
                      } else {
                        return null;
                      }
                    },
                  ))
            ],
          ),
          SizedBox(height: 1.h),
          isHolder()
              ? CustomUserForm(
                  controller: emailController,
                  hintText: AppLocalizations.of(context)?.email ?? "Email",
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return AppLocalizations.of(context)?.thisFiledIsRequired ??
                          "This field is required";
                    } else {
                      return null;
                    }
                  },
                )
              : const SizedBox(),
          SizedBox(height: 1.h),
          isHolder()
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showCountryPicker(
                            context: context,
                            onSelect: (c) {
                              phoneCode = c.phoneCode;
                              setState(() {});
                            });
                      },
                      child: Container(
                          width: 20.w,
                          padding: EdgeInsets.all(_staticVar.defaultPadding * 2.6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15), color: Colors.grey.shade200),
                          child: Text("+ $phoneCode")),
                    ),
                    SizedBox(
                      width: 75.w,
                      child: CustomUserForm(
                        controller: phoneController,
                        hintText: AppLocalizations.of(context)?.phone ?? "Phone",
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return AppLocalizations.of(context)?.thisFiledIsRequired ??
                                "This field is required";
                          } else {
                            return null;
                          }
                        },
                      ),
                    )
                  ],
                )
              : const SizedBox(),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: 47.w,
                  child: CustomUserForm(
                    onTap: () {
                      showCountryPicker(
                          context: context,
                          onSelect: (c) {
                            nationalityController.text = c.countryCode;

                            setState(() {});
                          });
                    },
                    controller: nationalityController,
                    readOnly: true,
                    hintText: AppLocalizations.of(context)?.nationality ?? "Nationality",
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return AppLocalizations.of(context)?.thisFiledIsRequired ??
                            "This field is required";
                      } else {
                        return null;
                      }
                    },
                  )),
              SizedBox(
                  width: 47.w,
                  child: CustomUserForm(
                    controller: dateOfBirthController,
                    onTap: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => SizedBox(
                                width: 100.w,
                                height: 60.h,
                                child: Column(
                                  children: [
                                    SizedBox(height: 1.h),
                                    Text(
                                      AppLocalizations.of(context)?.dOfB ?? "",
                                      style: TextStyle(
                                          fontSize: _staticVar.titleFontSize.sp,
                                          fontWeight: _staticVar.titleFontWeight),
                                    ),
                                    SizedBox(height: 1.h),
                                    Expanded(
                                      child: CustomDatePicker(
                                        selectableDayPredicate: (date) {
                                          if (date.isAfter(DateTime.now())) {
                                            return false;
                                          } else {
                                            return true;
                                          }
                                        },
                                        enablePastDates: true,
                                        onSelect: (value) {
                                          dateOfBirthController.text =
                                              DateFormat("y-MM-dd").format(value['start_date']!);

                                          Navigator.of(context).pop();
                                          setState(() {});
                                        },
                                        selectionMode: DateRangePickerSelectionMode.single,
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                    },
                    readOnly: true,
                    hintText: AppLocalizations.of(context)?.dOfB ?? "Date of birth",
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return AppLocalizations.of(context)?.thisFiledIsRequired ??
                            "This field is required";
                      } else {
                        return null;
                      }
                    },
                  ))
            ],
          ),
          SizedBox(height: 5.h),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
                width: 30.w,
                height: 5.h,
                child: CustomBTN(
                    onTap: () {
                      savePassenger();
                    },
                    title: AppLocalizations.of(context)?.next ?? "Next")),
          )
        ],
      ),
    );
  }

  savePassenger() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (isValid == false) return;

    if (isHolder()) {
      Map<String, dynamic> holder = {
        "title": title,
        "first_name": firstNameController.text,
        "middle_name": middelNameController.text,
        "last_name": lastNameController.text,
        "nationality": nationalityController.text,
        "birth_date": dateOfBirthController.text,
        "nationalityCountryName": nationalityController.text,
        "email": emailController.text,
        "phone": {"prefix": phoneCode, "number": phoneController.text}
      };
      context
          .read<PackSearchController>()
          .paxInformationForTravelInsuranceOrPrivetGet[widget.paxKey] = holder;

      context.read<PackSearchController>().holderDetails(holder);
    } else {
      final data = {
        "title": title,
        "first_name": firstNameController.text,
        "middle_name": middelNameController.text,
        "last_name": lastNameController.text,
        "birth_date": dateOfBirthController.text,
        "nationality": nationalityController.text
      };
      context
          .read<PackSearchController>()
          .paxInformationForTravelInsuranceOrPrivetGet[widget.paxKey] = data;
      context.read<PackSearchController>().travelInsuranceBeneficiariesDetails(widget.paxKey, data);
    }
    widget.goNext(true);
  }

  bool isHolder() => ((widget.paxKey.contains('adult') && widget.paxKey.contains('1')) ||
      widget.paxKey.contains('Holder'));
}

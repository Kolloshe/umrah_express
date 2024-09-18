import 'dart:convert';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:glass/glass.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_user_form.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  String phoneCountryCode = '971';
  String countryCode = 'AE';
  String countryFullName = '';

  final _formKey = GlobalKey<FormState>();

  final ImagePicker picker = ImagePicker();

  getUserData() {
    final userData = context.read<UserController>().userModel;

    firstNameController.text = (userData?.data?.name ?? '');
    lastNameController.text = userData?.data?.lastName ?? '';
    emailController.text = userData?.data?.email ?? '';
    phoneController.text = userData?.data?.phone ?? '';
    phoneCountryCode = userData?.data?.phoneCountryCode ?? '971';
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  final _staticVar = StaticVar();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: _staticVar.primaryColor,
        foregroundColor: _staticVar.cardcolor,
        title: Text(
          AppLocalizations.of(context)?.information ?? 'Information',
          style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
        ),
      ),
      body: Consumer<UserController>(builder: (context, data, child) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100.w,
                height: 15.h,
                decoration: BoxDecoration(
                    color: _staticVar.primaryColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(_staticVar.defaultRadius * 2),
                        bottomRight: Radius.circular(_staticVar.defaultRadius * 2))),
                padding: EdgeInsets.all(_staticVar.defaultPadding),
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () async {
                    uploadUserImage();
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CustomImage(
                            url: data.userModel?.data?.profileImage ?? '',
                            width: 25.w,
                            height: 25.w,
                            boxFit: BoxFit.cover,
                          )),
                      Positioned(
                          bottom: 3,
                          right: 1,
                          child: Container(
                            padding: EdgeInsets.all(_staticVar.defaultPadding),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: _staticVar.yellowColor),
                            child: Icon(
                              Icons.edit,
                              size: 18,
                              color: _staticVar.cardcolor,
                            ),
                          )),
                    ],
                  ),
                ),
              ).asGlass(tintColor: _staticVar.blackColor),
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(_staticVar.defaultPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),
                      CustomUserForm(
                          controller: firstNameController,
                          hintText: AppLocalizations.of(context)?.firstName ?? 'First name'),
                      SizedBox(height: 1.h),
                      CustomUserForm(
                          controller: lastNameController,
                          hintText: AppLocalizations.of(context)?.lastName ?? 'Last name'),
                      SizedBox(height: 1.h),
                      CustomUserForm(
                          controller: emailController,
                          hintText: AppLocalizations.of(context)?.email ?? 'Email'),
                      SizedBox(height: 1.h),
                      CustomUserForm(
                        controller: phoneController,
                        hintText: AppLocalizations.of(context)?.phone ?? 'phone',
                        prefix: GestureDetector(
                            onTap: () {
                              showCountryPicker(
                                context: context,
                                onSelect: (c) {
                                  countryCode = c.countryCode;

                                  countryFullName = c.name;

                                  phoneCountryCode = c.phoneCode;

                                  setState(() {});
                                },
                                countryListTheme: CountryListThemeData(
                                    searchTextStyle: TextStyle(
                                      color: _staticVar.blackColor,
                                      fontSize: _staticVar.subTitleFontSize.sp,
                                    ),
                                    flagSize: 20,
                                    backgroundColor: _staticVar.cardcolor,
                                    textStyle: TextStyle(
                                        fontSize: _staticVar.subTitleFontSize.sp,
                                        color: _staticVar.blackColor),
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
                                            borderSide:
                                                BorderSide(color: _staticVar.gray.withAlpha(50))),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(6),
                                            borderSide: BorderSide(
                                                color: _staticVar.gray.withAlpha(50), width: 0.7)),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(6),
                                            borderSide:
                                                BorderSide(color: _staticVar.gray.withAlpha(50))))),
                              );
                            },
                            child: Text('+$phoneCountryCode  ')),
                      ),
                      SizedBox(height: 15.h),
                      SizedBox(
                          width: 100.w,
                          height: 6.h,
                          child: CustomBTN(
                              onTap: () {
                                updateUserInformations();
                              },
                              title: AppLocalizations.of(context)?.update ?? "Update")),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void updateUserInformations() async {
    if ((_formKey.currentState?.validate() ?? false) == true) {
      final data = {
        "email": emailController.text,
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "phone": phoneController.text,
        "country": countryFullName,
        "phone_country_code": phoneCountryCode,
        "country_code": countryCode,
        "city_code": '',
        "postal_code": ''
      };

      final result = await context.read<UserController>().updateUserInformation(data);

      if (result) {
        _staticVar.showToastMessage(
            message: AppLocalizations.of(context)?.informationUpdatedSuccess ?? '');
      } else {}
    }
  }

  void uploadUserImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;
    final imagefile = File(image.path);
    final data = imagefile.readAsBytesSync();
    String base64Image = "data:image/png;base64,${base64Encode(data)}";

    context.read<UserController>().uploadUserImage(base64Image);
  }
}

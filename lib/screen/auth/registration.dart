import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glass/glass.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/common/utility_var.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';

import '../widgets/custom_btn.dart';
import '../widgets/custom_user_form.dart';

class ReqisterScreen extends StatefulWidget {
  const ReqisterScreen({super.key});

  @override
  State<ReqisterScreen> createState() => _ReqisterScreenState();
}

class _ReqisterScreenState extends State<ReqisterScreen> {
  TextEditingController regName = TextEditingController();
  TextEditingController regLastName = TextEditingController();
  TextEditingController regEmail = TextEditingController();
  TextEditingController regPassword = TextEditingController();
  TextEditingController regConfirmPass = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    regEmail.dispose();
    regPassword.dispose();
    regConfirmPass.dispose();
    regName.dispose();
    regLastName.dispose();
    super.dispose();
  }

  final _staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(_staticVar.defaultPadding),
              child: Image.asset("assets/images/lamarlogo/u.png")),
          Container(
            height: 100.h,
            width: 100.w,
          ).asGlass(),
          Positioned(
            child: SingleChildScrollView(
              child: Container(
                width: 100.w,
                height: 100.h,
                alignment: Alignment.center,
                padding: EdgeInsets.all(_staticVar.defaultPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(_staticVar.defaultPadding * 5),
                        decoration:
                            BoxDecoration(color: _staticVar.cardcolor, shape: BoxShape.circle),
                        child: Image.asset(
                          'assets/images/lamarlogo/u.png',
                          width: 25.w,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        AppLocalizations.of(context)?.registration ?? 'Registration',
                        style: TextStyle(
                            fontSize: _staticVar.titleFontSize.sp * 1.5,
                            fontWeight: _staticVar.titleFontWeight,
                            color: _staticVar.secondaryColor),
                      ),
                      SizedBox(height: 2.h),
                      CustomUserForm(
                        controller: regName,
                        hintText: AppLocalizations.of(context)?.firstName ?? 'First name',
                        validator: (v) {
                          if (v!.isNotEmpty) {
                            return null;
                          } else if (v.isEmpty) {
                            return "this field is required";
                          } else if (!v.contains('@')) {
                            return "Must be Email Format";
                          }
                        },
                      ),
                      SizedBox(height: 2.h),
                      CustomUserForm(
                        controller: regLastName,
                        hintText: AppLocalizations.of(context)?.lastName ?? 'Last name',
                        validator: (v) {
                          if (v!.isNotEmpty) {
                            return null;
                          } else if (v.isEmpty) {
                            return "this field is required";
                          } else if (!v.contains('@')) {
                            return "Must be Email Format";
                          }
                        },
                      ),
                      SizedBox(height: 2.h),
                      CustomUserForm(
                        controller: regEmail,
                        hintText: AppLocalizations.of(context)?.email ?? 'Email',
                        validator: (v) {
                          if (v!.isNotEmpty) {
                            return null;
                          } else if (v.isEmpty) {
                            return "this field is required";
                          } else if (!v.contains('@')) {
                            return "Must be Email Format";
                          }
                        },
                      ),
                      SizedBox(height: 2.h),
                      CustomUserForm(
                        isPassword: true,
                        controller: regPassword,
                        maxLine: 1,
                        hintText: AppLocalizations.of(context)?.rigPassword ?? 'Password',
                        validator: (v) {
                          if (v!.isNotEmpty) {
                            return null;
                          } else if (v.isEmpty) {
                            return "this field is required";
                          } else if (!v.contains('@')) {
                            return "Must be Email Format";
                          }
                        },
                      ),
                      SizedBox(height: 2.h),
                      CustomUserForm(
                        isPassword: true,
                        maxLine: 1,
                        controller: regConfirmPass,
                        hintText: AppLocalizations.of(context)?.confirmPass ?? 'Last name',
                        validator: (v) {
                          if (v!.isNotEmpty) {
                            return null;
                          } else if (v.isEmpty) {
                            return " this field is required ";
                          } else if (v.characters.length < 2) {
                            return " this field is required ";
                          }
                        },
                      ),
                      SizedBox(height: 4.h),
                      SizedBox(
                          width: 100.w,
                          height: 7.h,
                          child: CustomBTN(
                              onTap: () {
                                registrUser();
                              },
                              title:
                                  AppLocalizations.of(context)?.createAccount ?? "Create account")),
                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ).asGlass(),
            ),
          ),
        ],
      ),
    );
  }

  registrUser() async {
    if ((_formKey.currentState?.validate() ?? false) == false) return;

    final data = {
      "name": "${regName.text} ${regLastName.text}",
      "email": regEmail.text,
      "password": regPassword.text,
      "confirm_password": regConfirmPass.text,
      "selected_currency": UtilityVar.genCurrency,
      "selected_language": UtilityVar.genLanguage
    };
    final result = await context.read<UserController>().registrUser(data);

    if (result) {
      // TODO:: TO HOME PAGE OR PERBOOKING FORMS
    } else {
      // TODO: Failed to reqistr
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/common/utility_var.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_user_form.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});

  final _staticVar = StaticVar();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: _staticVar.cardcolor,
        foregroundColor: _staticVar.primaryColor,
        title: Text(
          AppLocalizations.of(context)?.changePassword ?? "Change password",
          style: TextStyle(
            fontSize: _staticVar.titleFontSize.sp,
          ),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              CustomUserForm(
                controller: oldPasswordController,
                hintText: AppLocalizations.of(context)?.oldPass ?? "Old password",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter old password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 1.h),
              CustomUserForm(
                controller: newPasswordController,
                hintText: AppLocalizations.of(context)?.newPass ?? "New password",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter new password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 1.h),
              CustomUserForm(
                controller: confirmPasswordController,
                hintText: AppLocalizations.of(context)?.confirmPass ?? "Confirm password",
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      newPasswordController.text != confirmPasswordController.text) {
                    return 'Please Confirm the password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 6.h),
              Align(
                alignment: Alignment.center,
                child: CustomBTN(
                    onTap: () {
                      if ((_formKey.currentState?.validate() ?? false) == true) {
                        final data = {
                          "token": UtilityVar.userToken,
                          "oldPassword": oldPasswordController.text,
                          "newPassword": newPasswordController.text,
                          "confirmPassword": confirmPasswordController.text
                        };
                        context.read<UserController>().changePassword(data: data);
                      }
                    },
                    title: AppLocalizations.of(context)?.changePassword ?? "Change password"),
              )
            ],
          ),
        ),
      )),
    );
  }
}

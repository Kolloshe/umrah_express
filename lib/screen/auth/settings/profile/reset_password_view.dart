import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_user_form.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ResetPasswordView extends StatelessWidget {
  ResetPasswordView({super.key});

  final _staticVar = StaticVar();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.2,
        backgroundColor: _staticVar.cardcolor,
        foregroundColor: _staticVar.primaryColor,
        title: Text(
          AppLocalizations.of(context)?.resetPassword ?? 'Reset password',
          style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(_staticVar.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              Text(
                AppLocalizations.of(context)?.pleaseEnterEmailLinkedWithThisAccount ??
                    "Please enter the Email that linked with this Account",
                style: TextStyle(
                    fontSize: _staticVar.titleFontSize.sp, fontWeight: _staticVar.titleFontWeight),
              ),
              SizedBox(height: 2.h),
              CustomUserForm(
                  controller: emailController,
                  hintText: AppLocalizations.of(context)?.enterEmail ?? "Enter Your email"),
              SizedBox(height: 5.h),
              SizedBox(
                width: 100.w,
                child: CustomBTN(
                    onTap: () {
                      if (emailController.text.isEmpty) {
                        _staticVar.showToastMessage(
                            message: 'please enter your email first ', isError: true);
                        return;
                      }
                      callresetPassword(emailController.text, context);
                    },
                    title: AppLocalizations.of(context)?.resetPassword ?? "Reset password"),
              )
            ],
          ),
        ),
      ),
    );
  }

  callresetPassword(String email, BuildContext context) async {
    Map<String, dynamic> userEmail = {'email': email};

    final result = await context.read<UserController>().resetPassword(userEmail);

    if (result) {
      _staticVar.showToastMessage(
          message: AppLocalizations.of(context)?.haveMailed ??
              "We have e-mailed your password reset link! please check your email address");
    } else {
      _staticVar.showToastMessage(
          message: AppLocalizations.of(context)?.tryAgainLater ?? "Please try again later");
    }
  }
}

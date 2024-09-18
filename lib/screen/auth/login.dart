 
 import 'package:flutter/material.dart';
 import 'package:flutter_gen/gen_l10n/app_localizations.dart';
 import 'package:glass/glass.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
import 'package:umrah_by_lamar/screen/tab_bar_view.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../widgets/custom_user_form.dart';
import 'registration.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.fromCustomize = false});
  final bool fromCustomize;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _staticVar = StaticVar();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: _staticVar.primaryColor,
      //   elevation: 0,
      //   foregroundColor: _staticVar.cardcolor,
      // ),
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container(
            //   height: 30.h,
            //   width: 100.w,
            //   padding: EdgeInsets.all(_staticVar.defaultPadding),
            //   decoration: BoxDecoration(
            //       color: _staticVar.primaryColor,
            //       borderRadius: BorderRadius.only(
            //           bottomLeft: Radius.circular(_staticVar.defaultRadius),
            //           bottomRight: Radius.circular(_staticVar.defaultRadius))),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [],
            //   ),
            // ),

            Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/lamarlogo/u.png',
                  width: 25.w,
                )),
            SizedBox(height: 1.h),
            Positioned(
              child: SingleChildScrollView(
                child: Container(
                  width: 100.w,
                  height: 100.h,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(_staticVar.defaultPadding),
                  child: Form(
                    key: formKey,
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
                          AppLocalizations.of(context)?.login ?? 'Login',
                          style: TextStyle(
                              fontSize: _staticVar.titleFontSize.sp * 1.5,
                              fontWeight: _staticVar.titleFontWeight,
                              color: _staticVar.secondaryColor),
                        ),
                        SizedBox(height: 2.h),
                        CustomUserForm(
                          controller: emailController,
                          hintText: AppLocalizations.of(context)?.enterEmail ?? 'Enter email',
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
                          controller: passwordController,
                          hintText: AppLocalizations.of(context)?.enterPass ?? 'Enter password',
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
                                  loginUser();
                                },
                                title: AppLocalizations.of(context)?.login ?? "Login")),
                        SizedBox(height: 4.h),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const ReqisterScreen()));
                          },
                          child: Text(
                            AppLocalizations.of(context)?.didHaveAccount ??
                                "Didn't have an account ?",
                            style: TextStyle(
                                fontSize: _staticVar.titleFontSize.sp,
                                color: _staticVar.primaryColor),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        // SizedBox(
                        //   width: 100.w,
                        //   child: Row(
                        //     children: [
                        //       Expanded(
                        //           child: Divider(
                        //         color: _staticVar.primaryColor,
                        //         endIndent: 10,
                        //       )),
                        //       Text(
                        //         AppLocalizations.of(context)!.orSignInWith,
                        //         style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                        //       ),
                        //       Expanded(
                        //           child: Divider(
                        //         color: _staticVar.primaryColor,
                        //         indent: 10,
                        //       )),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(height: 3.h),
                        // SignInButton(
                        //   Buttons.Facebook,
                        //   onPressed: () async {
                        //     // try {
                        //     //   pressIndcatorDialog(context);
                        //     //   final faceBookRes = await FacebookSignIn().facebookLogin();
                        //     //   if (faceBookRes != null) {
                        //     //     facebooksignhundler(faceBookRes);
                        //     //   } else {
                        //     //     Navigator.of(context).pop();
                        //     //   }

                        //     // } catch (e) {
                        //     //   Navigator.of(context).pop();
                        //     //   print(e);
                        //     // }
                        //   },
                        // ),
                        // SizedBox(height: 0.5.h),
                        // SignInButton(
                        //   Buttons.Google,
                        //   onPressed: () async {
                        //     // try {
                        //     //   pressIndcatorDialog(context);
                        //     //   final googleRes = await GoogleAuth.googleLogin();
                        //     //   if (googleRes != null) {
                        //     //     googleSignHundler(googleRes);
                        //     //   } else {
                        //     //     Navigator.of(context).pop();
                        //     //   }
                        //     // } catch (e) {
                        //     //   Navigator.of(context).pop();
                        //     //   print(e);
                        //     //   return;
                        //     // }
                        //   },
                        // ),
                        // SizedBox(height: 0.5.h),
                        // Platform.isIOS
                        //     ? SignInButton(
                        //         Buttons.AppleDark,
                        //         onPressed: () async {
                        //           // try {
                        //           //   pressIndcatorDialog(context);
                        //           //   _isRegDone = await AppleAuth.appleSignAuth(context);
                        //           //   if (!_isRegDone) {
                        //           //     Navigator.of(context).pop();
                        //           //     return;
                        //           //   }
                        //           //   if (users.data.token == '') {
                        //           //     return showDialog(
                        //           //         context: context,
                        //           //         builder: (context) => Errordislog()
                        //           //             .error(context, 'Token= ${users.data.token}'));
                        //           //   }
                        //           //   if (isFromBooking == true) {
                        //           //     Navigator.of(context).push(
                        //           //         MaterialPageRoute(builder: (context)=>PreBookStepper(isFromNavBar: context.read<AppData>().searchMode.isNotEmpty,)) );
                        //           //     return;
                        //           //   }
                        //           //   Navigator.of(context).pushNamedAndRemoveUntil(
                        //           //       TabPage.idScreen, (Route<dynamic> route) => false);
                        //           //   _isRegDone = false;
                        //           // } catch (e) {
                        //           //   Navigator.of(context).pop();
                        //           //   print(e);
                        //           // }
                        //           // print(users.data.name);
                        //         },
                        //       )
                        //     : const SizedBox(
                        //         height: 10,
                        //       ),
                      ],
                    ),
                  ),
                ).asGlass(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  loginUser() async {
    if ((formKey.currentState?.validate() ?? false)) {
      final result = await context
          .read<UserController>()
          .loginUser(email: emailController.text, password: passwordController.text);
      if (!result) return;
      if (!mounted) return;
      if (widget.fromCustomize) {
        Navigator.of(context).pop();
      } else {
        if (result) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const TabBarScreen()), (route) => false);
        }
      }
    }
  }
}

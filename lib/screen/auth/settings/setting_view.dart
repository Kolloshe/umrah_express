import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:umrah_by_lamar/common/custom_extension.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/common/utility_var.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
import 'package:umrah_by_lamar/screen/auth/login.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_pdf_view.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'profile/profile_view.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});
  static const List<String> laung = ['AR', 'EN'];

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final _staticVar = StaticVar();
  String fullName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
        ),
        elevation: 0.3,
        backgroundColor: _staticVar.cardcolor,
        foregroundColor: _staticVar.primaryColor,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        child: Consumer<UserController>(builder: (context, data, child) {
          return ListView(
            children: [
              SettingsGroup(
                title: AppLocalizations.of(context)!.general,
                titleTextStyle: TextStyle(
                    color: _staticVar.primaryColor, fontSize: _staticVar.subTitleFontSize.sp),
                children: [
                  SizedBox(height: 1.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        UtilityVar.genCurrency = 'AED';
                        setState(() {});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)?.currency ?? 'Currency',
                            style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                          ),
                          Text(
                            UtilityVar.genCurrency,
                            style: TextStyle(
                                fontSize: _staticVar.titleFontSize.sp,
                                color: _staticVar.greenColor),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: GestureDetector(
                      onTap: () async {
                        await showModalBottomSheet(
                            context: context,
                            builder: (context) => StatefulBuilder(
                                builder: (context, setState) => Container(
                                      padding: EdgeInsets.all(_staticVar.defaultPadding),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(_staticVar.defaultRadius),
                                        topRight: Radius.circular(_staticVar.defaultRadius),
                                      )),
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
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                AppLocalizations.of(context)?.language ??
                                                    "Language",
                                                style: TextStyle(
                                                  fontSize: _staticVar.titleFontSize.sp,
                                                  fontWeight: _staticVar.titleFontWeight,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 1.h),
                                          for (var lang in SettingView.laung)
                                            ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              onTap: () async {
                                                UtilityVar.genLanguage = lang.toLowerCase();
                                                data.setLocale(Locale(lang.toLowerCase()));

                                                if (data.userModel != null) {
                                                  await data.changeCurranceylanguage({
                                                    "currency": UtilityVar.genCurrency,
                                                    "language": lang
                                                  }, 'language');
                                                }
                                                Navigator.of(context).pop();
                                                setState(() {});
                                                return;
                                              },
                                              horizontalTitleGap: 0,
                                              minVerticalPadding: 0,
                                              title: Text(localizeLanguage(lang)),
                                              leading: lang.toLowerCase() ==
                                                      UtilityVar.genLanguage.toLowerCase()
                                                  ? Icon(
                                                      Icons.check,
                                                      color: _staticVar.blackColor,
                                                    )
                                                  : const SizedBox(),
                                            ),
                                        ],
                                      ),
                                    )));

                        setState(() {});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)?.language ?? 'Language',
                            style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                          ),
                          Text(
                            UtilityVar.genLanguage.capitalize(),
                            style: TextStyle(
                                fontSize: _staticVar.titleFontSize.sp,
                                color: _staticVar.greenColor),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        UtilityVar.genCurrency = 'AED';
                        setState(() {});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)?.creditBalance ?? 'Credit balance',
                            style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                          ),
                          Text(
                            "${(data.userModel?.data?.creditBalance ?? 0).toString()} ${data.userModel?.data?.currency ?? ""}",
                            style: TextStyle(
                                fontSize: _staticVar.titleFontSize.sp,
                                color: _staticVar.greenColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              SettingsGroup(
                  title: AppLocalizations.of(context)?.account ?? 'ACCOUNT',
                  titleTextStyle: TextStyle(
                      color: _staticVar.primaryColor, fontSize: _staticVar.subTitleFontSize.sp),
                  children: [
                    SimpleSettingsTile(
                      title: AppLocalizations.of(context)!.profile,
                      subtitle: data.userModel != null
                          ? data.userModel?.data?.name ?? ''
                          : AppLocalizations.of(context)!.login,
                      leading: IconWidget(icon: Icons.person, color: _staticVar.primaryColor),
                      onTap: () {
                        if (data.userModel != null) {
                        } else {
                          return;
                        }
                      },
                      titleTextStyle: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                      subtitleTextStyle: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                      child: data.userModel != null ? const ProfileScreen() : const LoginScreen(),
                    ),
                    data.userModel == null
                        ? const SizedBox()
                        : SimpleSettingsTile(
                            title: AppLocalizations.of(context)!.logout,
                            subtitle: '',
                            leading: const IconWidget(icon: Icons.logout, color: Colors.redAccent),
                            titleTextStyle: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                            subtitleTextStyle: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                            onTap: () async {
                              if (data.userModel != null) {
                                final result = await data.logoutUser();
                                if (result) {}
                              }
                            },
                          )
                  ]),
              SettingsGroup(title: AppLocalizations.of(context)!.privacyPolicyTitle, children: [
                SimpleSettingsTile(
                  title: AppLocalizations.of(context)!.privacyPolicy,
                  subtitle: '',
                  titleTextStyle: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                  leading: Container(
                    decoration: BoxDecoration(color: _staticVar.greenColor, shape: BoxShape.circle),
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.security,
                      color: Colors.white,
                      size: 6.w,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PdfView(
                              isPDF: false,
                              url: 'https://mapi2.ibookholiday.com/privacy',
                              title: AppLocalizations.of(context)!.privacyPolicy,
                            )));
                  },
                ),
                SimpleSettingsTile(
                  title: AppLocalizations.of(context)!.termsAndConditions,
                  subtitle: '',
                  titleTextStyle: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                  leading: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _staticVar.primaryColor,
                      ),
                      child: Image.asset(
                        'assets/images/terms-1.png',
                        width: 6.w,
                        color: _staticVar.cardcolor,
                      )),
                  //IconWidget(icon: Icons., color: Colors.green),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PdfView(
                              isPDF: false,
                              url: 'https://mapi2.ibookholiday.com/terms',
                              title: AppLocalizations.of(context)!.termsAndConditions,
                            )));
                  },
                )
              ]),
              SizedBox(
                height: 2.h,
              ),
              SimpleSettingsTile(
                titleTextStyle: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                title: AppLocalizations.of(context)!.contactUs,
                subtitle: '',
                leading: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _staticVar.greenColor,
                    ),
                    child: Image.asset(
                      'assets/images/whatsapp_PNG95182.png',
                      width: 6.w,
                      color: _staticVar.cardcolor,
                    )),
                //IconWidget(icon: Icons., color: Colors.green),
                onTap: _launchURL,
              )
            ],
          );
        }),
      )),
    );
  }

  String localizeLanguage(String lang) {
    String name = '';
    switch (lang.toLowerCase()) {
      case 'ar':
        name = AppLocalizations.of(context)?.ar ?? "اللغه العربيه";
        break;
      case 'en':
        name = AppLocalizations.of(context)?.en ?? "English";
        break;
      default:
        break;
    }
    return name;
  }

  String _url = 'https://wa.me/message/OIIYEFCLSXCZI1';

  void _launchURL() async {
    if (!await launchUrl(Uri.parse(_url))) throw 'Could not launch $_url';
  }
}

class IconWidget extends StatelessWidget {
  final IconData icon;
  final Color color;

  const IconWidget({Key? key, required this.icon, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}

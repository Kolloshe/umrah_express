import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:umrah_by_lamar/common/shear_pref.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/home_controller.dart';
import 'package:umrah_by_lamar/controller/prebook_controller.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'controller/customize_controller.dart';
import 'controller/search_controller.dart';
import 'controller/user_controller.dart';
import 'l10n/l10n.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalSavedData.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientations, type) {
      return MultiProvider(
          providers: [
            ChangeNotifierProvider<HomeController>(create: (_) => HomeController()),
            ChangeNotifierProvider<UserController>(create: (_) => UserController()),
            ChangeNotifierProvider<PackSearchController>(create: (_) => PackSearchController()),
            ChangeNotifierProvider<CustomizeController>(create: (_) => CustomizeController()),
            ChangeNotifierProvider<PrebookController>(create: (_) => PrebookController())
          ],
          builder: (context, child) {
            return Consumer<UserController>(builder: (context, data, child) {
              return MaterialApp(
                title: 'IBH',
                builder: EasyLoading.init(),
                supportedLocales: L10n.all,
                locale: context.read<UserController>().locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                theme: ThemeData(
                  textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(foregroundColor: StaticVar().primaryColor)),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ElevatedButton.styleFrom(foregroundColor: Colors.white)),
                  fontFamily: context.read<UserController>().locale == const Locale('en')
                      ? 'Lato'
                      : 'Bhaijaan',
                  scaffoldBackgroundColor: StaticVar().cardcolor,
                  colorScheme: ColorScheme.fromSeed(seedColor: StaticVar().primaryColor),
                  useMaterial3: false,
                ),
                home: SplashScreen(),
              );
            });
          });
    });
  }
}

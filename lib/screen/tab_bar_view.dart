import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/search_controller.dart';
import 'package:umrah_by_lamar/screen/auth/settings/setting_view.dart';
import 'package:provider/provider.dart';
import 'package:umrah_by_lamar/screen/home/home_screen_v2.dart';

import 'home/home_screen.dart';
import 'search/search_v2/search_stepper_v2.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  final _pageController = PageController();

  int _selectedIndex = 0;

  final _staticVar = StaticVar();

  List<Widget> page = const [
    //  HomeScreen(),

    HomeScreenV2(),

    // SearchStepperV2(
    //   serviceType: ServiceType.holiday,
    // ),
    SettingView(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              if (index == 1) {
                context.read<PackSearchController>().searchMode = '';
              }
              setState(() => _selectedIndex = index);
            },
            children: page),
      ),
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.height * 0.08,
        child: CustomNavigationBar(
          iconSize: 25.0,
          selectedColor: _staticVar.primaryColor,
          strokeColor: const Color(0x300c18fb),
          unSelectedColor: Colors.grey[600],
          backgroundColor: Colors.white,
          items: [
            CustomNavigationBarItem(
              icon: const Icon(Icons.home),
            ),
            // CustomNavigationBarItem(
            //   icon: const Icon(Icons.search),
            // ),
            CustomNavigationBarItem(
              icon: const Icon(Icons.settings),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _pageController.jumpToPage(index);
            });
          },
        ),
      ),
    );
  }
}

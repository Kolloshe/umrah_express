// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_google_street_view/flutter_google_street_view.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
import 'package:sizer/sizer.dart';

import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomStreetView extends StatefulWidget {
  CustomStreetView(
      {super.key,
      required this.lat,
      required this.lon,
      required this.isFromCus,
      required this.isfromHotel});
  final double lat;
  final double lon;
  bool? isFromCus;
  bool isfromHotel;

  @override
  State<CustomStreetView> createState() => _CustomStreetViewState();
}

class _CustomStreetViewState extends State<CustomStreetView> {
  bool deleay = false;
  bool hasError = false;

  StreetViewSource streetType = StreetViewSource.outdoor;
  @override
  void initState() {
    // Future.delayed(Duration(seconds: 1), () {
    //   deleay = !deleay;
    //   setState(() {});
    // });
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  StreetViewController? _controller;
  final _staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: _staticVar.cardcolor,
        title: Text(
          AppLocalizations.of(context)!.streetview,
          style: TextStyle(color: Colors.black, fontSize: _staticVar.titleFontSize),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            context.read<UserController>().locale == const Locale('en')
                ? Icons.keyboard_arrow_left
                : Icons.keyboard_arrow_right,
            size: 35,
            color: _staticVar.primaryColor,
          ),
        ),
      ),
      body: SafeArea(
          child: Stack(children: [
        FlutterGoogleStreetView(
          onPanoramaChangeListener: (location, e) {
            if (e.toString().contains('no valid panorama found')) {
              deleay = false;
              hasError = true;
              _staticVar.showToastMessage(
                  message: 'Street view is not available for this location ');
            } else {
              deleay = true;
              hasError = false;
            }
            setState(() {});
          },

          // initRadius: 10,
          initSource: streetType,
          initPos: LatLng(widget.lat, widget.lon),
          zoomGesturesEnabled: true,

          onStreetViewCreated: (controller) {
            deleay = true;
            setState(() {});
          },
        ),
        deleay
            ? const SizedBox()
            : Container(
                width: 100.w,
                height: 100.h,
                color: Colors.black,
                child: hasError
                    ? Center(
                        child: Text(
                          'Street View is unavailable for this location',
                          style: TextStyle(color: _staticVar.cardcolor),
                        ),
                      )
                    : const SizedBox(),
              ),

        //
        // Positioned(
        // top: 1,
        // right: 10,
        // child: Container(
        //   decoration: BoxDecoration(shape: BoxShape.circle, color: primaryblue),
        //   padding: EdgeInsets.all(0),
        //   child: IconButton(
        //     icon: Icon(
        //       Icons.clear,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       Navigator.of(context)
        //           .pushNamedAndRemoveUntil(CustomizeSlider.idScreen, (route) => false);
        //     },
        //   ),
        // ))
        //
      ])),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../controller/user_controller.dart';

class CustomMapView extends StatefulWidget {
  const CustomMapView({super.key, required this.lat, required this.lon});
  final double lat, lon;

  @override
  State<CustomMapView> createState() => _CustomMapViewState();
}

class _CustomMapViewState extends State<CustomMapView> {
  final _staticVar = StaticVar();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: _staticVar.cardcolor,
        title: Text(
          AppLocalizations.of(context)?.mapView ?? "Map View",
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
          child: GoogleMap(
        initialCameraPosition: CameraPosition(zoom: 14, target: LatLng(widget.lat, widget.lon)),
        markers: {
          Marker(markerId: MarkerId("${widget.lat}"), position: LatLng(widget.lat, widget.lon))
        },
      )),
    );
  }
}

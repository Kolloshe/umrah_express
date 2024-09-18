import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/customize_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../model/customize_models/flights_model/flights_listing_model.dart';
import '../../../../widgets/custom_image.dart';
import '../../../customize_flights/flight_change_view.dart';

class ChangeFlightListingScreen extends StatefulWidget {
  const ChangeFlightListingScreen({super.key, required this.flightListing, required this.grouped});
  final FlightsListingModel flightListing;
  final Map<String, List<FlightData?>> grouped;

  @override
  State<ChangeFlightListingScreen> createState() => _ChangeFlightListingScreenState();
}

class _ChangeFlightListingScreenState extends State<ChangeFlightListingScreen> {
  final _staticVar = StaticVar();

  late final flights = widget.grouped;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _staticVar.primaryColor,
        elevation: 1,
        title: Text(
          AppLocalizations.of(context)?.flights ?? "رحلات الطيران",
          style: TextStyle(
            fontSize: _staticVar.titleFontSize.sp,
          ),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        child: Consumer<CustomizeController>(builder: (context, data, child) {
          return ListView(
            children: [
              for (var career in flights.keys) ...[
                EXa(
                    collapsed: (widget.grouped[career] ?? <FlightData>[]).first,
                    expanded: (widget.grouped[career] ?? <FlightData>[]))
              ],
            ],
          );
        }),
      )),
    );
  }
}

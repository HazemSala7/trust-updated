import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../Constants/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GoogleMapView extends StatelessWidget {
  final double latt;
  final double long;

  GoogleMapView({required this.latt, required this.long});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MAIN_COLOR,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(AppLocalizations.of(context)!.merchants_location),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(latt, long),
          zoom: 10.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId("23"),
            position: LatLng(latt, long),
            infoWindow: InfoWindow(title: "Your Marker"),
          ),
        },
      ),
    );
  }
}

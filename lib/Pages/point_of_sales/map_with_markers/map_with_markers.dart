import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapWithMarkers extends StatefulWidget {
  final List<dynamic> merchants;

  MapWithMarkers({super.key, required this.merchants});

  @override
  _MapWithMarkersState createState() => _MapWithMarkersState();
}

class _MapWithMarkersState extends State<MapWithMarkers> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.merchants_location),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        markers: _createMarkers(),
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.merchants.first['coordinates']['y'],
            widget.merchants.first['coordinates']['x'],
          ),
          zoom: 10.0,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  Set<Marker> _createMarkers() {
    return widget.merchants
        .where((merchant) => merchant['coordinates'] != null)
        .map<Marker>((merchant) {
      return Marker(
        markerId: MarkerId(merchant['id'].toString()),
        position: LatLng(
          merchant['coordinates']['y'],
          merchant['coordinates']['x'],
        ),
        infoWindow: InfoWindow(
          title: merchant['name'],
          snippet: merchant['address'],
        ),
      );
    }).toSet();
  }
}

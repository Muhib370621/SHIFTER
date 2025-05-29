import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewPath extends StatefulWidget {
  final LatLng initialPosition;
  final Set<Marker> markers;
  final Set<Polyline> polyLines;
  ViewPath({required this.initialPosition, required this.markers, required this.polyLines});
  @override
  _ViewPathState createState() => _ViewPathState();
}

class _ViewPathState extends State<ViewPath> {
  GoogleMapController? _mapController;
  void onCameraMove(CameraPosition position) async {}

  // ! ON CREATE
  void onCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: false,
              initialCameraPosition:
                  CameraPosition(target: widget.initialPosition, zoom: 10),
              onMapCreated: onCreated,
              myLocationEnabled: true,
              mapType: MapType.normal,
              compassEnabled: true,
              zoomControlsEnabled: false,
              markers: widget.markers,
              onCameraMove: onCameraMove,
              polylines: widget.polyLines,
            ),
          ],
        ),
      ),
    );
  }
}

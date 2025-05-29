import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowMarker extends StatefulWidget {
  final String location;
  ShowMarker({required this.location});
  @override
  _ShowMarkerState createState() => _ShowMarkerState();
}

class _ShowMarkerState extends State<ShowMarker> {
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  GoogleMapController? _mapController;
  void onCameraMove(CameraPosition position) async {}

  // ! ON CREATE
  void onCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _addMarker(LatLng location) {
    _markers.add(Marker(
        markerId: MarkerId(location.toString()),
        position: location,
        icon: BitmapDescriptor.defaultMarker));
  }

  @override
  void initState() {
    _addMarker(LatLng(
        double.parse(
          widget.location.split(',')[0],
        ),
        double.parse(widget.location.split(',')[1])));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                      double.parse(
                        widget.location.split(',')[0],
                      ),
                      double.parse(widget.location.split(',')[1])),
                  zoom: 17.5),
              onMapCreated: onCreated,
              myLocationEnabled: false,
              mapType: MapType.normal,
              compassEnabled: true,
              zoomControlsEnabled: false,
              markers: _markers,
              onCameraMove: onCameraMove,
              polylines: _polyLines,
            )
          ],
        ),
      ),
    );
  }
}

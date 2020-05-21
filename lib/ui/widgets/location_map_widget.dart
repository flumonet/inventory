import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inventory/models/location_data.dart';

class LocationMapWidget extends StatelessWidget {
  final LocationAddressData currentLocation;

  LocationMapWidget(this.currentLocation);

  static GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery
        .of(context)
        .size
        .height;

    final CameraPosition _initPosition = CameraPosition(
      target: LatLng(
        num.parse(currentLocation.latitude.toStringAsFixed(10)),
        num.parse(currentLocation.longitude.toStringAsFixed(10)),
      ),
      zoom: 16.5,
    );

    final Set<Marker> _markers = {
      Marker(
        markerId: MarkerId('0'),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(
          title: 'Address',
          snippet: currentLocation != null ? currentLocation.address : '',
        ),
        icon: BitmapDescriptor.defaultMarker,
      )
    };
    if (_mapController != null)
    {
      _mapController.moveCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(currentLocation.latitude, currentLocation.longitude),
              zoom: 16.5,
            )
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Card(
        color: Colors.black45,
        elevation: 8,
        child: Center(
          child: Container(
            width: double.infinity,
            height: _height * 0.5,
            child: GoogleMap(
              scrollGesturesEnabled: false,
              tiltGesturesEnabled: false,
              rotateGesturesEnabled: false,
              zoomGesturesEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: _initPosition,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
            ),
          ),
        ),
      ),
    );
  }
}

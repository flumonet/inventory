import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:inventory/services/api/api_constants.dart';
import 'package:inventory/models/location_data.dart';
import 'package:inventory/models/navigation_arguments/get_location_arguments.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  static const routName = '/map';

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  double _currentZoom = 16.2;
  Function _setLocation;
  Set<Marker> _markers = {};
  LatLng _initPosition;
  LatLng _currentPosition;
  LocationData _currentLocation;

  void _setInitialLocationValues(LocationArguments _locationArguments) {
    //
    // get arguments from route
    _setLocation =
        _locationArguments != null ? _locationArguments.setLocation : null;
    final LocationAddressData _location =
        _locationArguments != null ? _locationArguments.location : null;
    //
    // Set markers
    _markers.clear();
    if (_location != null && _location.latitude != null && _location.longitude != null) {
      _currentPosition = LatLng(_location.latitude, _location.longitude);
      _markers.add(
        Marker(
          markerId: MarkerId(_currentPosition.toString()),
          position:
              LatLng(_currentPosition.latitude, _currentPosition.longitude),
        ),
      );
    } else {
      _getCurrentUserLocation().then((value) {
        _markers.add(
          Marker(
            markerId: MarkerId(_currentPosition.toString()),
            position:
                LatLng(_currentLocation.latitude, _currentLocation.longitude),
          ),
        );
        _initPosition = _currentPosition;
      });
    }
    _initPosition = _currentPosition;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_setLocation == null) {
      _setInitialLocationValues(ModalRoute.of(context).settings.arguments);
    }
  }

  Future _getCurrentUserLocation() async {
    final location = Location();
    try {
      _currentLocation = await location.getLocation();
      setState(() {
        _currentPosition =
            LatLng(_currentLocation.latitude, _currentLocation.longitude);
      });
    } catch (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Could not fetch Location'),
              content: Text(
                'Please try again later',
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
  }

  _onCameraMove(CameraPosition position) {
    _currentPosition = position.target;
  }

  Future<String> _getAddress(double lat, double lng) async {
    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {
        'latlng': '${lat.toString()},${lng.toString()}',
        'key': ApiConstants.MAPS_API_KEY
      },
    );
    final http.Response response = await http.get(uri);
    final decodedResponse = json.decode(response.body);
    final formattedAddress = decodedResponse['results'][0]['formatted_address'];
    return formattedAddress;
  }

  void _setItemLocation() async {
    if (_setLocation != null && _currentPosition != _initPosition) {
      await _getAddress(_currentPosition.latitude, _currentPosition.longitude)
          .then((value) {
        _setLocation(LocationAddressData(
          latitude: _currentPosition.latitude,
          longitude: _currentPosition.longitude,
          address: value,
        ));
      });
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height),
        child: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          flexibleSpace: _currentPosition == null
              ? Container(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: <Widget>[
                    GoogleMap(
                      markers: _markers,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: _currentPosition,
                        zoom: _currentZoom,
                      ),
                      onCameraMove: _onCameraMove,
                      compassEnabled: true,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(5),
                          ),
                          RawMaterialButton(
                            child: Icon(
                              Icons.add,
                              color: Colors.red,
                              size: 30,
                            ),
                            shape: CircleBorder(),
                            padding: const EdgeInsets.all(6),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            RawMaterialButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                Icons.cancel, //check_circle,
                                color: Colors.redAccent,
                                size: 40,
                              ),
                              shape: CircleBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 80),
                            ),
                            Expanded(
                              flex: 8,
                              child: Container(),
                            ),
                            RawMaterialButton(
                              onPressed: _setItemLocation,
                              child: Icon(
                                Icons.check_circle, //check_circle,
                                color: Colors.green,
                                size: 45,
                              ),
                              shape: CircleBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 20),
                            ),
                            Expanded(
                              flex: 7,
                              child: Container(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

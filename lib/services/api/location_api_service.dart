import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:inventory/services/api/api_constants.dart';
import 'package:inventory/services/api/location_service.dart';
import 'package:location/location.dart';

import '../../models/location_data.dart';

class LocationApiService implements LocationService {

  @override
  Future<String> getAddress(double lat, double lng) async {
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

  @override
  Future<LocationAddressData> getCurrentUserLocation() async {
    final location = Location();
      LocationData _currentLocation = await location.getLocation();
      return LocationAddressData(
        latitude: _currentLocation.latitude,
        longitude: _currentLocation.longitude,
        address: await getAddress(
        _currentLocation.latitude, _currentLocation.longitude),
      );
   }

  Future<LocationAddressData> getGeolocation(String address) async {
    if (address.isEmpty) {
      return LocationAddressData();
    }
      final Uri uri = Uri.https(
        'maps.googleapis.com',
        '/maps/api/geocode/json',
        {'address': address, 'key': ApiConstants.MAPS_API_KEY},
      );
      final http.Response response = await http.get(uri);
      final decodedResponse = json.decode(response.body);
      final formattedAddress =
      decodedResponse['results'][0]['formatted_address'];
      final coordinates = decodedResponse['results'][0]['geometry']['location'];
      return LocationAddressData(
          address: formattedAddress,
          latitude: coordinates['lat'],
          longitude: coordinates['lng']);
    }
}

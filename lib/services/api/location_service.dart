import 'package:inventory/models/location_data.dart';

abstract class LocationService {


  Future<String> getAddress(double lat, double lng);

  Future<LocationAddressData> getCurrentUserLocation();

  Future<LocationAddressData> getGeolocation(String address);
}

import 'package:inventory/models/location_data.dart';

class LocationArguments {
  final Function setLocation;
  final LocationAddressData location;

  LocationArguments({this.setLocation, this.location});
}
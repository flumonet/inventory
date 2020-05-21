import 'package:json_annotation/json_annotation.dart';

part 'location_data.g.dart';

@JsonSerializable()
class LocationAddressData {
  final double latitude;
  final double longitude;
  final String address;

  LocationAddressData({this.latitude, this.longitude, this.address});

  factory LocationAddressData.fromJson(Map<String, dynamic> json) =>
  _$LocationAddressDataFromJson(json);

  Map<String, dynamic> toJson() => _$LocationAddressDataToJson(this);

}
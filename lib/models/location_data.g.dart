// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationAddressData _$LocationAddressDataFromJson(Map<String, dynamic> json) {
  return LocationAddressData(
      latitude: (json['latitude'] as num)?.toDouble(),
      longitude: (json['longitude'] as num)?.toDouble(),
      address: json['address'] as String);
}

Map<String, dynamic> _$LocationAddressDataToJson(
        LocationAddressData instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address
    };

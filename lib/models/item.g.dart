// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
      id: json['id'] as String,
      name: json['name'] as String,
      note: json['note'] as String,
      quantity: (json['quantity'] as num)?.toDouble(),
      imageUrl: json['imageUrl'] as String,
      imagePath: json['imagePath'] as String,
      qrCode: json['qrCode'] as String,
      userEmail: json['userEmail'] as String,
      userId: json['userId'] as String,
      location: json['location'] == null
          ? null
          : LocationAddressData.fromJson(
              json['location'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'note': instance.note,
      'quantity': instance.quantity,
      'imageUrl': instance.imageUrl,
      'imagePath': instance.imagePath,
      'qrCode': instance.qrCode,
      'userEmail': instance.userEmail,
      'userId': instance.userId,
      'location': instance.location
    };

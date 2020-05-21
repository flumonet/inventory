import 'package:json_annotation/json_annotation.dart';

import './location_data.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  final String id;
  final String name;
  final String note;
  final double quantity;
  final String imageUrl;
  final String imagePath;
  final String qrCode;
  final String userEmail;
  final String userId;
  final LocationAddressData location;


  Item({this.id, this.name, this.note, this.quantity, this.imageUrl,
      this.imagePath, this.qrCode, this.userEmail, this.userId, this.location});

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);


}

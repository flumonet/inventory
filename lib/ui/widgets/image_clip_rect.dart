import 'package:flutter/material.dart';
import 'package:inventory/models/item.dart';

Widget imageClipRRect(Item item, double width, double height) {
  try {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: (item.imageUrl != null && item.imageUrl.contains('https:'))
          ? Image.network(
              item.imageUrl,
              width: width,
              height: height,
              fit: BoxFit.cover,
            )
          : Container(
              width: width,
              height: height,
              ),
    );
  } catch (e) {
    return Container(
      width: width,
      height: height,
    );
  }
}

import 'dart:io';

import 'package:inventory/models/item.dart';
import 'package:inventory/models/user.dart';
import 'package:inventory/services/api/auth_service.dart';

abstract class ItemService {
  final AuthService _authService;

  ItemService(this._authService);

  Future<List<Item>> fetchItems();

  List<Item> get getItems;

  Future<void> updateItem(Item item, File image);

  Future<void> deleteItem(Item item);

  AuthService get authService;

  double getScrollPos();

  setScrollPos(double currentScrollPos);

  void removeTrashItem(String trashItemId);

  List<Item> get getTrash;

}


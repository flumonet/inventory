import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:inventory/models/item.dart';
import 'package:inventory/models/user.dart';

abstract class ItemEvent extends Equatable {

  @override
  // ignore: missing_return
  List<Object> get props {
  }
}

class EditItemEvent extends ItemEvent {
  final Item item;

  EditItemEvent(this.item);

  @override
  String toString() => 'EditItemEvent';
}


class AddItemEvent extends ItemEvent {
  final Item item;

  AddItemEvent(this.item);

  @override
  String toString() => 'AddItemEvent';
}

class UpdateItemEvent extends ItemEvent {
  final User user;
  final Item item;
  final File image;


  UpdateItemEvent(this.user, this.item, this.image);

  @override
  String toString() => 'UpdateItemEvent';
}

class FetchItemsEvent extends ItemEvent {
  @override
  String toString() => 'FetchItemsEvent';
}


class ItemsLoadedEvent extends ItemEvent {
  @override
  String toString() => 'ItemLoadedEvent';
}

class DeleteItemEvent extends ItemEvent {
  final Item item;

  DeleteItemEvent(this.item);

  @override
  String toString() => 'DeleteItemEvent';
}

class TrashEvent extends ItemEvent {
  @override
  String toString() => 'TrashEvent';
}

class ItemDetailsEvent extends ItemEvent {
  final Item item;

  ItemDetailsEvent(this.item);

  @override
  String toString() => 'ItemDetailsEvent';
}

class MapEvent extends ItemEvent {
  @override
  String toString() => 'MapEvent';
}




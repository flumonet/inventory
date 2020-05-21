import 'package:equatable/equatable.dart';
import 'package:inventory/models/item.dart';

abstract class ItemState extends Equatable {
  ItemState([List props = const []]) : super(props);
}

class EditItemState extends ItemState {
  final Item item;

  EditItemState(this.item);
}

class AddItemState extends ItemState {
  final Item item;

  AddItemState(this.item);
}

class ItemDetailsState extends ItemState {
  final Item item;

  ItemDetailsState(this.item);
}

class InitItemState extends ItemState {}

class ItemsLoadedState extends ItemState {}

class WaitingItemsState extends ItemState {}

class TrashState extends ItemState {}

class MapState extends ItemState {}

class ItemErrorState extends ItemState {
  final Exception error;

  ItemErrorState(this.error);

  @override
  String toString() => 'ItemErrorState: $error';
}

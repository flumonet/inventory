import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:inventory/bloc/Item/item_events.dart';
import 'package:inventory/bloc/Item/item_states.dart';

import 'package:inventory/models/item.dart';
import 'package:inventory/services/api/item_service.dart';
import 'package:inventory/services/api/location_service.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> with ChangeNotifier{

  final ItemService _itemService;
  final LocationService _locationService;


  ItemBloc(this._itemService, this._locationService);

  ItemService get itemService => _itemService;

  LocationService get locationService => _locationService;

  @override
  get initialState => InitItemState();

  @override
  void onTransition(Transition<ItemEvent, ItemState> transition) {
    super.onTransition(transition);
    print('${DateTime.now()}  $transition');
  }

  @override
  Stream<ItemState> mapEventToState(ItemEvent event) async* {
    if (event is AddItemEvent) {
      yield AddItemState(event.item);
    } else if (event is ItemDetailsEvent) {
      yield ItemDetailsState(event.item);
    } else if (event is EditItemEvent) {
      yield EditItemState(event.item);
    } else if (event is UpdateItemEvent) {
      yield* _updateItem(event.item, event.image);
      yield ItemsLoadedState();
    } else if (event is DeleteItemEvent) {
      yield* _deleteItem(event.item);
    } else if (event is TrashEvent) {
      yield TrashState();
    } else if (event is ItemsLoadedEvent) {
      yield ItemsLoadedState();
     } else if (event is MapEvent) {
      yield MapState();
    } else if (event is FetchItemsEvent) {
      yield* _fetchItems();
    }
  }

  Stream<ItemState> _updateItem(Item item, File image) async* {
    yield WaitingItemsState();
    try {
      await _itemService.updateItem(item, image);
      yield ItemsLoadedState();
    } catch (e) {
      yield ItemErrorState(e);
    }
  }

  Stream<ItemState> _fetchItems() async* {
    yield WaitingItemsState();
    try {
      await _itemService.fetchItems();
      yield ItemsLoadedState();
    } catch (e) {
      yield ItemErrorState(e);
    }
  }

  Stream<ItemState> _deleteItem(Item item) async* {
    yield WaitingItemsState();
    try {
      await _itemService.deleteItem(item);
      yield ItemsLoadedState();
    } catch (e) {
      yield ItemErrorState(e);
    }
  }

}

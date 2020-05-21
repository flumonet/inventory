import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/bloc/Item/item_bloc.dart';
import 'package:inventory/bloc/Item/item_events.dart';
import 'package:inventory/bloc/Item/item_states.dart';
import 'package:inventory/ui/pages/from_trash_page.dart';
import 'package:inventory/ui/pages/item_details.dart';
import 'package:inventory/ui/pages/item_edit_page.dart';
import 'package:inventory/ui/pages/items_page.dart';
import 'package:inventory/ui/pages/wait_page.dart';

class ItemsSwitch extends StatefulWidget {
  static const routName = '/itemsPage';

  @override
  _ItemsSwitchState createState() => _ItemsSwitchState();

}

class _ItemsSwitchState extends State<ItemsSwitch> {
   @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: BlocProvider.of<ItemBloc>(context),
      listener: (context, state) {},
      builder: (context, state) => _buildState(context, state),
    );
  }

  Widget _buildState(BuildContext context, ItemState state) {

    if (state is InitItemState) {
      BlocProvider.of<ItemBloc>(context).add(FetchItemsEvent());
      return WaitPage();
    } else if (state is ItemDetailsState) {
      return ItemDetailsPage(state.item);
    } else if (state is AddItemState) {
      return ItemEditPage(state.item);
    } else if (state is TrashState) {
      return RestoreFromTrashPage();
    } else if (state is EditItemState) {
      return ItemEditPage(state.item);
    } else if (state is WaitingItemsState) {
      return WaitPage();
    } else
      return ItemsPage();
  }
}

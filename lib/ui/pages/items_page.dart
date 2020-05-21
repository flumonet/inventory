import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:inventory/bloc/Item/item_bloc.dart';
import 'package:inventory/bloc/Item/item_events.dart';
import 'package:inventory/bloc/app/app_bloc.dart';
import 'package:inventory/bloc/app/app_events.dart';
import 'package:inventory/models/item.dart';
import 'package:inventory/models/local_config.dart';
import 'package:inventory/ui/widgets/image_clip_rect.dart';

class ItemsPage extends StatefulWidget {
  static const routName = '/itemsPage';

  @override
  _ItemsPageState createState() => _ItemsPageState();

}

class _ItemsPageState extends State<ItemsPage> {
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(
        initialScrollOffset:
            BlocProvider.of<ItemBloc>(context).itemService.getScrollPos());
    _controller.addListener(_scrollPosition);
  }

  _scrollPosition() async {
    BlocProvider.of<ItemBloc>(context)
        .itemService
        .setScrollPos(_controller.position.pixels);
  }

  @override
  Widget build(BuildContext context) {
    final List<Item> _items =
        BlocProvider.of<ItemBloc>(context).itemService.getItems;
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('Items'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              BlocProvider.of<ItemBloc>(context).add(AddItemEvent(Item()));
            },
          )
        ],
      ),
      body: ListView.builder(
        controller: _controller,
        itemBuilder: (BuildContext context, int index) {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            actions: <Widget>[
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  BlocProvider.of<ItemBloc>(context)
                      .add(DeleteItemEvent(_items[index]));
                },
              ),
              IconSlideAction(
                caption: 'Edit',
                color: Colors.green,
                icon: Icons.edit_attributes,
                onTap: () {
                  BlocProvider.of<ItemBloc>(context)
                      .add(EditItemEvent(_items[index]));
                },
              ),
            ],
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: imageClipRRect(_items[index], 60, 60),
                  title: Text(
                    _items[index].name,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  subtitle: Text(
                    _items[index].note,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  trailing: SizedBox(
                    width: 55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.keyboard_arrow_right),
                          onPressed: () {
                            BlocProvider.of<ItemBloc>(context)
                                .add(ItemDetailsEvent(_items[index]));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Divider()
              ],
            ),
          );
        },
        itemCount: _items.length,
      ),
    );
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Choose',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            elevation:
                Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text(
              'Map',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/map');
            },
          ),
          ListTile(
            leading: Icon(Icons.refresh),
            title: Text(
              'Refresh',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            onTap: () {
              Navigator.pop(context);
              BlocProvider.of<ItemBloc>(context).add(FetchItemsEvent());
            },
          ),
          ListTile(
            leading: Icon(Icons.lightbulb_outline),
            title: Text(
              LocalConfig().getBool('appearanceLight')
                  ? 'Dark Appearance '
                  : 'Light Appearance',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            onTap:
                () => BlocProvider.of<AppBloc>(context)
                    .add(ChangeAppearanceEvent()),
          ),
          ListTile(
            leading: Icon(Icons.restore_from_trash),
            title: Text(
              'Trash',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            onTap: () {
              Navigator.pop(context);
              BlocProvider.of<ItemBloc>(context).add(TrashEvent());
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            onTap: () {
              BlocProvider.of<AppBloc>(context).add(InitAppEvent());
            },
          ),
        ],
      ),
    );
  }
}

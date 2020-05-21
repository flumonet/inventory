import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/bloc/Item/item_bloc.dart';
import 'package:inventory/bloc/Item/item_events.dart';
import 'package:inventory/models/item.dart';

class RestoreFromTrashPage extends StatefulWidget {
  @override
  _RestoreFromTrashPageState createState() => _RestoreFromTrashPageState();
}

class _RestoreFromTrashPageState extends State<RestoreFromTrashPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _itemService = BlocProvider.of<ItemBloc>(context).itemService;
    return Scaffold(
        appBar: AppBar(
          title: Text('Trash'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                BlocProvider.of<ItemBloc>(context).add(FetchItemsEvent());
              }),
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: _buildItemsList(context, _itemService.getTrash))
          ],
        ));
  }



  Widget _buildItemsList(BuildContext context, List<Item> _trash) {
    final _itemService = BlocProvider.of<ItemBloc>(context).itemService;

    void _restoreItem(Item _item) {
      _itemService.updateItem(_item, null).then((value) {
        setState(() {
          _itemService.removeTrashItem(_item.id);
        });
      });
    }

    return ListView.builder(
      itemCount: _itemService.getTrash.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: _trash[index].imageUrl != null && _trash[index].imageUrl !=''
                    ? NetworkImage(_trash[index].imageUrl)
                    : null,
              ),
              title: Text(_trash[index].name),
              subtitle: Text(_trash[index].note),
              trailing: IconButton(
                icon: Icon(Icons.restore),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Restoring item from the trash'),
                          content: Text(
                            'Are you sure?',
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Container(
                              width: 60,
                            ),
                            FlatButton(
                                child: Text(
                                  'Yes',
                                  style:
                                      TextStyle(color: ThemeData().accentColor),
                                ),
                                onPressed: () {
                                  _restoreItem(_trash[index]);
                                  Navigator.pop(context);
                                }),
                          ],
                        );
                      });
                },
              ),
            ),
            Divider()
          ],
        );
      },
    );
  }
}

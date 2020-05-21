import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/bloc/Item/item_bloc.dart';
import 'package:inventory/bloc/Item/item_events.dart';
import 'package:inventory/models/item.dart';
import 'package:inventory/ui/widgets/location_map_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ItemDetailsPage extends StatelessWidget {
  final Item item;

  ItemDetailsPage(this.item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () =>
              BlocProvider.of<ItemBloc>(context).add(ItemsLoadedEvent()),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(5.0),
        child: ListView(
          children: <Widget>[
            _infoWidget(context),
            _imageCard(context, item),
            item.location != null &&
                    item.location.latitude != null &&
                    item.location.longitude != null
                ? LocationMapWidget(item.location)
                : Container(),
            _addressField(context, item),
            _qrCodeWidget(context),
          ],
        ),
      ),
    );
  }

  Widget _addressField(BuildContext context, Item item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          (item.location != null) ? item.location.address ?? '' : '',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    );
  }

  Widget _imageCard(BuildContext context, Item item) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Card(
        color: Colors.black45,
        elevation: 8,
        child: Center(
          child: Container(
            child: _imageClipRRect(item),
          ),
        ),
      ),
    );
  }

  Widget _imageClipRRect(Item item) {
    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: (item.imageUrl != null && item.imageUrl != '')
            ? Image.network(
                item.imageUrl,
                fit: BoxFit.fitWidth,
              )
            : Container(),
      );
    } catch (e) {
      return Text('Image is not available!');
    }
  }

  Widget _infoWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Card(
        elevation: 8,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          item.name,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          item.note,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              (item.quantity > 0)
                  ? Container(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          color: Colors.white54,
                          elevation: 7,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Quantity',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                Text(
                                  item.quantity.toString(),
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _qrCodeWidget(BuildContext context) {
    final qrCode = item.qrCode != null ? item.qrCode : '';
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 8),
      child: Card(
        elevation: 8,
        child: Center(
          child: Container(
            child: qrCode.trim() == ''
                ? null
                : Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: CustomPaint(
                            size: Size.square(200),
                            painter: QrPainter(
                              data: qrCode,
                              version: QrVersions.auto,
                              color: Colors.black87,
                              emptyColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          qrCode,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

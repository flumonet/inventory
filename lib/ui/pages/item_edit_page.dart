import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/bloc/Item/item_bloc.dart';
import 'package:inventory/bloc/Item/item_events.dart';
import 'package:inventory/bloc/auth/auth_bloc.dart';

import 'package:inventory/models/item.dart';
import 'package:inventory/models/location_data.dart';
import 'package:inventory/ui/widgets/ensure_visible.dart';
import 'package:inventory/ui/widgets/image_input.dart';
import 'package:inventory/ui/widgets/invent_button.dart';
import 'package:inventory/ui/widgets/location_input.dart';

class ItemEditPage extends StatefulWidget {
  final Item item;

  ItemEditPage(this.item);

  @override
  State<StatefulWidget> createState() {
    return _ItemEditPageState();
  }
}

class _ItemEditPageState extends State<ItemEditPage> {
  final Map<String, dynamic> _formData = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();
  final _noteFocusNode = FocusNode();
  final _quantityFocusNode = FocusNode();
  final _qrCodeFocusNode = FocusNode();
  final _nameTextController = TextEditingController();
  final _noteTextController = TextEditingController();
  final _quantityTextController = TextEditingController();
  final _qrCodeTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              BlocProvider.of<ItemBloc>(context).add(FetchItemsEvent());
            }),
        title: widget.item.id == null || widget.item.id == ''
            ? Text('New Item')
            : Text('Edit Item'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: _buildPageContent(context, widget.item),
    );
  }

  Widget _buildPageContent(BuildContext context, Item item) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildInfo(item),
              SizedBox(height: 10.0),
              ImageInput(_setImage, item),
              SizedBox(height: 10.0),
              LocationInput(_setLocation, item.location),
              SizedBox(height: 10.0),
              _buildQRC(item),
              SizedBox(height: 10.0),
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(Item item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            _buildNameTextField(item),
            _buildNoteTextField(item),
            _buildQuantityTextField(item),
          ],
        ),
      ),
    );
  }

  Widget _buildQRC(Item item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            _buildQrTextField(item),
            InventoryButton('Get QR Code', _getQRC),
          ],
        ),
      ),
    );
  }

  Widget _buildNameTextField(Item item) {
    if (item == null && _nameTextController.text.trim() == '') {
      _nameTextController.text = '';
    } else if (item != null && _nameTextController.text.trim() == '') {
      _nameTextController.text = item.name;
    }
    return EnsureVisibleWhenFocused(
      focusNode: _nameFocusNode,
      child: TextFormField(
        focusNode: _nameFocusNode,
        decoration: InputDecoration(labelText: 'Name'),
        controller: _nameTextController,
        validator: (String value) {
          if (value.isEmpty || value.length < 3) {
            return 'Name is required and should be 5+ characters long.';
          } else
            return null;
        },
        onSaved: (String value) {
          _formData['name'] = value;
        },
      ),
    );
  }

  Widget _buildNoteTextField(Item item) {
    if (item == null && _noteTextController.text.trim() == '') {
      _noteTextController.text = '';
    } else if (item != null && _noteTextController.text.trim() == '') {
      _noteTextController.text = item.note;
    }
    return EnsureVisibleWhenFocused(
      focusNode: _noteFocusNode,
      child: TextFormField(
        focusNode: _noteFocusNode,
        maxLines: 2,
        decoration: InputDecoration(labelText: 'Note'),
        controller: _noteTextController,
        onSaved: (String value) {
          _formData['note'] = value;
        },
      ),
    );
  }

  Future<void> _getQRC() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      if (barcodeScanRes != '-1') _qrCodeTextController.text = barcodeScanRes;
    });
    SystemSound.play(SystemSoundType.click);
  }

  Widget _buildQrTextField(Item item) {
    if (item != null && _qrCodeTextController.text.trim() == '')
      _qrCodeTextController.text = item.qrCode;

    return EnsureVisibleWhenFocused(
      focusNode: _qrCodeFocusNode,
      child: TextFormField(
          focusNode: _qrCodeFocusNode,
          decoration: InputDecoration(labelText: 'QR code'),
          controller: _qrCodeTextController,
          onSaved: (String value) {
            _formData['qrCode'] = value;
          }),
    );
  }

  Widget _buildQuantityTextField(Item item) {
    if (item == null && _quantityTextController.text.trim() == '') {
      _quantityTextController.text = '';
    } else if (item != null && _quantityTextController.text.trim() == '') {
      _quantityTextController.text =
          item.quantity != null ? item.quantity.toString() : '';
    }
    return EnsureVisibleWhenFocused(
      focusNode: _quantityFocusNode,
      child: TextFormField(
        focusNode: _quantityFocusNode,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'Quantity of the item'),
        controller: _quantityTextController,
        validator: (String value) {
          // if (value.trim().length <= 0) {
          if (!RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$').hasMatch(value)) {
            return 'quantity is required and should be a number.';
          } else
            return null;
        },
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InventoryButton(
          'Save the entire item',
          () => _submitForm(context),
        ),
      ),
    );
  }

  void _setLocation(LocationAddressData locData) {
    _formData['location'] = locData;
  }

  void _setImage(File imageFile) {
    _formData['imageFile'] = imageFile;
  }

  Future<void> _submitForm(BuildContext context) async {
    final user = BlocProvider.of<AuthBloc>(context).authService.user;
    final itemService = BlocProvider.of<ItemBloc>(context).itemService;
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    BlocProvider.of<ItemBloc>(context).add(UpdateItemEvent(
        user,
        Item(
          id: widget.item.id,
          name: _nameTextController.text,
          note: _noteTextController.text,
          quantity: double.parse(
              _quantityTextController.text.replaceFirst(RegExp(r','), '.')),
          imageUrl: widget.item.imageUrl,
          imagePath: widget.item.imagePath,
          userEmail: user.email,
          qrCode: _formData['qrCode'],
          userId: user.id,
          location: _formData['location'],
        ),
        _formData['imageFile']));
  }
}

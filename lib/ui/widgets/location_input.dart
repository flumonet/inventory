import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/bloc/Item/item_bloc.dart';
import 'package:inventory/models/navigation_arguments/get_location_arguments.dart';
import 'package:inventory/services/api/location_service.dart';
import 'package:inventory/ui/pages/map_page.dart';
import 'package:inventory/ui/widgets/ensure_visible.dart';
import 'package:inventory/ui/widgets/invent_button.dart';
import 'package:inventory/ui/widgets/location_map_widget.dart';

import '../../models/location_data.dart';

class LocationInput extends StatefulWidget {
  final Function setLocation;
  final LocationAddressData location;

  LocationInput(this.setLocation, this.location);

  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  final FocusNode _addressInputFocusNode = FocusNode();
  final TextEditingController _addressInputController = TextEditingController();

  LocationService
      _locationService; // = BlocProvider.of<InventBloc>(context).locationService;
  LocationAddressData _locationData;

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    _locationData = widget.location;
    _addressInputController.text = _locationData != null ? _locationData.address??'':'';
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _locationService = BlocProvider.of<ItemBloc>(context).locationService;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  void _setLocation(LocationAddressData locationAddressData) {
    setState(() {
      _locationData = locationAddressData;
      widget.setLocation(_locationData);
      _addressInputController.text = _locationData.address;
    });
  }

  void _updateLocation() async {
    if (!_addressInputFocusNode.hasFocus) {
      await _locationService
          .getGeolocation(_addressInputController.text)
          .then((value) => {
                setState(() {
                  _locationData = LocationAddressData(
                      latitude: value.latitude,
                      longitude: value.longitude,
                      address: _addressInputController.text);
                  _setLocation(_locationData);
                })
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            _locationData == null
                ? Container()
                : LocationMapWidget(_locationData),
            EnsureVisibleWhenFocused(
              focusNode: _addressInputFocusNode,
              child: TextFormField(
                focusNode: _addressInputFocusNode,
                controller: _addressInputController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
            ),
            SizedBox(height: 10.0),
            InventoryButton('Get location', () {
              Navigator.pushNamed(context, MapPage.routName,
                  arguments: LocationArguments(
                      setLocation: _setLocation, location: _locationData));
            }),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}

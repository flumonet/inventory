import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/bloc/app/app_bloc.dart';
import 'package:inventory/bloc/app/app_events.dart';
import 'package:inventory/bloc/app/app_states.dart';
import 'package:inventory/ui/pages/auth_page.dart';
import 'package:inventory/ui/pages/items_page.dart';
import 'package:inventory/ui/widgets/switches/items_switch.dart';

class AppPage extends StatefulWidget {
  final Function() changeAppearance;

  @override
  _AppPageState createState() => _AppPageState();

  AppPage(this.changeAppearance);
}

class _AppPageState extends State<AppPage> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: BlocProvider.of<AppBloc>(context),
      listener: (context, state) {
        if (state is ChangeAppearanceState) {
          widget.changeAppearance();
          BlocProvider.of<AppBloc>(context)
              .add(IdleAppEvent());
        }
      },
      builder: _buildState,
    );
  }

  Widget _buildState(BuildContext context, AppState state) {
    if (state is InitAppState) {
      return AuthPage();
    } else
      return ItemsSwitch();
  }
}

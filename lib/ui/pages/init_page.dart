import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/bloc/app/app_bloc.dart';
import 'package:inventory/bloc/auth/auth_bloc.dart';
import 'package:inventory/di/injector.dart';
import 'package:inventory/models/local_config.dart';
import 'package:inventory/ui/pages/app_page.dart';
import 'package:inventory/ui/pages/auth_page.dart';
import 'package:inventory/ui/pages/from_trash_page.dart';
import 'package:inventory/ui/pages/items_page.dart';
import 'package:inventory/ui/pages/map_page.dart';
import 'package:inventory/ui/themes/themes_dark.dart';
import 'package:inventory/ui/themes/themes_light.dart';

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  final AppBloc _appBloc = Injector.container.resolve<AppBloc>();

  bool _appearanceLight = LocalConfig().getBool('appearanceLight');

  @override
  void dispose() {
    super.dispose();
    _appBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => _appBloc,
        ),
        BlocProvider(
          create: (BuildContext context) => _appBloc.authBloc,
        ),
        BlocProvider(
          create: (BuildContext context) => _appBloc.itemBloc,
        ),
      ],
      child: MaterialApp(
        theme: themeDataLight(),
        darkTheme: themeDataDark(),
        themeMode: _appearanceLight ? ThemeMode.light : ThemeMode.dark,
        routes: {
          MapPage.routName: (context) => MapPage(),
          ItemsPage.routName: (context) => ItemsPage(),
          AuthPage.routName: (context) => AuthPage(),
          '/fromTrash': (BuildContext context) => RestoreFromTrashPage(),
        },
        home: AppPage(_changeAppearance),
      ),
    );
  }

  void _changeAppearance() {
    setState(() {
      _appearanceLight = !_appearanceLight;
    });
    LocalConfig().updateValue('appearanceLight', _appearanceLight);
  }
}

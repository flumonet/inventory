
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inventory/di/injector.dart';
import 'package:inventory/models/local_config.dart';
import 'package:inventory/ui/pages/init_page.dart';


void runApplication() async {

  WidgetsFlutterBinding.ensureInitialized();

  await LocalConfig().readFromPrefs();
  if (LocalConfig().getBool("appearanceLight") == null)
    LocalConfig().updateValue("appearanceLight", true);

  Injector.setup();
  _setupErrorHandling();
  runApp(InitPage());
}

void _setupErrorHandling() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };
}


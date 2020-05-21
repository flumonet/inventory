import 'package:flutter/material.dart';

ThemeData themeDataDark() {
  final base = ThemeData.dark();
  return base.copyWith(
    textTheme: textThemeDark(base.textTheme),
  );
}

TextTheme textThemeDark(TextTheme base) {
  return base.copyWith(
    overline: base.overline.copyWith( fontSize: 14, fontFamily: 'GoogleSans'),
    caption: base.caption.copyWith( fontSize: 14, fontFamily: 'GoogleSans'),
    subtitle1: base.subtitle1.copyWith( fontSize: 16, fontFamily: 'GoogleSans'),
    subtitle2: base.subtitle2.copyWith( fontSize: 18, fontFamily: 'RobotoCondensed'),
    bodyText1: base.bodyText1.copyWith( fontSize: 16, fontWeight: FontWeight.w700,fontFamily: 'GoogleSans'),
    bodyText2: base.bodyText2.copyWith( fontSize: 14, fontFamily: 'RobotoCondensed'),
  );
}


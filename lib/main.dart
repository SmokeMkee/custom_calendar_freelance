import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'custom_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ar', ''),
        Locale('ru ', '')
      ],
      locale: const Locale('ru', ''),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: SafeArea(
          child: CustomCalendar(
            locale: 'ru',
            pathEkadashi: 'assets/svg/ ekadashi.svg',
            pathFullMoon: 'assets/svg/full_moon.svg',
            pathGrowingMoon: 'assets/svg/growing_moon.svg',
            pathWaningMoon: 'assets/svg/waning_moon.svg',
            headerLeftArrowButton: 'assets/svg/left_chevron.svg',
            headerRightArrowButton: 'assets/svg/right_chevron.svg',
            onPageChanged: (_) {},
            onHeaderTapped: (_) {},
          ),
        ),
      ),
    );
  }
}


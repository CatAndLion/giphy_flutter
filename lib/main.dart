import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giphy_flutter/ui/MainPage.dart';
import 'package:giphy_flutter/util/UiUtils.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Giphy app',
      theme: ThemeData(
        primaryColor: UiUtils.colorPrimaryDark
      ),
      home: MainPage(),

      debugShowCheckedModeBanner: false,
    );
  }
}
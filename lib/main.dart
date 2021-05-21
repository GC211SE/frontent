import 'package:flutter/material.dart';
import 'package:gcrs/views/checkinView.dart';
import 'package:gcrs/views/homeView.dart';
import 'package:gcrs/views/loginView.dart';
import 'package:gcrs/views/reservationView.dart';
import 'package:gcrs/views/searchView.dart';
import 'package:gcrs/views/searchView2.dart';
import 'package:gcrs/views/settingView.dart';
import 'package:gcrs/views/statusView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginView(),
      routes: {
        "/LoginView": (_) => LoginView(),
        "/HomeView": (_) => HomeView(),
        "/SettingView": (_) => SettingView(),
        "/ReservationView": (_) => ReservationView(),
        "/Status": (_) => StatusView(),
        "/Checkin": (_) => CheckinView(),
        "/Search": (_) => SearchView(),
        "/Search2": (_) => SearchView2(),
      },
      theme: ThemeData(fontFamily: "Nanum"),
    );
  }
}

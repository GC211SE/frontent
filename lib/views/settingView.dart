import 'package:flutter/material.dart';
import 'package:gcrs/utils/GlobalVariables.dart';

class SettingView extends StatefulWidget {
  SettingView({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.of(context).size.width > GlobalVariables.mobileWidth
          ?
      // Desktop(Web) UI
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("HomeView - Desktop"),
            ],
          ),
        ],
      )
          :
      // Mobile(App) UI
      // Implement design code here
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("HomeView - Mobile"),
            ],
          ),
        ],
      ),
      // This will be removed (TEST)
      floatingActionButton: FloatingActionButton(
        child: Text(
          "Login\nView",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10),
        ),
        onPressed: () => Navigator.pushNamed(context, "/LoginView"),
      ),
    );
  }
}

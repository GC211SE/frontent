import 'package:flutter/material.dart';
import 'package:gcrs/utils/GlobalVariables.dart';

class SettingView extends StatefulWidget {
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
                    Text("SettingView - Desktop"),
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
                    Text("SettingView - Mobile"),
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

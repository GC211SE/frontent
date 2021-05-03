import 'package:flutter/material.dart';
import 'package:gcrs/utils/GlobalVariables.dart';

class ReservationView extends StatefulWidget {
  @override
  _ReservationViewState createState() => _ReservationViewState();
}

class _ReservationViewState extends State<ReservationView> {
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
                    Text("ReservationView - Desktop"),
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
                    Text("ReservationView - Mobile"),
                  ],
                ),
              ],
            ),

      // This will be removed (TEST)
      floatingActionButton: FloatingActionButton(
        child: Text(
          "Setting\nView",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10),
        ),
        onPressed: () => Navigator.pushNamed(context, "/SettingView"),
      ),
    );
  }
}

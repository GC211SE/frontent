import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcrs/utils/GlobalVariables.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
          "Reservation\nView",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10),
        ),
        onPressed: () => Navigator.pushNamed(context, "/ReservationView"),
      ),
    );
  }
}

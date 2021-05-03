import 'package:flutter/material.dart';
import 'package:gcrs/utils/GlobalVariables.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
                    Text("LoginView - Desktop"),
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
                    Text("LoginView - Mobile"),
                  ],
                ),
              ],
            ),

      // This will be removed (TEST)
      floatingActionButton: FloatingActionButton(
        child: Text(
          "Home\nView",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10),
        ),
        onPressed: () => Navigator.pushNamed(context, "/HomeView"),
      ),
    );
  }
}

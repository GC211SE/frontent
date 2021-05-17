import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcrs/utils/GlobalVariables.dart';
import 'package:gcrs/utils/notification.dart';
import 'package:http/http.dart' as http;

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  FirebaseCloudMessaging cloudMessaging = FirebaseCloudMessaging();

  @override
  void initState() {
    Future(cloudMessaging.init);
    super.initState();
  }

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
                    ElevatedButton(
                      onPressed: () => sendRequest(),
                      child: Text("SEND API"),
                    ),
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

  Future<void> sendRequest() async {
    String appToken = await FirebaseMessaging.instance.getToken();
    print(appToken);
    await http.post(
      Uri.parse("https://gcse.doky.space/api/reservation/pushtest"),
      body: {"appToken": appToken},
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gcrs/Widget/dateDrawer.dart';
import 'package:gcrs/Widget/timetable.dart';
import 'package:gcrs/utils/GlobalVariables.dart';

class ReservationView extends StatefulWidget {
  @override
  _ReservationViewState createState() => _ReservationViewState();
}

class _ReservationViewState extends State<ReservationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DateDrawer(),
      appBar: AppBar(
        title: Text('Side menu'),
      ),
      /*
      body: MediaQuery.of(context).size.width > GlobalVariables.mobileWidth
          ?
          // Desktop(Web) UI
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(" - Desktop"),
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
                    Text(" - Mobile"),
                  ],
                ),
              ],
            ),
*/
      body: WeeklyTimeTable(
//        cellColor: Color.fromRGBO(0, 184, 255, 1.0),
//        cellSelectedColor: Color.fromRGBO(189, 0, 255, 1.0),
//        boarderColor: Color.fromRGBO(0,30,255, 1.0),

        locale: 'ko',
        onValueChanged: (Map<int, List<int>>selected) {
          print(selected);
        },
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

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
        title: Text(''),
      ),
      body: WeeklyTimeTable(
//        cellColor: Color.fromRGBO(0, 184, 255, 1.0),
//        cellSelectedColor: Color.fromRGBO(189, 0, 255, 1.0),
//        boarderColor: Color.fromRGBO(0,30,255, 1.0),
        locale: 'ko',
        onValueChanged: (Map<int, List<int>>selected) {
          print(selected);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem( // select about
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Classroom',
          ),
        ],
        // selectedItemColor: Colors.amber[800],
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

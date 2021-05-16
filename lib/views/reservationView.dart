import 'package:flutter/material.dart';
import 'package:gcrs/Widget/timetable.dart';

import 'package:gcrs/utils/GlobalVariables.dart';

var thisContext;
class ReservationView extends StatefulWidget {
  @override
  _ReservationViewState createState() => _ReservationViewState();
}

class _ReservationViewState extends State<ReservationView> {
  @override
  Widget build(BuildContext context) {
    thisContext = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),

      /*** timetable ***/
      body: WeeklyTimeTable(
        // setting color of timetable cell
        //cellColor: Color.fromRGBO(0, 184, 255, 1.0),
        //cellSelectedColor: Color.fromRGBO(189, 0, 255, 1.0),
        //boarderColor: Color.fromRGBO(0,30,255, 1.0),
        locale: 'ko', // language
        /*
        onValueChanged: (Map<int, List<int>>selected) {   //TODO function 구현 안됨
          print(selected);
        },
        */
      ),


      floatingActionButton: Stack(
        children: <Widget>[

          /*** This will be removed (TEST) ***/
          Padding(padding: EdgeInsets.only(bottom:160),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: "btn2",
                onPressed: () => Navigator.pushNamed(context, "/SettingView"),
                child: Text(
                  "Setting\nView",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),),
        ],
      ),
    );
  }
}
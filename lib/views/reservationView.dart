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
          /*** 하단 bottom Calendar button -> choose week to make reservation***/
          Padding(padding: EdgeInsets.only(bottom:0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                heroTag: "calendar",
                onPressed: (){calendarListDialog();}, //TODO: add onPress make calendar
                icon: Icon(Icons.calendar_today_outlined),
                label: Text("Calendar") ),
            ),),
          /*** 하단 bottom Classroom button -> choose classroom to make reservation***/
          Padding(padding: EdgeInsets.only(bottom:60),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                heroTag: "classroom",
                onPressed: (){classroomListDialog();},
                icon: Icon(Icons.school), //TODO: add onPress show classroom list
                label: Text("Classroom") ),
            ),),


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


// TODO: get classroom list and popup
/* class room list 띄움 */
Future<void> classroomListDialog() async {
  // TODO: 건물 이름으로 list 받아와서 넣기
  var department = ['a','b','c','d','e'];
  return showDialog<void>(
    // TODO: get context 찾기 -> 이거 이렇게 하는거 아닌것 같은데 다른 방법 있는것 같은데 모르겠음
    context: thisContext,
      barrierDismissible: false, //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder( // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
              borderRadius: BorderRadius.circular(10.0)),
          //Dialog Main Title
          title: Column(children: <Widget>[new Text("Department"),],),
          content: SingleChildScrollView(
            //https://fenderist.tistory.com/130 listview로 department 출력
              child : ListBody(
              children: <Widget>[
                // TODO: https://duzi077.tistory.com/301 보고 onclick 구현
                Card(
                    // child: new Text(department[0])
                  child: Row(
                  )
                ),

                Text('This is a demo alert dialog.'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("확인"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}

// TODO: get calendar list and popup
/* calendar dialog 띄움 */
Future<void> calendarListDialog() async {
  // TODO: 건물 이름으로 list 받아와서 넣기
  return showDialog<void>(
    // TODO: get context 찾기 -> 이거 이렇게 하는거 아닌것 같은데 다른 방법 있는것 같은데 모르겠음
      context: thisContext,
      barrierDismissible: false, //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder( // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
              borderRadius: BorderRadius.circular(10.0)),
          //Dialog Main Title
          title: Column(children: <Widget>[new Text("Calendar"),],),
          content: SingleChildScrollView(
            child : ListBody(
              children: <Widget>[


                Text('This is week picker.'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("확인"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}
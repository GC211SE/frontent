import 'package:flutter/material.dart';
import 'package:gcrs/Widget/dateDrawer.dart';
import 'package:gcrs/Widget/timetable.dart';
import 'package:gcrs/utils/GlobalVariables.dart';

var thisContext = null;
class ReservationView extends StatefulWidget {
  @override
  _ReservationViewState createState() => _ReservationViewState();
}

class _ReservationViewState extends State<ReservationView> {
  @override
  Widget build(BuildContext context) {
    thisContext = context;
    return Scaffold(
      drawer: DateDrawer(),
      appBar: AppBar(
        title: Text(''),
      ),
      body: WeeklyTimeTable(
        // setting color of timetable cell
        //cellColor: Color.fromRGBO(0, 184, 255, 1.0),
        //cellSelectedColor: Color.fromRGBO(189, 0, 255, 1.0),
        //boarderColor: Color.fromRGBO(0,30,255, 1.0),
        locale: 'ko',
        onValueChanged: (Map<int, List<int>>selected) {
          print(selected);
        },
      ),

      //TODO: add onPress
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(bottom:0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                heroTag: "calendar",
                onPressed: (){},
                icon: Icon(Icons.calendar_today_outlined),
                label: Text("Calendar") ),
            ),),
          Padding(padding: EdgeInsets.only(bottom:60),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                heroTag: "classroom",
                onPressed: (){classroomListDialog();},
                icon: Icon(Icons.school),
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
  return showDialog<void>(
    // TODO: get context 찾기
      // context: context,
    context: thisContext,
      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          //Dialog Main Title
          title: Column(
            children: <Widget>[
              new Text("Dialog Title"),
            ],
          ),
          //
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
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
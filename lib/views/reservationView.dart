import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcrs/Widget/timetable.dart';
import 'package:gcrs/utils/GlobalVariables.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';

var thisContext;

// https://gcse.doky.space/api/schedule?bd=IT대학&crn=304
// TODO: make class to save lecture
class Lecture {
  String date; // 요일
  String time; // 시간 -> 밑에 MAP 으로 시간 알아봅시다

  Lecture({
    this.date,
    this.time
  });

  timeCalculator(int time){
    // split nth 교시 to hour and minute
    int startHour = int.parse(convertToActualTime[time][0].substring(0,2));
    int startMinute = int.parse(convertToActualTime[time][0].substring(2,4));
    int endHour = int.parse(convertToActualTime[time][1].substring(0,2));
    int endMinute = int.parse(convertToActualTime[time][1].substring(2,4));
    int height = 60;

    Map<int, List<int>> hourSplit = {};
    /// 시간 계산 ----------------> 끝
    /// 만약 시간 차가 1이라면 2개의 셀에 시간표를 그려줘야함  -> list에 2개의 시간대
    /// 아니라면 1개의 셀을 잘라서 쓰면 됨 -> list에 1개의 시간대
    /// 분 계산
    /// list (hour index(height, bool) * 2) -> true 면 height 만큼 칠해주고 false 면 안칠해주기, hour index에 해당하는 시간에
    if (startHour == endHour){
      if (startMinute == 0){ // 앞에 붙은 1, 0
        hourSplit.addAll({startHour:[
          startMinute, 1,
          60 - endMinute, 0]});
      }
      else if (endMinute < 60){ // 0, 가운데 낀 1, 0
        hourSplit.addAll({startHour:[
          startMinute, 0,
          60 - endMinute - startMinute, 1,
          60 - endMinute, 0]});
      }
      else { // 0, 뒤에 붙은 1
        hourSplit.addAll({startHour:[
          endMinute, 0,
          60 - endMinute, 1]});
      }
    }
    else{ // (0,1), (1,0)
      if (endMinute != 0){
        hourSplit.addAll({startHour:[
          startMinute, 0,
          60 - startMinute, 1]});
        hourSplit.addAll({endHour:[
          endMinute, 1,
          60 - endMinute, 0]});
      }
      else { // (0,1),
        hourSplit.addAll({startHour:[
          startMinute, 0,
          60 - startMinute, 1]});
      }
      // hourSplit.addAll({startHour:[1,1]});
      // 60 - startMinute;
      // endMinute;
    }
    return hourSplit;

    /// cell 에 받은거 만큼 다른색으로 칠해주는 함수 추가 요망
  }

  // format = name:[start time, end time]
  static final Map<String, List<String>> convertToActualTime = {
    '1': ["09:00", "09:50"],
    '2': ["10:00", "10:50"],
    '3': ["11:00", "11:50"],
    '4': ["12:00", "12:50"],
    '5': ["13:00", "13:50"],
    '6': ["14:00", "14:50"],
    '7': ["15:00", "15:50"],
    '8': ["16:00", "16:50"],
    '9': ["17:30", "18:20"],
    '10': ["18:25", "19:15"],
    '11': ["19:20", "20:10"],
    '12': ["20:15", "21:05"],
    '13': ["21:10", "22:00"],
    '14': ["22:05", "22:55"],

    '21': ["09:30", "10:45"],
    '22': ["11:00", "12:15"],
    '23': ["13:00", "14:15"],
    '24': ["14:30", "15:45"],
    '25': ["16:00", "17:15"],
  };
}

class ReservationView extends StatefulWidget {
  @override
  _ReservationViewState createState() => _ReservationViewState();
}

class _ReservationViewState extends State<ReservationView> {
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  TextEditingController startControl = TextEditingController();
  TextEditingController endControl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    thisContext = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('예약'),
      ),

      /*** timetable ***/
      body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: WeeklyTimeTable(
                locale: 'ko',

              ),
                flex: 2
              ),
              Expanded(child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom:40.0, top:10.0),
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: RaisedButton(
                              child: Text("Select Time",style: new TextStyle(fontSize: 20),),
                              onPressed:(){
                                DateTimeRangePicker(
                                    startText: "From",
                                    endText: "To",
                                    doneText: "Yes",
                                    cancelText: "Cancel",
                                    interval: 5,
                                    // 지금 시간에서 1시간 이후부터 예약가능
                                    initialStartTime: DateTime.now().add(Duration(hours: 1)),
                                    // 끝나는 시각은 2시간 이후
                                    initialEndTime: DateTime.now().add(Duration(hours: 2)),
                                    mode: DateTimeRangePickerMode.dateAndTime,
                                    minimumTime: DateTime.now().subtract(Duration(days: 5)),
                                    maximumTime: DateTime.now().add(Duration(days: 25)),
                                    use24hFormat: true,
                                    onConfirm: (start, end) {
                                      setState(() {
                                        startTime = start;
                                        endTime = end;
                                      });
                                    }).showPicker(context);
                              },
                          ),
                        ),
                        Text( // 시작 시간 표시 (처음 실행때는 현재시각)
                            'Start Time : '+startTime.hour.toString()+":"+startTime.minute.toString(),
                            style: TextStyle(fontSize: 20.0)
                        ),
                        Text( // 종료 시간 표시 (처음 실행때는 현재시각)
                            'end Time : '+endTime.hour.toString()+":"+endTime.minute.toString(),
                            style: TextStyle(fontSize: 20.0))
                      ],
                    ),
                  ),

                  RaisedButton( // 예약
                      child: Text("Reserve",style: new TextStyle(fontSize: 20)),
                      onPressed: (){
                          showAlertDialog(context);
                      })
                ]),
              ),
              /***  ***/
            ],

          )
      ),


      floatingActionButton: Stack(
        children: <Widget>[

          /*** This will be removed (TEST) ***/
          Padding(padding: EdgeInsets.only(),
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
  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        // 이전 화면으로
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {
        // 예약

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(""),
      // 강의실 받아온거 추가해야함
      content: Text(startTime.hour.toString()+":"+startTime.minute.toString()+" ~ "+
          endTime.hour.toString()+":"+endTime.minute.toString()+"\nwould you like to continue?", textAlign: TextAlign.center),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
import 'dart:convert';
import 'package:gcrs/views/homeView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcrs/Widget/timetable.dart';
import 'package:gcrs/utils/GlobalVariables.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';

var thisContext;

// https://gcse.doky.space/api/schedule?bd=IT대학&crn=304
// TODO: make class to save lecture

class Lecture {
  final String date; // 요일
  final String time; // 시간 -> 밑에 MAP 으로 시간 알아봅시다

  Lecture({
    this.date = "",
    this.time = "",
  });

  factory Lecture.fromJson(dynamic json) {
    return Lecture(
        date: json["dotw"] as String,
        time: json["name"] as String);
  }

  @override
  String toString() {
    return '{Lecture{date: $date}, Lecture{time: $time}}';
  }

  timeCalculator(String time) { // dotw data 받아와서 시간 형식을 저장(start hour/minute, end hour/minute)
    // split nth 교시 to hour and minute
    int startHour = int.parse(convertToActualTime[time]![0].substring(0, 2));
    int startMinute = int.parse(convertToActualTime[time]![0].substring(3, 4));
    int endHour = int.parse(convertToActualTime[time]![1].substring(0, 2));
    int endMinute = int.parse(convertToActualTime[time]![1].substring(3, 4));
    int height = 60;

    List<int> hourSplit = [];
    hourSplit.add(startHour);
    hourSplit.add(startMinute);
    hourSplit.add(endHour);
    hourSplit.add(endMinute);

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
  var data;
  List<Lecture> lecture = [];
  // 임의 값
  String userid = "aaaa";
  String bd = "IT대학";
  String crn = "304";


  Future<String> getData() async {
    http.Response res = await http.get(Uri.parse(
        "https://gcse.doky.space/api/schedule?bd=" + bd + "&crn=" + crn));
    this.setState(() {
      data = jsonDecode(res.body)["result"];
      data.forEach((element) {
        lecture.add(Lecture.fromJson(element));
      });
    });

    return "success";
  }

  @override
  void initState() {
    super.initState();
    // this.getData(); // 데이터 받아오기

    //임의로 데이터 넣어줌
    lecture.add(Lecture(date: "1", time: "1"));
    lecture.add(Lecture(date: "3", time: "21"));
  }

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
          Expanded(
              child: WeeklyTimeTable(
                locale: 'ko',
              ),
              flex: 2),
          Expanded(
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 40.0, top: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: ElevatedButton(
                            child: Text(
                              "Select Time",
                              style: new TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              DateTimeRangePicker(
                                  startText: "From",
                                  endText: "To",
                                  doneText: "Yes",
                                  cancelText: "Cancel",
                                  interval: 5,
                                  // 지금 시간에서 1시간 이후부터 예약가능
                                  initialStartTime:
                                      DateTime.now().add(Duration(hours: 1)),
                                  // 끝나는 시각은 2시간 이후
                                  initialEndTime:
                                      DateTime.now().add(Duration(hours: 2)),
                                  mode: DateTimeRangePickerMode.dateAndTime,
                                  minimumTime: DateTime.now()
                                      .subtract(Duration(days: 5)),
                                  maximumTime:
                                      DateTime.now().add(Duration(days: 25)),
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
                        Text(
                            // 시작 시간 표시 (처음 실행때는 현재시각)
                            'Start Time : ' +
                                startTime.hour.toString() +
                                ":" +
                                startTime.minute.toString(),
                            style: TextStyle(fontSize: 20.0)),
                        Text(
                            // 종료 시간 표시 (처음 실행때는 현재시각)
                            'end Time : ' +
                                endTime.hour.toString() +
                                ":" +
                                endTime.minute.toString(),
                            style: TextStyle(fontSize: 20.0))
                      ],
                    ),
                  ),
                  ElevatedButton(
                      // 예약
                      child:
                          Text("Reserve", style: new TextStyle(fontSize: 20)),
                      onPressed: () {
                        showAlertDialog(context);
                      })
                ]),
          ),
          /***  ***/
        ],
      )),
      floatingActionButton: Stack(
        children: <Widget>[
          /*** This will be removed (TEST) ***/
          Padding(
            padding: EdgeInsets.only(),
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
            ),
          ),
        ],
      ),
    );
  }
  void _showDialog() { // 예약 불가
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Warning"),
          content: new Text("This time cannot be reserved"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }


  showAlertDialog(BuildContext context) { // reserve button
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      onPressed: () {
        // 이전 화면으로
        Navigator.pop(context);
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("Continue"),
      onPressed: () async {
        int day = startTime.weekday;
        int startH = startTime.hour;
        int startM = startTime.minute;
        int endH = endTime.hour;
        int endM = endTime.minute;
        for (Lecture lec in lecture) {
          if (day.toString() == lec.date) { // 선택한 요일에 강의가 있으면
            List<int> hourSplit = lec.timeCalculator(lec.time);

            if (startH >= hourSplit[0] &&
                startH <= hourSplit[2]) { // 시작 시간이 강의시간과 겹치면
              if (startH == hourSplit[0] && startM >= hourSplit[1]) {
                // 예약 불가
                _showDialog();
                return;
              }
              else if (startH == hourSplit[2] && startM <= hourSplit[3]) {
                // 예약 불가
                _showDialog();
                return;
              }
            }
            else if (endH >= hourSplit[0] &&
                endH <= hourSplit[2]) { // 끝나는 시간이 강의시간과 겹치면
              if (endH == hourSplit[0] && endM >= hourSplit[1]) {
                // 예약 불가
                _showDialog();
                return;
              }
              else if (endH == hourSplit[2] && endM <= hourSplit[3]) {
                // 예약 불가
                _showDialog();
                return;
              }
            }
          }
        }
        http.Response res = await http.post(Uri.parse( // reservation API
            "https://gcse.doky.space/api/reservation"),
            body: {"userid": userid,
              "start": startTime,
              "end": endTime,
              "bd": bd,
              "crn": crn,
              "fb_key": ""});

        var resJ = jsonDecode(res.body);

        if (resJ["success"] == true)  // 예약 성공
          Navigator.pushNamed(context, "/HomeView"); // homeView로
        else // 예약 실패
          _showDialog();

      }
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(""),
      content: Text(
          bd+" "+crn+
              "\n" +
              startTime.hour.toString() +
              ":" +
              startTime.minute.toString() +
              " ~ " +
              endTime.hour.toString() +
              ":" +
              endTime.minute.toString() +
              "\nwould you like to continue?",
          textAlign: TextAlign.center),
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

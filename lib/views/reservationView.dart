import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcrs/Widget/timetable.dart';
import 'package:gcrs/utils/GlobalVariables.dart';
import 'package:http/http.dart' as http;
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';

var thisContext;
int count = 0;

class Lecture {
  final String date; // 요일
  final String time; // 시간 -> 밑에 MAP 으로 시간 알아봅시다

  Lecture({
    this.date = "",
    this.time = "",
  });

  factory Lecture.fromJson(dynamic json) {
    return Lecture(
      date: json["dotw"].toString(),
      time: json["name"].toString(),
    );
  }

  @override
  String toString() {
    return '{Lecture{date: $date}, Lecture{time: $time}}';
  }

  // format = name:[start time, end time]
  static final Map<String, List<String>> convertToActualTime = {
    '1': ["09:00", "10:00"],
    '2': ["10:00", "11:00"],
    '3': ["11:00", "12:00"],
    '4': ["12:00", "13:00"],
    '5': ["13:00", "14:00"],
    '6': ["14:00", "15:00"],
    '7': ["15:00", "16:00"],
    '8': ["16:00", "17:00"],
    '9': ["17:30", "18:25"],
    '10': ["18:25", "19:20"],
    '11': ["19:20", "20:15"],
    '12': ["20:15", "21:10"],
    '13': ["21:10", "22:05"],
    '14': ["22:05", "23:00"],

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
  String bd = "IT대학";
  String crn = "304";

  Future<String> getData() async {
    http.Response res = await http.get(Uri.parse(
        "https://gcse.doky.space/api/schedule?bd=" + bd + "&crn=" + crn));
    this.setState(() {
      data = jsonDecode(res.body)["result"];
      data.forEach((element) {
        count++;
        lecture.add(Lecture.fromJson(element));
      });
    });

    return "success";
  }

  @override
  void initState() {
    super.initState();
    this.getData();
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
              lec: lecture,
            ),
            flex: 2,
          ),
          ElevatedButton(
            onPressed: () {
              lecture.add(Lecture(date: "1", time: "1"));
              setState(() {});
            },
            child: Text("Test to add lecture"),
          ),
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

  showAlertDialog(BuildContext context) {
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
      onPressed: () {
        // 예약
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(""),
      // 강의실 받아온거 추가해야함
      content: Text(
          count.toString() +
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

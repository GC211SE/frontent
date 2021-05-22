import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gcrs/Widget/timetable.dart';
import 'package:gcrs/utils/GlobalVariables.dart';
import 'package:gcrs/utils/SharedPreferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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

  timeCalculator(String time) {
    // dotw data 받아와서 시간 형식을 저장(start hour/minute, end hour/minute)
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
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now().add(Duration(minutes: 30));

  DateTime startTimeSend = DateTime.now();
  DateTime endTimeSend = DateTime.now();
  var data;
  List<Lecture> lecture = [];

  PreferencesManager pref = PreferencesManager.instance;
  DateFormat formatter = DateFormat("M월 d일  H:mm");
  DateFormat formatterHour = DateFormat("H:mm");
  DateFormat formatterHttp = DateFormat("yyyy-MM-dd H:mm");

  int targetReserved = -1;

  Future<String> getData() async {
    http.Response res = await http.get(Uri.parse(
        "https://gcse.doky.space/api/schedule?bd=${GlobalVariables.recentBuilding}&crn=${GlobalVariables.recentClassroom}"));
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
    this.getData();
  }

  TextEditingController startControl = TextEditingController();
  TextEditingController endControl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    thisContext = context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        elevation: 0,
        toolbarHeight: 90,
        centerTitle: true,
        leading: CupertinoButton(
          child: Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "예약하기",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      /*** timetable ***/
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Expanded(
                    child: WeeklyTimeTable(
                      startTime: startTimeSend,
                      endTime: startTimeSend,
                      locale: 'ko',
                      lec: lecture,
                    ),
                  ),
                  Divider(
                    thickness: 1.2,
                    height: 1.2,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 35,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 27,
                            child: Text(
                              "시작시간",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 53,
                            child: Text(
                              formatter.format(startTime),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.blue.shade900,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 20,
                            child: CupertinoButton(
                              color: Colors.blue.shade900,
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                DatePicker.showDateTimePicker(
                                  context,
                                  locale: LocaleType.ko,
                                  minTime: DateTime.now(),
                                  currentTime: startTime,
                                  maxTime:
                                      DateTime.now().add(Duration(days: 7)),
                                  onConfirm: (dateTime) async {
                                    startTime = dateTime;
                                    endTime =
                                        dateTime.add(Duration(minutes: 30));

                                    var resNum = await http.get(Uri.parse(
                                        "https://gcse.doky.space/api/reservation/targettotal?bd=${GlobalVariables.recentBuilding}&crn=${GlobalVariables.recentClassroom}&time=${formatterHttp.format(startTime)}"));

                                    print(resNum.body);

                                    var resNumber =
                                        jsonDecode(resNum.body)['success'];

                                    targetReserved = resNumber['reserved'];

                                    setState(() {});
                                  },
                                );
                              },
                              child: Text("선택"),
                            ),
                          ),
                        ],
                      ),
                    ),

                    ///
                    ///
                    SizedBox(height: 15),
                    Divider(height: 1, thickness: 1),
                    SizedBox(height: 15),

                    ///
                    ///
                    Container(
                      height: 35,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 27,
                            child: Text(
                              "종료시간",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 53,
                            child: Text(
                              formatter.format(endTime),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.blue.shade900,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 20,
                            child: CupertinoButton(
                              color: Colors.blue.shade900,
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                DatePicker.showDateTimePicker(
                                  context,
                                  locale: LocaleType.ko,
                                  currentTime: endTime,
                                  minTime: startTime.add(Duration(minutes: 30)),
                                  maxTime:
                                      DateTime.now().add(Duration(days: 7)),
                                  onConfirm: (dateTime) async {
                                    endTime = dateTime;
                                    int startDay = startTime.weekday;
                                    int endDay = endTime.weekday;
                                    int startH = startTime.hour;
                                    int startM = startTime.minute;
                                    int endH = endTime.hour;
                                    int endM = endTime.minute;

                                    if (startDay != endDay) {
                                      // 이틀 이상 예약 불가
                                      _showDialog();
                                      return;
                                    }

                                    for (Lecture lec in lecture) {
                                      if (startDay.toString() == lec.date) {
                                        // 선택한 요일에 강의가 있으면
                                        List<int> hourSplit = lec.timeCalculator(lec.time);

                                        if (startH >= hourSplit[0] && startH <= hourSplit[2]) {
                                          // 시작 시간이 강의시간과 겹치면
                                          if (startH == hourSplit[0] && startM >= hourSplit[1]) {
                                            // 예약 불가
                                            _showDialog();
                                            return;
                                          } else if (startH == hourSplit[2] && startM <= hourSplit[3]) {
                                            // 예약 불가
                                            _showDialog();
                                            return;
                                          }
                                        } else if (endH >= hourSplit[0] && endH <= hourSplit[2]) {
                                          // 끝나는 시간이 강의시간과 겹치면
                                          if (endH == hourSplit[0] && endM >= hourSplit[1]) {
                                            // 예약 불가
                                            _showDialog();
                                            return;
                                          } else if (endH == hourSplit[2] && endM <= hourSplit[3]) {
                                            // 예약 불가
                                            _showDialog();
                                            return;
                                          }
                                        } else if (startH <= hourSplit[0] && // 예약시간 안에 강의가 있으면
                                            endH >= hourSplit[2]) {
                                          if (startM <= hourSplit[1] && endM >= hourSplit[3]) {
                                            // 예약 불가
                                            _showDialog();
                                            return;
                                          }
                                        }
                                      }
                                    }
                                    setState(() {
                                      startTimeSend = startTime;
                                      endTimeSend = endTime;
                                    });
                                  },
                                );
                              },
                              child: Text("선택"),
                            ),
                          ),
                        ],
                      ),
                    ),

                    ///
                    ///
                    SizedBox(height: 5),

                    ///
                    ///
                    targetReserved != -1
                        ? Container(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 27,
                                  child: Text(
                                    "해당 시간 $targetReserved명 예약",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(
                            height: 30,
                          ),

                    ///
                    ///
                    SizedBox(height: 10),

                    ///
                    ///

                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: CupertinoButton(
                              color: Colors.blue.shade900,
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                showAlertDialog(context);
                              },
                              child: Text("예약하기"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Container(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 15),
            Text(
              "${GlobalVariables.recentBuilding}-${GlobalVariables.recentClassroom}",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 3),
            Text(
              "${formatter.format(startTime)} ~ ${formatterHour.format(endTime)}",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "예약하시겠습니까?",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "* 예약시간 10분 후 미입실시 예약이 취소됩니다.",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.red.shade300,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: CupertinoButton(
                color: Colors.blue.shade800,
                padding: EdgeInsets.all(0),
                child: Text("네"),
                onPressed: () async {
                  bool result = await doReservation(
                    userid: pref.userId,
                    building: GlobalVariables.recentBuilding,
                    classroom: GlobalVariables.recentClassroom,
                    start: startTime,
                    end: endTime,
                  );

                  if (!result) return;
                  Navigator.pop(context);
                  await Future.delayed(Duration(milliseconds: 500));
                  Navigator.popAndPushNamed(context, "/HomeView");
                },
              ),
            ),
            SizedBox(width: 3),
            Expanded(
              child: CupertinoButton(
                color: Colors.grey.shade400,
                padding: EdgeInsets.all(0),
                child: Text("취소"),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
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

  Future<bool> doReservation({
    required String userid,
    required DateTime start,
    required DateTime end,
    required String building,
    required String classroom,
  }) async {
    String? appToken;
    try {
      appToken = await FirebaseMessaging.instance.getToken();
    } catch (err) {
      appToken = "-";
    }
    print(appToken);

    http.Response res = await http
        .post(Uri.parse("https://gcse.doky.space/api/reservation"), body: {
      "userid": userid,
      "start": start.toString().split(".")[0],
      "end": end.toString().split(".")[0],
      "bd": building,
      "crn": classroom,
      "fb_key": appToken,
    });
    var data = jsonDecode(res.body);
    print(res.body);

    if (res.statusCode != 200) return false;

    print(data['success']);
    return true;
  }

  void _showDialog() {
    // 예약 불가
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
}

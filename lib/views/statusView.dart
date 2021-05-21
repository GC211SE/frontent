import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcrs/utils/SharedPreferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class StatusView extends StatefulWidget {
  @override
  _StatusViewState createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  double percent = 0.0;
  String remainTime = "00:00";
  String classroom = "Loading..";
  String time = "";
  late DateTime endTime;
  late DateTime startTime;
  Color circleIndicatorColor = Colors.blue.shade800;
  PreferencesManager pref = PreferencesManager.instance;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        elevation: 0,
        toolbarHeight: 120,
        centerTitle: true,
        leading: CupertinoButton(
          child: Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "예약 현황",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: SizedBox()),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 250,
                        height: 250,
                        child: CircularProgressIndicator(
                          value: percent,
                          strokeWidth: 30,
                          backgroundColor: Color.fromRGBO(235, 235, 235, 1),
                          color: circleIndicatorColor,
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(height: 15),
                          Text(
                            "남은시간",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            remainTime,
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        Text(
                          classroom,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 60,
                              child: CupertinoButton(
                                borderRadius: BorderRadius.circular(13),
                                padding: EdgeInsets.all(0),
                                color: Colors.blue.shade900,
                                child: Text("퇴실하기"),
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Column(
                                      children: <Widget>[
                                        new Text("정말 퇴실하시겠습니까?"),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: CupertinoButton(
                                              color: Colors.blue.shade900,
                                              padding: EdgeInsets.all(0),
                                              child: Text("퇴실"),
                                              onPressed: () async {
                                                ///

                                                http.Response res =
                                                    await http.patch(
                                                  Uri.parse(
                                                      "https://gcse.doky.space/api/reservation/checkout"),
                                                  body: {
                                                    "userid": pref.userId,
                                                  },
                                                );

                                                // Fail
                                                if (res.statusCode != 200)
                                                  return;

                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                  context,
                                                  "/HomeView",
                                                  (route) => false,
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 3),
                                          Expanded(
                                            child: CupertinoButton(
                                              color: Colors.yellow.shade800,
                                              padding: EdgeInsets.all(0),
                                              child: Text("취소"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getData() async {
    http.Response res = await http.get(Uri.parse(
        "https://gcse.doky.space/api/reservation/current?userid=${pref.userId}"));

    var rawData = jsonDecode(res.body);

    if (rawData['success'].length == 0) return;
    var data = rawData['success'];

    print(data);

    DateFormat formatterTime = DateFormat("H:mm");
    // formatter.format(DateTime.parse(i['end'])),

    // {
    //    idx: 89, userid: uhug, start: 2021-05-30T16:30:00.000Z,
    //    end: 2021-05-30T19:50:00.000Z,
    //     building: IT대학, classroom: 304, enable: 1
    // }

    // double percent = 0.2;
    // String remainTime = "15:23";
    classroom = "${data['building']} - ${data['classroom']}";
    startTime = DateTime.parse(data['start']);
    endTime = DateTime.parse(data['end']);

    time =
        "${formatterTime.format(startTime)} ~ ${formatterTime.format(endTime)}";

    timer();
  }

  Future<void> timer() async {
    bool isTimerEnd = false;
    while (!isTimerEnd) {
      DateTime now = DateTime.now();

      // Change to GMT+9
      now = now.toUtc();
      now = now.add(Duration(hours: 9));

      Duration remain = endTime.difference(now);

      if (remain.compareTo(Duration(seconds: 0)) == -1) {
        isTimerEnd = true;
        remainTime = "00:00";
        percent = 1.0;
        circleIndicatorColor = Colors.blue.shade800;
        setState(() {});
        break;
      }

      // Label
      remainTime = timeFormatter(
        hour: remain.inHours,
        minute: remain.inMinutes - remain.inHours * 60,
        second: remain.inSeconds - remain.inMinutes * 60,
      );

      // ProgressIndicator
      Duration total = endTime.difference(startTime);
      int totalC = total.inSeconds;
      int remainC = remain.inSeconds;

      if (20 > remain.inMinutes && remain.inMinutes >= 10) {
        circleIndicatorColor = Colors.yellow.shade600;
      } else if (10 > remain.inMinutes) {
        circleIndicatorColor = Colors.red;
      } else {
        circleIndicatorColor = Colors.blue.shade800;
      }

      percent = 1 - (remainC / totalC);

      setState(() {});
      await Future.delayed(Duration(milliseconds: 1000));
    }
  }

  String timeFormatter({
    required int hour,
    required int minute,
    required int second,
  }) {
    String res = "";

    if (hour > 0) res += "$hour:";

    if (minute < 10)
      res += "0$minute:";
    else
      res += "$minute:";

    if (second < 10)
      res += "0$second";
    else
      res += "$second";

    return res;
  }
}

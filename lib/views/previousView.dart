import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcrs/utils/GlobalVariables.dart';
import 'package:gcrs/utils/SharedPreferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PreviousView extends StatefulWidget {
  @override
  _PreviousViewState createState() => _PreviousViewState();
}

class _PreviousViewState extends State<PreviousView> {
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
          "예약 기록",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: MediaQuery.of(context).size.width > GlobalVariables.mobileWidth
          ?
          // Desktop(Web) UI
          Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: SizedBox()),
                        Expanded(
                          flex: 2,
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            children: [
                              reservationList(),
                            ],
                          ),
                        ),
                        Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                ],
              ),
            )
          :
          // Mobile(App) UI
          // Implement design code here
          Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        reservationList(),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  // Reservation list
  Widget reservationList() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10),
          Builder(
            builder: (_) {
              List<Widget> result = [];

              for (var item in reservationWidgetDatas) {
                result.add(
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Container(
                          height: 110,
                          child: Card(
                            margin: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            elevation: 5,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 70,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            item.classroom,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            "${item.start} ~ ${item.end}",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 30,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Container(
                                            color: item.enable == 0
                                                ? Colors.blue.shade300
                                                : item.enable == 1
                                                    ? Colors.lightGreen
                                                    : Colors.grey.shade400,
                                            alignment: Alignment.center,
                                            height: 50,
                                            width: 50,
                                            padding: EdgeInsets.all(7),
                                            child: Text(
                                              item.enable == 0
                                                  ? "예약"
                                                  : item.enable == 1
                                                      ? "사용\n중"
                                                      : "사용\n완료",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                );
              }

              return Column(
                children: [...result],
              );
            },
          ),

          ///
          ///
          ///
        ],
      ),
    );
  }

  // Get total reservation data of user
  Future<void> getData() async {
    reservationWidgetDatas = [];

    PreferencesManager pref = PreferencesManager.instance;

    await pref.init();

    // Get user reservation
    http.Response res = await http.get(Uri.parse(
        "https://gcse.doky.space/api/reservation/personal?userid=${pref.userId}"));

    var data = jsonDecode(res.body)['success'];

    if (data == false) return;

    DateFormat formatter1 = DateFormat("M월 d일  |  H:mm");
    DateFormat formatter2 = DateFormat("H:mm");

    for (var i in data) {
      // var resNum = await http.get(Uri.parse(
      //     "https://gcse.doky.space/api/reservation/currtotal?bd=${i['building']}&crn=${i['classroom']}"));

      // var resNumber = jsonDecode(resNum.body)['success'];

      var item = ReservationWidgetData(
        idx: i['idx'],
        enable: i['enable'],
        start: formatter1.format(DateTime.parse(i['start'])),
        end: formatter2.format(DateTime.parse(i['end'])),
        classroom: i['building'] + "-" + i['classroom'],
        // reservedNum: resNumber['reserved'],
        // currentNum: resNumber['using'],
      );
      reservationWidgetDatas.add(item);
    }

    setState(() {});
  }

  List<ReservationWidgetData> reservationWidgetDatas = [];
}

// Class for structing user Reservation data to visualization
class ReservationWidgetData {
  final int idx;
  final String start;
  final String end;
  final String classroom;
  final int currentNum;
  final int reservedNum;
  final int enable;

  ReservationWidgetData({
    this.idx = -1,
    this.start = "",
    this.end = "",
    required this.classroom,
    this.currentNum = 0,
    this.reservedNum = 0,
    required this.enable,
  });
}

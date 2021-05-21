import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcrs/utils/GlobalVariables.dart';
import 'package:gcrs/utils/SharedPreferences.dart';
import 'package:gcrs/utils/noti.dart';
import 'package:gcrs/utils/notification.dart' as fcm;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late FirebaseNotification cloudMessaging;
  PreferencesManager pref = PreferencesManager.instance;

  @override
  void initState() {
    cloudMessaging = fcm.FirebaseCloudMessaging();
    getData();
    Future(cloudMessaging.init);
    super.initState();
  }

  bool isUsing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        elevation: 0,
        toolbarHeight: 30,
        backwardsCompatibility: false,
      ),
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      body: MediaQuery.of(context).size.width > GlobalVariables.mobileWidth
          ?
          // Desktop(Web) UI
          Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      user(),
                      Expanded(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 140,
                                height: 37,
                                child: reservationBtn(),
                              ),
                              SizedBox(width: 20),
                              setting(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: reservationList(),
                        ),
                        SizedBox(width: 40),
                        Container(
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(width: 40),
                        Expanded(
                          child: starredList(),
                        ),
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
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Row(
                            children: [
                              user(),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    setting(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Divider(),
                        SizedBox(height: 25),
                        reservationList(),
                        SizedBox(height: 50),
                        starredList(),
                      ],
                    ),
                  ),
                  Container(
                    height: 80,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  height: 50,
                                  child: reservationBtn(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  ///
  ///
  ///
  ///
  ///
  // User widget
  Widget user() {
    print(GlobalVariables.userImg);
    return Container(
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            child: Card(
              elevation: 2.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(37),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(37),
                child: Image.network(
                  GlobalVariables.userImg,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.data_usage_rounded,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            child: Text(
              "안녕하세요 ${GlobalVariables.userName}님",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reservation list
  Widget reservationList() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Text(
                      " 현재 예약 🕑",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 13),
          if (reservationWidgetDatas.length == 0)
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text("  예약 내역이 없습니다."),
            ),

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
                                    flex: 65,
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
                                            "${item.building} - ${item.classroom}",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          Text(
                                            "${item.start} ~ ${item.end}",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            "${item.reservedNum}명 예약   |   ${item.currentNum}명 사용중",
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 20,
                                    child: Container(
                                      height: 100,
                                      padding:
                                          EdgeInsets.fromLTRB(7, 7, 3.5, 7),
                                      child: CupertinoButton(
                                        color: item.enable == 0
                                            ? Colors.blue
                                            : Colors.blue.shade900,
                                        disabledColor: Colors.grey.shade300,
                                        padding: EdgeInsets.all(0),
                                        child: Text(
                                            item.enable == 0 ? "입장" : "보기"),
                                        onPressed: item.enable == 0 && isUsing
                                            ? null
                                            : item.enable == 0
                                                ? () {
                                                    // Check entrace time is smaller than current time + 10 minute
                                                    DateTime before =
                                                        DateTime.now()
                                                            .toUtc()
                                                            .add(Duration(
                                                                hours: 9,
                                                                minutes: 10));
                                                    // Check entrace time is bigger than current time - 10 minute
                                                    DateTime after =
                                                        DateTime.now()
                                                            .toUtc()
                                                            .add(Duration(
                                                                hours: 8,
                                                                minutes: 50));

                                                    if (before.isAfter(
                                                            item.startTime) &&
                                                        after.isBefore(
                                                            item.startTime)) {
                                                      GlobalVariables
                                                              .recentBuilding =
                                                          item.building;
                                                      GlobalVariables
                                                              .recentClassroom =
                                                          item.classroom;
                                                      GlobalVariables
                                                          .recentIdx = item.idx;

                                                      Navigator.pushNamed(
                                                              context,
                                                              "/Checkin")
                                                          .then((value) =>
                                                              setState(() {
                                                                getData();
                                                              }));
                                                    } else {
                                                      beforeCheckinAlert(
                                                          context);
                                                    }
                                                  }
                                                : () {
                                                    Navigator.pushNamed(
                                                            context, "/Status")
                                                        .then((value) =>
                                                            setState(() {
                                                              getData();
                                                            }));
                                                  },
                                      ),
                                    ),
                                  ),
                                  if (!isUsing)
                                    Expanded(
                                      flex: 15,
                                      child: Container(
                                        height: 100,
                                        padding:
                                            EdgeInsets.fromLTRB(3.5, 7, 7, 7),
                                        child: CupertinoButton(
                                          color: Colors.red.shade300,
                                          padding: EdgeInsets.all(0),
                                          child: Text("취소"),
                                          onPressed: () => {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Column(
                                                  children: <Widget>[
                                                    new Text("정말 취소하시겠습니까?"),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: CupertinoButton(
                                                          color: Colors
                                                              .red.shade300,
                                                          padding:
                                                              EdgeInsets.all(0),
                                                          child: Text("예약 취소"),
                                                          onPressed: () async {
                                                            ///

                                                            http.Response res =
                                                                await http
                                                                    .patch(
                                                              Uri.parse(
                                                                  "https://gcse.doky.space/api/reservation/cancel"),
                                                              body: {
                                                                "userid":
                                                                    pref.userId,
                                                                "idx": item.idx
                                                                    .toString(),
                                                              },
                                                            );

                                                            // Fail
                                                            if (res.statusCode !=
                                                                200) return;

                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(width: 3),
                                                      Expanded(
                                                        child: CupertinoButton(
                                                          color: Colors
                                                              .grey.shade400,
                                                          padding:
                                                              EdgeInsets.all(0),
                                                          child: Text("닫기"),
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ).then((value) => getData()),
                                          },
                                        ),
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

  // Setting button
  Widget setting() {
    return Container(
      width: 50,
      height: 50,
      child: Card(
        elevation: 2.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(37),
        ),
        child: CupertinoButton(
          padding: EdgeInsets.all(0),
          child: Icon(
            Icons.settings,
            color: Colors.grey.shade700,
            size: 20,
          ),
          onPressed: () => Navigator.pushNamed(context, "/SettingView")
              .then((value) => setState(() {
                    getData();
                  })),
        ),
      ),
    );
  }

  // Starred list
  Widget starredList() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Text(
                      " 즐겨찾기 ⭐️",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 13),
          if (starredWidgetDatas.length == 0)
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Text("  검색에서 즐겨찾기를 등록해보세요!"),
            )
          else
            Builder(
              builder: (_) {
                List<Widget> result = [];

                for (var item in starredWidgetDatas) {
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
                                              "${item.building} - ${item.classroom}",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "${item.reservedNum}명 예약   |   ${item.currentNum}명 사용중",
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 30,
                                      child: Container(
                                        height: 100,
                                        padding: EdgeInsets.all(7),
                                        child: CupertinoButton(
                                          color: Colors.lightGreen,
                                          padding: EdgeInsets.all(0),
                                          child: Text("예약"),
                                          onPressed: () {
                                            GlobalVariables.recentBuilding =
                                                item.building;
                                            GlobalVariables.recentClassroom =
                                                item.classroom;
                                            GlobalVariables.recentIdx = -1;

                                            Navigator.pushNamed(
                                                    context, "/ReservationView")
                                                .then((value) => setState(() {
                                                      getData();
                                                    }));
                                          },
                                        ),
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

  ///
  ///
  ///
  ///
  ///
  // Reservation button
  Widget reservationBtn() {
    return CupertinoButton(
      padding: EdgeInsets.all(0),
      color: Colors.blue.shade900,
      child: Text("강의실 예약하기"),
      onPressed: () =>
          Navigator.pushNamed(context, "/Search").then((value) => setState(() {
                getData();
              })),
    );
  }

  void beforeCheckinAlert(context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: <Widget>[
            new Text(
              "입실 기능시간이 아닙니다.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CupertinoButton(
                  color: Colors.blue.shade800,
                  padding: EdgeInsets.all(0),
                  child: Text("확인"),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  //
  //
  //
  //
  //
  //
  // Functions

  List<ReservationWidgetData> reservationWidgetDatas = [];
  List<ReservationWidgetData> starredWidgetDatas = [];

  Future<void> getData() async {
    reservationWidgetDatas = [];
    starredWidgetDatas = [];
    isUsing = false;

    await pref.init();

    // Get user reservation
    http.Response res = await http.get(Uri.parse(
        "https://gcse.doky.space/api/reservation/personal?userid=${pref.userId}"));

    var data = jsonDecode(res.body)['success'];

    if (data == false) return;

    DateFormat formatter1 = DateFormat("M월 d일  |  H:mm");
    DateFormat formatter2 = DateFormat("H:mm");

    for (var i in data) {
      if (i['enable'] == 1) {
        var resNum = await http.get(Uri.parse(
            "https://gcse.doky.space/api/reservation/currtotal?bd=${i['building']}&crn=${i['classroom']}"));

        var resNumber = jsonDecode(resNum.body)['success'];

        var item = ReservationWidgetData(
          idx: i['idx'],
          enable: 1,
          start: formatter1.format(DateTime.parse(i['start'])),
          end: formatter2.format(DateTime.parse(i['end'])),
          building: i['building'],
          classroom: i['classroom'],
          reservedNum: resNumber['reserved'],
          currentNum: resNumber['using'],
          startTime: DateTime.parse(i['start']),
        );
        reservationWidgetDatas.add(item);
      }
    }

    // If user using classroom disable buttons
    if (reservationWidgetDatas.length != 0)
      isUsing = true;
    else
      isUsing = false;

    for (var i in data) {
      if (i['enable'] == 0) {
        var resNum = await http.get(Uri.parse(
            "https://gcse.doky.space/api/reservation/currtotal?bd=${i['building']}&crn=${i['classroom']}"));

        var resNumber = jsonDecode(resNum.body)['success'];

        var item = ReservationWidgetData(
          idx: i['idx'],
          enable: 0,
          start: formatter1.format(DateTime.parse(i['start'])),
          end: formatter2.format(DateTime.parse(i['end'])),
          building: i['building'],
          classroom: i['classroom'],
          reservedNum: resNumber['reserved'],
          currentNum: resNumber['using'],
          startTime: DateTime.parse(i['start']),
        );
        reservationWidgetDatas.add(item);
      }
    }

    // Get user starred room status
    List<String> starred = pref.starredClassroom;

    String building;
    String classroom;

    for (String i in starred) {
      building = i.split("---")[0];
      classroom = i.split("---")[1];

      res = await http.get(Uri.parse(
          "https://gcse.doky.space/api/reservation/currtotal?bd=$building&crn=$classroom"));

      var resNumber = jsonDecode(res.body)['success'];

      var starred = ReservationWidgetData(
        enable: -1,
        building: building,
        classroom: classroom,
        reservedNum: resNumber['reserved'],
        currentNum: resNumber['using'],
        startTime: DateTime.now(), // Dummy
      );
      starredWidgetDatas.add(starred);
    }

    setState(() {});
  }

  //

}

class ReservationWidgetData {
  final int idx;
  final DateTime startTime;
  final String start;
  final String end;
  final String building;
  final String classroom;
  final int currentNum;
  final int reservedNum;
  final int enable;

  ReservationWidgetData({
    required this.startTime,
    this.idx = -1,
    this.start = "",
    this.end = "",
    required this.building,
    required this.classroom,
    this.currentNum = 0,
    this.reservedNum = 0,
    required this.enable,
  });
}

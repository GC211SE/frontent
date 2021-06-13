import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcrs/utils/GlobalVariables.dart';
import 'package:gcrs/utils/SharedPreferences.dart';
import 'package:http/http.dart' as http;

class CheckinView extends StatefulWidget {
  @override
  _CheckinViewState createState() => _CheckinViewState();
}

class _CheckinViewState extends State<CheckinView> {
  int stepCount = 1;
  int peopleCount = 0;
  PreferencesManager pref = PreferencesManager.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        elevation: 0,
      ),
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      body: controller(step: stepCount),
    );
  }

  // Change each dialog views
  Widget controller({required int step}) {
    switch (step) {
      case 1:
        return step1();
      case 2:
        return step2();
      case 3:
        return step3();
      case 4:
        return step4();
      case 5:
        return step5();
      default:
        return step1();
    }
  }

  // Step 1: 지금 강의실을 사용할 수 있나요?
  Widget step1() {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 5),
                Text(
                  "IT대학 - 304",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "지금 강의실을\n사용할 수 있나요?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                ///
                ///
                ///
                ///
                ///
                ///
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 60,
                            child: CupertinoButton(
                              borderRadius: BorderRadius.circular(13),
                              padding: EdgeInsets.all(0),
                              color: Colors.blue.shade900,
                              child: Text("네"),
                              onPressed: () {
                                stepCount = 3;
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 7),
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 60,
                            child: CupertinoButton(
                              borderRadius: BorderRadius.circular(13),
                              padding: EdgeInsets.all(0),
                              color: Colors.yellow.shade800,
                              child: Text("아니오"),
                              onPressed: () {
                                stepCount = 2;
                                setState(() {});
                              },
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
    );
  }

  // Step 2: (Step 1 -> false) 저런.. 혹시 이유가 무엇인가요?
  Widget step2() {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "저런..😥\n혹시 이유가 무엇인가요?",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                ///
                ///
                ///
                ///
                ///
                ///

                Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 60,
                                child: CupertinoButton(
                                  borderRadius: BorderRadius.circular(13),
                                  padding: EdgeInsets.all(0),
                                  color: Colors.blue.shade900,
                                  child: Text("강의중이에요.."),
                                  onPressed: () async {
                                    bool result =
                                        await dummyReservation(minutes: 30);
                                    if (!result) return;

                                    stepCount = 5;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 60,
                                child: CupertinoButton(
                                  borderRadius: BorderRadius.circular(13),
                                  padding: EdgeInsets.all(0),
                                  color: Colors.blue.shade900,
                                  child: Text("문이 잠겨있네요.."),
                                  onPressed: () async {
                                    bool result =
                                        await dummyReservation(minutes: 30);
                                    if (!result) return;

                                    stepCount = 5;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 60,
                                child: CupertinoButton(
                                  borderRadius: BorderRadius.circular(13),
                                  padding: EdgeInsets.all(0),
                                  color: Colors.blue.shade900,
                                  child: Text("기타"),
                                  onPressed: () async {
                                    bool result =
                                        await dummyReservation(minutes: 30);
                                    if (!result) return;

                                    stepCount = 5;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ],
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
    );
  }

  // Step 3: (Step 1 -> true) 강의실에 사람이 몇 명 있는지 알려주세요
  Widget step3() {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 10),
                Text(
                  "좋아요!\n\n건전한 예약 문화를 위해\n강의실에 사람이 \n몇 명 있는지 알려주세요!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$peopleCount",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      " 명",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      child: CupertinoButton(
                        borderRadius: BorderRadius.circular(13),
                        padding: EdgeInsets.all(0),
                        color: Colors.blue.shade900,
                        child: Text(
                          "+",
                          style: TextStyle(fontSize: 50),
                        ),
                        onPressed: () {
                          peopleCount++;
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 70,
                      height: 70,
                      child: CupertinoButton(
                        borderRadius: BorderRadius.circular(13),
                        padding: EdgeInsets.all(0),
                        color: Colors.yellow.shade800,
                        child: Text(
                          "-",
                          style: TextStyle(fontSize: 50),
                        ),
                        onPressed: () {
                          if (peopleCount > 0) peopleCount--;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),

                ///
                ///
                ///
                ///
                ///

                Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 60,
                            child: CupertinoButton(
                              borderRadius: BorderRadius.circular(13),
                              padding: EdgeInsets.all(0),
                              color: Colors.blue.shade900,
                              child: Text("확인"),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Column(
                                      children: <Widget>[
                                        new Text("정말 $peopleCount명이 맞나요?"),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: CupertinoButton(
                                              color: Colors.red.shade300,
                                              padding: EdgeInsets.all(0),
                                              child: Text("네"),
                                              onPressed: () async {
                                                bool result =
                                                    await checkPeopleAndAdd(
                                                        number: peopleCount);

                                                if (!result) return;

                                                Navigator.pop(context);

                                                stepCount = 4;
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 3),
                                          Expanded(
                                            flex: 2,
                                            child: CupertinoButton(
                                              color: Colors.grey.shade400,
                                              padding: EdgeInsets.all(0),
                                              child: Text("수정할게요"),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
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
    );
  }

  // Step 4: Check in
  Widget step4() {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "🎉 \n\n 체크인을 위한 준비가 끝났습니다!\n\n확인 버튼을 누르면 체크인과\n동시에 사용이 시작됩니다.\n\n\n이제 강의실 사용을 시작하죠!!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 60,
                                child: CupertinoButton(
                                  borderRadius: BorderRadius.circular(13),
                                  padding: EdgeInsets.all(0),
                                  color: Colors.blue.shade900,
                                  child: Text("시작하기"),
                                  onPressed: () async {
                                    bool result = await doCheckin();

                                    if (result)
                                      Navigator.popAndPushNamed(
                                        context,
                                        "/Status",
                                      );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Step 5: (Step2 -> Step5) 다른 강의실을 찾아보도록 하죠
  Widget step5() {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 4),
                Text(
                  "😭\n\n안타깝지만..\n다른 강의실을 찾아보도록 하죠",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 60,
                            child: CupertinoButton(
                              borderRadius: BorderRadius.circular(13),
                              padding: EdgeInsets.all(0),
                              color: Colors.yellow.shade800,
                              child: Text("확인"),
                              onPressed: () => Navigator.popAndPushNamed(
                                context,
                                "/HomeView",
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
    );
  }

  // Checking people and if real person number > server person number
  //  : Add reservation of anonymous person
  Future<bool> checkPeopleAndAdd({required int number}) async {
    http.Response res = await http.get(
      Uri.parse(
          "https://gcse.doky.space/api/reservation/currtotal?bd=IT대학&crn=304"),
    );

    var resJson = jsonDecode(res.body)['success'];
    int currNum = 0;

    if (resJson['using'] != null) currNum = resJson['using'];

    print(number - currNum);
    bool isOk = true;

    if (number - currNum <= 0) {
      return true;
    } else {
      for (int i = 0; i < number - currNum; i++) {
        isOk = await dummyReservation(minutes: 30);
        if (!isOk) break;
      }
    }
    return isOk;
  }

  // Checkin code for communicate server
  Future<bool> doCheckin() async {
    http.Response res = await http.patch(
      Uri.parse("https://gcse.doky.space/api/reservation/checkin"),
      body: {
        "idx": GlobalVariables.recentIdx.toString(),
        "userid": pref.userId,
      },
    );

    if (res.statusCode != 200) return false;
    return true;
  }

  // Add reservation of anonymous person
  Future<bool> dummyReservation({required int minutes}) async {
    DateTime now = DateTime.now();
    now = now.toUtc();
    now = now.add(Duration(hours: 9));

    DateTime end = now.add(Duration(minutes: minutes));

    http.Response res = await http
        .post(Uri.parse("https://gcse.doky.space/api/reservation"), body: {
      "userid": "dummyUser-GCSE",
      "start": now.toString().split(".")[0],
      "end": end.toString().split(".")[0],
      "bd": "IT대학",
      "crn": "304",
      "fb_key": "-",
      "enable": "1"
    });
    var data = jsonDecode(res.body);
    print(res.body);

    if (res.statusCode != 200) return false;

    print(data['success']);
    return true;
  }
}

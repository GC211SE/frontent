import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckinView extends StatefulWidget {
  @override
  _CheckinViewState createState() => _CheckinViewState();
}

class _CheckinViewState extends State<CheckinView> {
  int stepCount = 1;
  int peopleCount = 0;

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
                SizedBox(height: MediaQuery.of(context).size.height / 4),
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
                SizedBox(height: MediaQuery.of(context).size.height / 4),

                Expanded(
                  child: Text(
                    "저런..😥\n혹시 이유가 무엇인가요?",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
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
                                  onPressed: () {
                                    ///
                                    ///
                                    ///
                                    ///
                                    /// TODO 빈 강의실 처리

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
                                  onPressed: () {
                                    ///
                                    ///
                                    ///
                                    ///
                                    /// TODO 빈 강의실 처리

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
                                  onPressed: () {
                                    ///
                                    ///
                                    ///
                                    ///
                                    /// TODO 빈 강의실 처리

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
                                stepCount = 4;
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
                SizedBox(height: MediaQuery.of(context).size.height / 4),
                Text(
                  "🎉 \n\n 체크인 성공했습니다!\n이제 강의실 사용을 시작하죠!!",
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
                              color: Colors.blue.shade900,
                              child: Text("시작하기"),
                              onPressed: () =>
                                  Navigator.pushNamedAndRemoveUntil(
                                context,
                                "/Status",
                                (route) => false,
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
                              onPressed: () => {},
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
}

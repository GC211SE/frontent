import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckinView extends StatefulWidget {
  @override
  _CheckinViewState createState() => _CheckinViewState();
}

class _CheckinViewState extends State<CheckinView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        elevation: 0,
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
                  SizedBox(height: MediaQuery.of(context).size.height / 15),
                  Text(
                    "IT대학 - 304",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "지금 강의실을 사용할 수 있나요?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "저런..😥 혹시 이유가 무엇인가요?",
                    style: TextStyle(
                      fontSize: 20,
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
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 60,
                              child: CupertinoButton(
                                borderRadius: BorderRadius.circular(13),
                                padding: EdgeInsets.all(0),
                                color: Colors.blue.shade900,
                                child: Text("강의가 있어요.."),
                                onPressed: () => {},
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 60,
                              child: CupertinoButton(
                                borderRadius: BorderRadius.circular(13),
                                padding: EdgeInsets.all(0),
                                color: Colors.blue.shade900,
                                child: Text("문이 잠겨있네요.."),
                                onPressed: () => {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Text(
                    "좋아요! 건전한 예약 문화를 위해 강의실에 사람이 몇명 있는지 알려주세요!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "0",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        "명",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      CupertinoButton(
                        borderRadius: BorderRadius.circular(13),
                        padding: EdgeInsets.all(0),
                        color: Colors.blue.shade900,
                        child: Text("+"),
                        onPressed: () => {},
                      ),
                      CupertinoButton(
                        borderRadius: BorderRadius.circular(13),
                        padding: EdgeInsets.all(0),
                        color: Colors.blue.shade900,
                        child: Text("-"),
                        onPressed: () => {},
                      ),
                    ],
                  ),

                  Text(
                    "좋아요! 이제 강의실 사용을 시작하죠!!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
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
                                onPressed: () => {},
                              ),
                            ),
                          ),
                        ],
                      ),
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
                                onPressed: () => {},
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 60,
                              child: CupertinoButton(
                                borderRadius: BorderRadius.circular(13),
                                padding: EdgeInsets.all(0),
                                color: Colors.yellow.shade800,
                                child: Text("아니오"),
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
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatusView extends StatefulWidget {
  @override
  _StatusViewState createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  double percent = 0.2;
  String remainTime = "15:23";
  String classroom = "IT대학 - 304";
  String time = "9:00 ~ 9:50";

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
                  SizedBox(height: MediaQuery.of(context).size.height / 10),
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
                          color: Colors.blue.shade800,
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
                  SizedBox(height: 50),
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
                                      CupertinoButton(
                                        color: Colors.blue.shade900,
                                        child: Text("퇴실"),
                                        onPressed: () {
                                          ///
                                          ///
                                          ///
                                          ///
                                          /// 퇴실처리

                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            "/HomeView",
                                            (route) => false,
                                          );
                                        },
                                      ),
                                      CupertinoButton(
                                        color: Colors.yellow.shade800,
                                        child: Text("취소"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
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
}

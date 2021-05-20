import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatusView extends StatefulWidget {
  @override
  _StatusViewState createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
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
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 250,
                        height: 250,
                        child: CircularProgressIndicator(
                          value: 0.8,
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
                            "15:28",
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
                    "IT대학 - 304",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "9:10 ~ 10:00",
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

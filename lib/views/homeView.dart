import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcrs/utils/GlobalVariables.dart';
import 'package:gcrs/utils/noti.dart';
import 'package:gcrs/utils/notification.dart' as fcm;
import 'package:http/http.dart' as http;

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late FirebaseNotification cloudMessaging;

  @override
  void initState() {
    cloudMessaging = fcm.FirebaseCloudMessaging();

    Future(cloudMessaging.init);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        elevation: 0,
        toolbarHeight: 30,
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
                                width: 110,
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

  Future<void> sendRequest() async {
    String? appToken = await FirebaseMessaging.instance.getToken();
    print(appToken);
    await http.post(
      Uri.parse("https://gcse.doky.space/api/reservation/pushtest"),
      body: {"appToken": appToken},
    );
  }

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
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "IT대학-304",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                "9:00 ~ 10:00",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "0명 예약   |   0명 사용중",
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
                          child: Expanded(
                            child: CupertinoButton(
                              color: Colors.blue,
                              padding: EdgeInsets.all(0),
                              child: Text("입장"),
                              onPressed: () => print(""),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
          onPressed: () => Navigator.pushNamed(context, "/SettingView"),
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
          Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text("   검색에서 즐겨찾기를 등록해보세요!"),
          ),
        ],
      ),
    );
  }

  // Reservation button
  Widget reservationBtn() {
    return CupertinoButton(
      padding: EdgeInsets.all(0),
      color: Colors.blue.shade900,
      child: Text("예약하기"),
      onPressed: () => Navigator.pushNamed(context, "/Search"),
    );
  }
}

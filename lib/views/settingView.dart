import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcrs/utils/GlobalVariables.dart';
import 'package:gcrs/utils/SharedPreferences.dart';

class SettingView extends StatefulWidget {
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
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
          "설정",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      body: MediaQuery.of(context).size.width > GlobalVariables.mobileWidth
          ?
          // Desktop(Web) UI
          Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                children: [
                  Expanded(child: Container()),
                  Expanded(
                    flex: 2,
                    child: items(),
                  ),
                  Expanded(child: Container()),
                ],
              ),
            )
          :
          // Mobile(App) UI
          // Implement design code here
          Padding(
              padding: const EdgeInsets.all(30.0),
              child: items(),
            ),
    );
  }

  // Setting items
  Widget items() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 70,
                child: Card(
                  elevation: 3,
                  margin: EdgeInsets.all(0),
                  child: CupertinoButton(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Text(
                          "로그아웃",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => logout(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 70,
                child: Card(
                  elevation: 3,
                  margin: EdgeInsets.all(0),
                  child: CupertinoButton(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Text(
                          "즐겨찾기 초기화",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => initializeStarred(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 70,
                child: Card(
                  elevation: 3,
                  margin: EdgeInsets.all(0),
                  child: CupertinoButton(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Text(
                          "예약 기록",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => Navigator.pushNamed(context, "/Previous"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Do Logout and reset all saved data
  void logout() {
    var pref = PreferencesManager.instance;
    pref.userId = "";
    pref.userPassword = "";

    Navigator.pushNamedAndRemoveUntil(
      context,
      "/LoginView",
      (route) => false,
    );
  }

  // Erase all starred data from local device
  void initializeStarred() {
    var pref = PreferencesManager.instance;

    pref.starredClassroom = [];
  }
}

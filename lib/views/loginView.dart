import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcrs/utils/GlobalVariables.dart';
import 'package:gcrs/utils/SharedPreferences.dart';
import 'package:gcrs/views/homeView.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String userId = "";
  String userPw = "";

  bool isRunning = false;
  bool modalOpacity = false;
  bool isLoginFailed = false;

  bool isFirst = true;
  PreferencesManager pref = PreferencesManager.instance;

  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      doInitialLogin();
      isFirst = false;
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        if (MediaQuery.of(context).size.width >
                            GlobalVariables.mobileWidth)
                          Row(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 150,
                                    height: 150,
                                    child: Card(
                                      elevation: 7,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: Image(
                                          image:
                                              AssetImage("assets/img/logo.png"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "Gachon CRS\n",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 100),
                              Container(
                                width: 1,
                                height: 300,
                                color: Colors.grey.shade300,
                              ),
                              SizedBox(width: 100),
                            ],
                          ),
                        Container(
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "환영합니다",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "가천대학교 계정을 입력해주세요",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              SizedBox(height: 50),

                              // ID
                              TextFormField(
                                onChanged: (value) => userId = value,
                                onFieldSubmitted: (_) =>
                                    doLogin(id: userId, password: userPw),
                                decoration: InputDecoration(labelText: 'ID'),
                              ),

                              // Password
                              TextFormField(
                                onChanged: (value) => userPw = value,
                                obscureText: true,
                                onFieldSubmitted: (_) =>
                                    doLogin(id: userId, password: userPw),
                                decoration:
                                    InputDecoration(labelText: 'Password'),
                              ),
                              //Check if ID and Password is valid
                              Container(
                                alignment: Alignment.bottomCenter,
                                height: 30,
                                child: isLoginFailed
                                    ? Text(
                                        "아이디 또는 패스워드가 틀립니다.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      )
                                    : SizedBox(),
                              ),

                              if (MediaQuery.of(context).size.width >
                                  GlobalVariables.mobileWidth)
                                SizedBox(height: 15)
                              else
                                SizedBox(height: 100),

                              // Login Button
                              CupertinoButton(
                                color: Colors.blue.shade900,
                                child: Text(
                                  '로그인',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                onPressed: () =>
                                    doLogin(id: userId, password: userPw),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          //
          //
          //
          // ModalView
          if (isRunning)
            AnimatedOpacity(
              duration: Duration(milliseconds: 150),
              opacity: modalOpacity ? 1 : 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black.withAlpha(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 250,
                          height: 250,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                child: CircularProgressIndicator(
                                  strokeWidth: 10,
                                ),
                              ),
                              SizedBox(height: 35),
                              Text(
                                "로그인중..",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  //
  //
  //
  // Initialize all process
  Future<void> doInitialLogin() async {
    await pref.init();
    if (pref.userId.length != 0 && pref.userPassword.length != 0) {
      doLogin(id: pref.userId, password: pref.userPassword);
    }
  }

  //
  //
  //
  // Communicate server to check login
  Future<void> doLogin({required String id, required String password}) async {
    if (!isRunning) {
      isRunning = true;
      setState(() {});

      await Future.delayed(Duration(milliseconds: 0));
      modalOpacity = isRunning;
      setState(() {});
      //Parse login information from Gachon university login API
      http.Response res = await http.get(
        Uri.parse("https://gcse.doky.space/api/sign?id=$id&pw=$password"),
      );
      var resJ = jsonDecode(res.body);

      if (resJ["success"] == true) {
        isLoginFailed = false;
        // If success, get user information.
        GlobalVariables.userName = resJ["name"].toString();
        GlobalVariables.userDept = resJ["dept"].toString();
        GlobalVariables.userImg = resJ["photo"].toString();

        if (userId.length != 0) pref.userId = userId;
        if (userPw.length != 0) pref.userPassword = userPw;

        modalOpacity = false;
        setState(() {});
        await Future.delayed(Duration(milliseconds: 500));

        isRunning = false;
        setState(() {});

        Navigator.pushReplacementNamed(context, "/HomeView");
        return;
      } else {
        modalOpacity = false;
        setState(() {});
        await Future.delayed(Duration(milliseconds: 500));

        isRunning = false;
        setState(() {});

        isLoginFailed = true;
      }
    }
  }
}

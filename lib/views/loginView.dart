import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcrs/utils/GlobalVariables.dart';
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

  String userName = "";
  String userDept = "";
  String userPhoto = "";

  bool isRunning = false;
  bool modalOpacity = false;
  bool isLoginFailed = false;

  @override
  Widget build(BuildContext context) {
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

                              // 아이디
                              TextFormField(
                                onChanged: (value) => userId = value,
                                onFieldSubmitted: (_) => doLogin(),
                                decoration: InputDecoration(labelText: 'ID'),
                              ),

                              // 비밀번호
                              TextFormField(
                                onChanged: (value) => userPw = value,
                                obscureText: true,
                                onFieldSubmitted: (_) => doLogin(),
                                decoration:
                                    InputDecoration(labelText: 'Password'),
                              ),

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

                              // 로그인 버튼
                              CupertinoButton(
                                color: Colors.blue.shade900,
                                child: Text(
                                  '로그인',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                onPressed: () => doLogin(),
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
  Future<void> doLogin() async {
    if (!isRunning) {
      isRunning = true;
      setState(() {});

      await Future.delayed(Duration(milliseconds: 0));
      modalOpacity = isRunning;
      setState(() {});

      http.Response res = await http.get(
        Uri.parse("https://gcse.doky.space/api/sign?id=$userId&pw=$userPw"),
      );
      var resJ = jsonDecode(res.body);

      print(res);
      print(resJ);

      if (resJ["success"] == true) {
        isLoginFailed = false;
        // 성공 시, 정보를 받아옴
        GlobalVariables.userName = resJ["name"].toString();
        GlobalVariables.userDept = userDept = resJ["dept"];
        GlobalVariables.userImg = userPhoto = resJ["photo"];

        print(GlobalVariables.userImg);

        Navigator.pushReplacementNamed(context, "/HomeView");
      } else {
        isLoginFailed = true;
      }

      modalOpacity = false;
      setState(() {});
      await Future.delayed(Duration(milliseconds: 500));

      isRunning = false;
      setState(() {});
    }
  }
}

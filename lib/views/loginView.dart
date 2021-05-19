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
  final formKey = new GlobalKey<FormState>();
  String userId = "";
  String userPw = "";

  String userName = "";
  String userDept = "";
  String userPhoto = "";
  TextEditingController idControl = TextEditingController();
  TextEditingController pwControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('login demo'),
      ),
      body: new Container(
        padding: EdgeInsets.all(16),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new TextFormField(
                controller: idControl,
                decoration: new InputDecoration(labelText: 'ID'),
              ),
              new TextFormField(
                controller: pwControl,
                obscureText: true,
                decoration: new InputDecoration(labelText: 'Password'),
              ),
              new ElevatedButton(
                  child: new Text(
                    'Login',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () async {
                    userId = idControl.text;
                    userPw = pwControl.text;
                    http.Response res = await http.get(Uri.parse(
                        "https://gcse.doky.space/api/sign?id=$userId&pw=$userPw "));
                    var resJ = jsonDecode(res.body);

                    if (resJ["success"] == true) {
                      // 성공 시, 정보를 받아옴
                      userName = resJ["name"];
                      userDept = resJ["dept"];
                      userPhoto = resJ["photo"];
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeView()),
                      );
                    } else {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Column(
                            children: <Widget>[
                              new Text("로그인 실패"),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "아이디 또는 패스워드가 틀립니다.",
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            new ElevatedButton(
                              child: new Text("OK"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

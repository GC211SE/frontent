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

  /*void validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      print('Form is valid ID: $_id, password: $_password');
    } else {
      print('Form is invalid ID: $_id, password: $_password');
    }
  }*/

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
                validator: (value) =>
                    value.isEmpty ? 'ID can\'t be empty' : null,
                onSaved: (value) => userId = value,
              ),
              new TextFormField(
                controller: pwControl,
                obscureText: true,
                decoration: new InputDecoration(labelText: 'Password'),
                validator: (value) =>
                    value.isEmpty ? 'Password can\'t be empty' : null,
                onSaved: (value) => userPw = value,
              ),
              new RaisedButton(
                  child: new Text(
                    'Login',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () async {
                    userId = idControl.text;
                    userPw = pwControl.text;
                    http.Response res = await http.get(Uri.parse(
                        "https://gcse.doky.space/sign?id=$userId&pw=$userPw "));
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
                      print("fail");
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

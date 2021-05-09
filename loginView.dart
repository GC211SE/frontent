import 'package:flutter/material.dart';
import 'package:gcrs/utils/GlobalVariables.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final formKey = new GlobalKey<FormState>();
  String _id;
  String _password;
  void validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      print('Form is valid ID: $_id, password: $_password');
    } else {
      print('Form is invalid ID: $_id, password: $_password');
    }
  }

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
                decoration: new InputDecoration(labelText: 'ID'),
                validator: (value) =>
                    value.isEmpty ? 'ID can\'t be empty' : null,
                onSaved: (value) => _id = value,
              ),
              new TextFormField(
                obscureText: true,
                decoration: new InputDecoration(labelText: 'Password'),
                validator: (value) =>
                    value.isEmpty ? 'Password can\'t be empty' : null,
                onSaved: (value) => _password = value,
              ),
              new RaisedButton(
                child: new Text(
                  'Login',
                  style: new TextStyle(fontSize: 20.0),
                ),
                onPressed: validateAndSave,
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}

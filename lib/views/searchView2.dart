import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:gcrs/views/searchView.dart';
import 'package:gcrs/views/reservationView.dart';
import 'package:get/get.dart';

class SearchView2 extends StatefulWidget {
  @override
  _SearchViewState2 createState() => _SearchViewState2();
}

class _SearchViewState2 extends State<SearchView2> {
  String building = Get.arguments;
  List data = [];
  Future<String> getData() async {
    http.Response res = await http.get(Uri.parse(
        "https://gcse.doky.space/api/schedule/classrooms?bd=$building"));
    this.setState(() {
      data = jsonDecode(res.body)["result"];
    });

    return "success";
  }

  void _itemtapped() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReservationView()), //route here
    );
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('강의실 선택')),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            child: ListTile(onTap: _itemtapped, title: Text(data[index])),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:gcrs/views/searchView2.dart';
import 'package:get/get.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List data = [];

  Future<String> getData() async {
    http.Response res = await http
        .get(Uri.parse("https://gcse.doky.space/api/schedule/buildings"));
    this.setState(() {
      data = jsonDecode(res.body)["result"];
    });

    return "success";
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 200,
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "건물 선택하기",
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: new ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            child: ListTile(
                onTap: () {
                  Get.to(() => SearchView2(), arguments: data[index]);
                },
                title: Text(data[index])),
          );
        },
      ),
    );
  }
}

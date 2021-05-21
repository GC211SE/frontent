import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcrs/utils/GlobalVariables.dart';
import 'package:gcrs/utils/SharedPreferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class SearchView2 extends StatefulWidget {
  @override
  _SearchView2State createState() => _SearchView2State();
}

class _SearchView2State extends State<SearchView2> {
  List data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 200,
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        elevation: 0,
        centerTitle: true,
        leading: CupertinoButton(
          child: Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              "${GlobalVariables.building}",
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              "강의실 선택하기",
              style: TextStyle(
                fontSize: 17,
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      body: MediaQuery.of(context).size.width > GlobalVariables.mobileWidth
          ? Row(
              children: [
                Expanded(child: Container()),
                Expanded(flex: 2, child: lists()),
                Expanded(child: Container()),
              ],
            )
          : Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: lists(),
            ),
    );
  }

  Widget lists() {
    return FutureBuilder<List<String>>(
      future: getData(),
      builder: (_, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            snapshot.data == null) return Text('Loading');
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: snapshot.data!.length,
          itemBuilder: (BuildContext context, int index) {
            return buildRoomCard(snapshot.data![index]);
          },
        );
      },
    );
  }

  Widget buildRoomCard(String roomID) {
    PreferencesManager pref = PreferencesManager.instance;

    return FutureBuilder<Map<String, dynamic>>(
      future: getRoomData(roomID),
      builder: (_, snapshot) {
        String using = "-", reserved = "-";
        if (snapshot.connectionState == ConnectionState.done) {
          using = snapshot.data!["using"].toString();
          reserved = snapshot.data!["reserved"].toString();
        }
        return Card(
            child: ListTile(
          title: Row(
            children: [
              Expanded(child: Text('강의실 - $roomID')),
              Expanded(child: SizedBox()),
              CupertinoButton(
                padding: EdgeInsets.all(0),
                color: Colors.white,
                child: Icon(
                  Icons.star,
                  color: pref.starredClassroom.indexOf(
                              "${GlobalVariables.building}---$roomID") ==
                          -1
                      ? Colors.grey.shade200
                      : Colors.amber,
                ),
                onPressed: () {
                  List<String> starlist = pref.starredClassroom;
                  int index =
                      starlist.indexOf("${GlobalVariables.building}---$roomID");
                  if (index == -1) {
                    starlist.add("${GlobalVariables.building}---$roomID");
                    pref.starredClassroom = starlist;
                  } else {
                    starlist.remove("${GlobalVariables.building}---$roomID");
                    pref.starredClassroom = starlist;
                  }
                  setState(() {});
                },
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                      '사용 중 - $using명${MediaQuery.of(context).size.width > GlobalVariables.mobileWidth ? "  |  " : "\n"}예약 중 - $reserved명'),
                ),
              ),
            ],
          ),
          onTap: () {
            print(roomID);
            GlobalVariables.classroom = "";
            Navigator.pushNamed(
              context,
              "/ReservationView",
            );
          },
        ));
      },
    );
  }

  Future<List<String>> getData() async {
    http.Response res = await http.get(Uri.parse(
        "https://gcse.doky.space/api/schedule/classrooms?bd=${GlobalVariables.building}"));
    return (jsonDecode(res.body)["result"] as List)
        .map<String>((e) => e.toString())
        .toList();
  }

  Future<Map<String, dynamic>> getRoomData(String roomID) async {
    http.Response res2 = await http.get(Uri.parse(
        "https://gcse.doky.space/api/reservation/currtotal?bd=${GlobalVariables.building}&crn=$roomID"));
    return {
      'reserved': jsonDecode(res2.body)["success"]["reserved"],
      'using': jsonDecode(res2.body)["success"]["using"],
    };
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:gcrs/views/searchView.dart';
import 'package:gcrs/views/reservationView.dart';
import 'package:get/get.dart';

class SearchView2 extends StatelessWidget {
  String building = Get.arguments;
  List data = [];

  Future<List<String>> getData() async {
    http.Response res = await http.get(Uri.parse(
        "https://gcse.doky.space/api/schedule/classrooms?bd=$building"));
    return (jsonDecode(res.body)["result"] as List)
        .map<String>((e) => e.toString())
        .toList();
  }

  Future<Map<String, dynamic>> getRoomData(String roomID) async {
    http.Response res2 = await http.get(Uri.parse(
        "https://gcse.doky.space/api/reservation/currtotal?bd=$building&crn=$roomID"));
    return {
      'reserved': jsonDecode(res2.body)["success"]["reserved"],
      'using': jsonDecode(res2.body)["success"]["using"],
    };
  }

  Widget buildRoomCard(String roomID) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getRoomData(roomID),
      builder: (_, snapshot) {
        String using = "loading", reserved = "loading";
        if (snapshot.connectionState == ConnectionState.done) {
          using = snapshot.data!["using"].toString();
          reserved = snapshot.data!["reserved"].toString();
        }
        return Card(
            child: ListTile(
          title: Text('강의실 - $roomID    사용 중 - $using    예약 중 - $reserved'),
          onTap: () {
            data = [building, roomID];
            Get.to(() => ReservationView(), arguments: data);
          },
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('강의실 선택')),
      body: FutureBuilder<List<String>>(
          future: getData(),
          builder: (_, snapshot) {
            if (snapshot.connectionState != ConnectionState.done ||
                snapshot.data == null) return Text('Loading');
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return buildRoomCard(snapshot.data![index]);
              },
            );
          }),
    );
  }
}

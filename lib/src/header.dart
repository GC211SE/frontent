/* 상단 요일 바 of timetable */
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  Header(this.dates);

  final List<String> dates;

  // 상단 요일 바
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Card(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 2.0),
        child: Row(

            children: dates
                .map((day) => Expanded(child: Center(child: Text(day))))
                .toList()),
        elevation: 8.0,
      ),
    );
  }
}
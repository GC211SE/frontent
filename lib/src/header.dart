/* top day indicator of timetable */
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  Header(this.dates);

  final List<String> dates;

  // Date indicator for upper bar
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Row(
            children: dates
                .map((day) => Expanded(child: Center(child: Text(day))))
                .toList(),
          ),
        ),
        Divider(
          height: 1.2,
          thickness: 1.2,
        ),
      ],
    );
  }
}

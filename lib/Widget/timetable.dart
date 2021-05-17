import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gcrs/src/anHour.dart';
import 'package:gcrs/src/header.dart';
import 'package:gcrs/src/indicator.dart';
import 'package:gcrs/src/weekly_times.dart';
import 'package:http/http.dart' as http;

// https://gcse.doky.space/api/schedule?bd=IT대학&crn=304
// TODO: make class to save lecture
class Lecture {
  String date; // 요일
  String time; // 시간 -> 밑에 MAP으로 시간 알아봅시다

  // format = name:[start time, end time]
  static final Map<String, List<String>> numberTimes = {
    '1': ["9:00", "9:50"],
    '2': ["10:00", "10:50"],
    '3': ["11:00", "11:50"],
    '4': ["12:00", "12:50"],
    '5': ["13:00", "13:50"],
    '6': ["14:00", "14:50"],
    '7': ["15:00", "15:50"],
    '8': ["16:00", "16:50"],
    '9': ["17:30", "8:20"],
    '10': ["18:25", "19:15"],
    '11': ["19:20", "20:10"],
    '12': ["20:15", "21:05"],
    '13': ["21:10", "22:00"],
    '14': ["22:05", "22:55"],
  };
  static final Map<String, List<String>> charTimes = {
    '21': ["9:30", "10:45"],
    '22': ["11:00", "12:15"],
    '23': ["13:00", "14:15"],
    '24': ["14:30", "15:45"],
    '25': ["16:00", "17:15"],
    // ??
  };
}

class WeeklyTimeTable extends StatefulWidget {
  /*** variables ***/
  // color
  final Color cellColor;
  final Color cellSelectedColor;
  final Color boarderColor;

  // final ValueChanged<Map<int, List<int>>> onValueChanged;
  // final Map<int, List<int>> initialSchedule;
  final bool draggable;
  // use language
  final String locale;

  List<Lecture> lec; // TODO: 강의 받아와서 저장
  WeeklyTimeTable({
    /* set color */
    this.cellColor = Colors.white,
    this.cellSelectedColor = Colors.black,
    this.boarderColor = Colors.grey,

    // ??
    /*
    this.initialSchedule = const {
      0: [],
      1: [],
      2: [],
      3: [],
      4: [],
      5: [],
      6: [],
    },*/

    this.draggable = false,
    this.locale = "en",
    // this.onValueChanged,
  });

  @override
  // _WeeklyTimeTableState createState() => _WeeklyTimeTableState(this.initialSchedule);
  _WeeklyTimeTableState createState() => _WeeklyTimeTableState();
}

class _WeeklyTimeTableState extends State<WeeklyTimeTable> {
  List widgets = [];
  String locale = 'en';
  // Map<int, List<int>> selected;

  // _WeeklyTimeTableState(this.selected);
  _WeeklyTimeTableState();

  @override
  void initState() {
    if (WeeklyTimes.localContains(widget.locale)) {
      setState(() {
        locale = widget.locale;
      });
    }

    super.initState();
    loadData();
  }

  /* render timetable */
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        /* day bar (top) */
        Header(WeeklyTimes.dates[this.locale]),
        Expanded(
          child: ListView.builder(
            itemCount: WeeklyTimes.times[this.locale].length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              List<Widget> children = [];
              /* time bar (left) */
              children.add(Indicator(WeeklyTimes.times[this.locale][index]));
              children.addAll(
                List.generate(

                  WeeklyTimes.dates[this.locale].length - 1,
                      (i) => Cell(
                        day: i,
                        timeRange: index,
                        // isSelected: selected[i].contains(index),
                        // onCellTapped: onCellTapped,
                        cellColor: widget.cellColor,
                        cellSelectedColor: widget.cellSelectedColor,
                        boarderColor: widget.boarderColor,
                      ),
                ),
              );
              return Row(children: children);
            },
          ),
        ),
      ],
    );
  }

  loadData() async {
    Uri dataURL = Uri.parse("https://gcse.doky.space/api/schedule?bd=IT대학&crn=304");
    http.Response response = await http.get(dataURL);
    setState(() {
      // TODO: change 적용이 이안에 들어가야할 듯?
      // widgets = json.decode(response.body);
    });
  }

  /*
  onCellTapped(int day, int timeRange, bool nextSelectedState) {
    setState(() {
      if (!nextSelectedState) {
        selected[day].add(timeRange);
      } else {
        selected[day].remove(timeRange);
      }
    });
    widget.onValueChanged(selected);
  }
  */
}
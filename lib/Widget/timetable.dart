import 'package:flutter/material.dart';
import 'package:gcrs/src/anHour.dart';
import 'package:gcrs/src/header.dart';
import 'package:gcrs/src/indicator.dart';
import 'package:gcrs/src/weekly_times.dart';

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
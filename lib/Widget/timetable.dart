import 'package:flutter/material.dart';
import 'package:gcrs/src/anHour.dart';
import 'package:gcrs/src/header.dart';
import 'package:gcrs/src/indicator.dart';
import 'package:gcrs/src/weekly_times.dart';
import 'package:gcrs/views/reservationView.dart';

/* time table cell information (lecture, reservation) */
class RenderSpecificSave {
  // split to one cell
  final int date;
  final int hour;

  // time
  final int startMinute;
  final int endMinute;

  // type
  final int type; // 0: lecture, 1: reservation, 2: nothing

  RenderSpecificSave({
    required this.date,
    required this.hour,
    required this.startMinute,
    required this.endMinute,
    required this.type,
  });
}

class WeeklyTimeTable extends StatefulWidget {
  /* variables */
  // color
  final Color cellColor;
  final Color cellSelectedColor;
  final Color boarderColor;

  final bool draggable;
  // use language
  final String locale;

  // information
  final List<Lecture> lec;
  final DateTime startTime;
  final DateTime endTime;

  WeeklyTimeTable({
    /* set color */
    this.cellColor = Colors.white,
    this.cellSelectedColor = Colors.blue,
    this.boarderColor = Colors.grey,
    /* set variables */
    this.draggable = false,
    this.locale = "en",
    required this.lec,
    required this.startTime,
    required this.endTime,
  });

  @override
  _WeeklyTimeTableState createState() => _WeeklyTimeTableState();
}

// reservation page-> timetable widget
class _WeeklyTimeTableState extends State<WeeklyTimeTable> {
  List widgets = [];
  String locale = 'en';

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
        Header(WeeklyTimes.dates[this.locale]!), // 일, 월, 화, 수 ... 토
        Expanded(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: WeeklyTimes.times[this.locale]!.length,
            itemBuilder: (BuildContext context, int index) {
              List<Widget> children = [];
              /* time bar (left) */
              children.add(Indicator(WeeklyTimes.times[this.locale]![index]));

              // split lecture to cell
              List<RenderSpecificSave> RSS = lectureToSpecific(widget.lec);

              // add reservation
              List<RenderSpecificSave> sortedRss =
                  reservationToSpecific(widget.startTime, widget.endTime, RSS);

              // render time row by row
              for (int dateIdx = 0; dateIdx < 7; dateIdx++) {
                bool isLecture = false;
                List<int> RenderSpecificIdx =
                    []; // 한개의 cell 대신 그려야하는 class와 reservation의 모든것
                for (int RSSIdx = 0; RSSIdx < RSS.length; RSSIdx++) {
                  if (dateIdx == RSS[RSSIdx].date &&
                      index == RSS[RSSIdx].hour - 8) {
                    isLecture = true;
                    RenderSpecificIdx.add(RSSIdx);
                  }
                }

                if (isLecture == true) {
                  int renderedTime = 0;
                  List<Widget> lecturecell = [];


                  for (int count = 0; count < RenderSpecificIdx.length; count) {
                    /* 0: lecture, 1: reservation, 2: nothing? */
                    /* 0: orange, 1: blue, 2: teal */

                    // pass if start time of next schedule is bigger then rendered time
                    if (renderedTime > RSS[RenderSpecificIdx[count]].startMinute) {
                        count++;
                    } else if (renderedTime ==
                        RSS[RenderSpecificIdx[count]].startMinute) {
                      // if equal pass
                      lecturecell.add(LectureBox(
                          height: RSS[RenderSpecificIdx[count]]
                                  .endMinute
                                  .toDouble() -
                              RSS[RenderSpecificIdx[count]]
                                  .startMinute
                                  .toDouble(),
                          type: RSS[RenderSpecificIdx[count]].type));
                      renderedTime = RSS[RenderSpecificIdx[count]].endMinute;
                      count++;
                    } else {
                      // if there is time between current schedule and previous schedule render a empty cell
                      lecturecell.add(LectureBox(
                          height: RSS[RenderSpecificIdx[count]]
                                  .startMinute
                                  .toDouble() -
                              renderedTime,
                          type: 2));
                      renderedTime = RSS[RenderSpecificIdx[count]].startMinute;
                    }
                  }

                  if (renderedTime < 60) {
                    lecturecell.add(LectureBox(
                        height: (60 - renderedTime).toDouble(), type: 2));
                  }
                  children.add(Column(
                    children: [
                      for (int hello = 0; hello < lecturecell.length; hello++)
                        lecturecell[hello],
                    ],
                  ));
                } else if (isLecture == false) {
                  children.add(Cell());
                }
              }
              return Row(children: children);
            },
          ),
        ),
      ],
    );
  }
}

List<RenderSpecificSave> lectureToSpecific(List<Lecture> lec) {
  List<RenderSpecificSave> renderSpecificSave = [];

  for (int i = 0; i < lec.length; i++) {
    // time string to each hour, minute integer
    int startHour =
        int.parse(Lecture.convertToActualTime[lec[i].time]![0].substring(0, 2));
    int startMinute =
        int.parse(Lecture.convertToActualTime[lec[i].time]![0].substring(3, 5));
    int endHour =
        int.parse(Lecture.convertToActualTime[lec[i].time]![1].substring(0, 2));
    int endMinute =
        int.parse(Lecture.convertToActualTime[lec[i].time]![1].substring(3, 5));

    // split
    for (int j = startHour; j <= endHour; j++) {
      if (j == startHour && j == endHour) {
        // if start hour equals to end hour -> should be rendered in a cell
        renderSpecificSave.add(new RenderSpecificSave(
            date: int.parse(lec[i].date),
            hour: j,
            startMinute: startMinute,
            endMinute: endMinute,
            type: 0));
        // print ("같은시간 " + lec[i].date + " " + j.toString() + " " + startMinute.toString() + " " + endMinute.toString());
      } else if (j == startHour) {
        // if it's a start hour cell
        renderSpecificSave.add(new RenderSpecificSave(
            date: int.parse(lec[i].date),
            hour: j,
            startMinute: startMinute,
            endMinute: 60,
            type: 0));
        // print ("시작시간 " + lec[i].date + " " + j.toString() + " " + startMinute.toString() + " " + "60");
      } else if (j == endHour && endMinute != 0) {
        renderSpecificSave.add(new RenderSpecificSave(
            date: int.parse(lec[i].date),
            hour: j,
            startMinute: 0,
            endMinute: endMinute,
            type: 0));
        // print ("끝인시간 " + lec[i].date + " " + j.toString() + " " + "0" + " " + endMinute.toString());
      } else if (endMinute != 0) {
        renderSpecificSave.add(new RenderSpecificSave(
            date: int.parse(lec[i].date),
            hour: j,
            startMinute: 0,
            endMinute: 60,
            type: 0));
        // print ("중간시간 " + lec[i].date + " " + j.toString() + " " + "0" + " " + "60");
      }
    }
    print("\n");
  }

  // return widget spec list to render
  return renderSpecificSave;
}

List<RenderSpecificSave> reservationToSpecific(
    DateTime startTime, DateTime endTime, List<RenderSpecificSave> RSS) {
  // if start hour equals to end hour -> should be rendered in a cell
  int startHour = startTime.hour;
  int startMinute = startTime.minute;
  int endHour = endTime.hour;
  int endMinute = endTime.minute;
  int date = startTime.weekday;
  if (date == 7) {
    date = 0;
  }

  for (int j = startHour; j <= endHour; j++) {
    RenderSpecificSave? renderSpecificSave;

    if (j == startHour && j == endHour) {
      // if start hour equals to end hour -> should be rendered in a cell
      renderSpecificSave = new RenderSpecificSave(
          date: date,
          hour: j,
          startMinute: startMinute,
          endMinute: endMinute,
          type: 1);
      /*debugPrint("같은시간 " +
          date.toString() +
          " " +
          j.toString() +
          " " +
          startMinute.toString() +
          " " +
          endMinute.toString());*/
    } else if (j == startHour) {
      // if it's a start hour cell
      renderSpecificSave = new RenderSpecificSave(
          date: date,
          hour: j,
          startMinute: startMinute,
          endMinute: 60,
          type: 1);
      /*debugPrint("시작시간 " +
          date.toString() +
          " " +
          j.toString() +
          " " +
          startMinute.toString() +
          " " +
          "60");*/
    } else if (j == endHour && endMinute != 0) {
      renderSpecificSave = new RenderSpecificSave(
          date: date, hour: j, startMinute: 0, endMinute: endMinute, type: 1);
      /*debugPrint("끝인시간 " +
          " " +
          j.toString() +
          " " +
          "0" +
          " " +
          endMinute.toString());*/
    } else {
      renderSpecificSave = new RenderSpecificSave(
          date: date, hour: j, startMinute: 0, endMinute: 0, type: 1);
      /*debugPrint("중간시간 " + " " + j.toString() + " " + "0" + " " + "60");*/
    }

    // insert reservation information to lecture information list sort by time line
    for (int i = 0; i < RSS.length; i++) {
      if (RSS[i].date > renderSpecificSave.date) {
        RSS.insert(i, renderSpecificSave);
        break;
      } else if (RSS[i].date == renderSpecificSave.date &&
          RSS[i].hour > renderSpecificSave.hour) {
        RSS.insert(i, renderSpecificSave);
        break;
      } else if (RSS[i].date == renderSpecificSave.date &&
          RSS[i].hour == renderSpecificSave.hour &&
          RSS[i].startMinute == renderSpecificSave.startMinute) {
        RSS.insert(i, renderSpecificSave);
        break;
      }
    }

  }
  print("Hello");
  return RSS;
}

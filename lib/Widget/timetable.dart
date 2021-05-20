import 'package:flutter/material.dart';
import 'package:gcrs/src/anHour.dart';
import 'package:gcrs/src/header.dart';
import 'package:gcrs/src/indicator.dart';
import 'package:gcrs/src/weekly_times.dart';
import 'package:gcrs/views/reservationView.dart';


class RenderSpecificSave {
  /// 한개의 셀 단위로 쪼개줌
  final int date;
  final int hour;

  /// time
  final int startMinute;
  final int endMinute;

  /// type
  final int type; // 0: lecture, 1: reservation, 2: nothing?

  RenderSpecificSave({
    required this.date,
    required this.hour,
    required this.startMinute,
    required this.endMinute,
    required this.type,
  });

  lectureToSpecific(List<Lecture> lec){
    List<RenderSpecificSave> renderSpecificSave = [];
    for (int i = 0; i < lec.length; i++){
      /// time string 을 int형 시간과 분으로 바꿔줌
      int startHour = int.parse(Lecture.convertToActualTime[lec[i].time]![0].substring(0, 2));
      int startMinute = int.parse(Lecture.convertToActualTime[lec[i].time]![0].substring(2, 4));
      int endHour = int.parse(Lecture.convertToActualTime[lec[i].time]![1].substring(0, 2));
      int endMinute = int.parse(Lecture.convertToActualTime[lec[i].time]![1].substring(2, 4));
      
      /// 쪼개줌
      for (int j = startHour; j <= endHour; j++){


      }

      /// 리턴함


    }
    return renderSpecificSave;
  }
}

class WeeklyTimeTable extends StatefulWidget {
  /*** variables ***/
  // color
  final Color cellColor;
  final Color cellSelectedColor;
  final Color boarderColor;

  final bool draggable;
  // use language
  final String locale;

  final List<Lecture> lec;

  WeeklyTimeTable({
    /* set color */
    this.cellColor = Colors.white,
    this.cellSelectedColor = Colors.blue,
    this.boarderColor = Colors.grey,
    this.draggable = false,
    this.locale = "en",
    required this.lec,
  });

  @override
  // _WeeklyTimeTableState createState() => _WeeklyTimeTableState(this.initialSchedule);
  _WeeklyTimeTableState createState() => _WeeklyTimeTableState();
}

class _WeeklyTimeTableState extends State<WeeklyTimeTable> {
  List widgets = [];
  String locale = 'en';

  // _WeeklyTimeTableState(this.selected);
  _WeeklyTimeTableState();

  @override
  void initState() {
    if (WeeklyTimes.localContains(widget.locale)) {
      setState(() {
        /// TEST TODO: remove test
        // widget.lec.add(Lecture(date: "1", time: "1"));
        widget.lec.add(Lecture(date: "1", time: "2"));
        widget.lec.add(Lecture(date: "3", time: "21"));
        widget.lec.add(Lecture(date: "3", time: "22"));

        
        // TODO: lec을 specific으로 바꿔주는 함수 호출
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
        Header(WeeklyTimes.dates[this.locale]!), // 일, 월, 화, 수 ... 토
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: WeeklyTimes.times[this.locale]!.length,
            itemBuilder: (BuildContext context, int index) {
              List<Widget> children = [];
              /* time bar (left) */
              children.add(Indicator(WeeklyTimes.times[this.locale]![index]));
              bool isLecture;
              for (int dateIdx = 0; dateIdx < 7; dateIdx++) {
                isLecture = false;
                for (int lectureIdx = 0;
                    lectureIdx < widget.lec.length;
                    lectureIdx++) {
                  if (dateIdx == int.parse(widget.lec[lectureIdx].date) &&
                      index == dateIdx) {
                    // TODO: if lecture가 있을때
                    /// timecal.return을 해서 잘 해서 잘 그린다...
                    isLecture = true;
                    children.add(Column(
                      children: [
                        LectureBox(height: 30, type: 1),
                        LectureBox(height: 30, type: 2),
                      ],
                    ));
                  }
                }
                if (isLecture == false) {
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

  loadData() async {
    setState(() {
      // TODO: reservation받아와서 바꿈
    });
  }
}

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
              
              /// cell 단위로 쪼개줌
              List<RenderSpecificSave> RSS = lectureToSpecific(widget.lec);

              for (int dateIdx = 0; dateIdx < 7; dateIdx++) {
                bool isLecture = false;
                List<int> RenderSpecificIdx = []; // 한개의 cell 대신 그려야하는 class와 reservation의 모든것
                for (int RSSIdx = 0; RSSIdx < RSS.length; RSSIdx++) {
                  if (dateIdx == RSS[RSSIdx].date && index == RSS[RSSIdx].hour - 9) {
                    isLecture = true;
                    RenderSpecificIdx.add(RSSIdx);
                  }
                }

                if (isLecture == true){
                  int renderedTime = 0;
                  List<Widget> lecturecell = [];

                  for (int count = 0; count < RenderSpecificIdx.length; count){ // TODO : renderSpecificIdx  start minute 순으로 정렬
                    /*** 0: lecture, 1: reservation, 2: nothing? ***/
                    /*** 0: orange, 1: blue, 2: teal ***/
                    if (renderedTime > RSS[RenderSpecificIdx[count]].startMinute){
                      if(renderedTime >= RSS[RenderSpecificIdx[count]].endMinute){ /// 만약 중복되는 시간에 뭔가 있으면 뛰어 넘는다.
                        count++;
                      }

                    }
                    else if (renderedTime == RSS[RenderSpecificIdx[count]].startMinute){
                      lecturecell.add(LectureBox(height: RSS[RenderSpecificIdx[count]].endMinute.toDouble() - RSS[RenderSpecificIdx[count]].startMinute.toDouble(), type:  RSS[RenderSpecificIdx[count]].type));
                      renderedTime = RSS[RenderSpecificIdx[count]].endMinute;
                      count++;
                    }
                    else{
                      renderedTime = RSS[RenderSpecificIdx[count]].startMinute;
                      lecturecell.add(LectureBox(height: RSS[RenderSpecificIdx[count]].startMinute.toDouble() - renderedTime, type: 1));

                    }
                  }

                  if (renderedTime != 60){
                    lecturecell.add(LectureBox(height: (60 - renderedTime).toDouble(), type: 2));
                  }
                  children.add(Column(
                    children: [
                      for (int hello = 0; hello < lecturecell.length; hello++)
                        lecturecell[hello],
                    ],
                  ));
                }
                else if (isLecture == false) {
                  children.add(Cell());
                }
              }return Row(children: children);
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

List<RenderSpecificSave> lectureToSpecific(List<Lecture> lec){
  List<RenderSpecificSave> renderSpecificSave = [];

  for (int i = 0; i < lec.length; i++){
    /// time string 을 int형 시간과 분으로 바꿔줌
    int startHour = int.parse(Lecture.convertToActualTime[lec[i].time]![0].substring(0, 2));
    int startMinute = int.parse(Lecture.convertToActualTime[lec[i].time]![0].substring(3, 5));
    int endHour = int.parse(Lecture.convertToActualTime[lec[i].time]![1].substring(0, 2));
    int endMinute = int.parse(Lecture.convertToActualTime[lec[i].time]![1].substring(3, 5));

    /// 쪼개줌
    for (int j = startHour; j <= endHour; j++){
      if (j == startHour && j == endHour){ // 같은 시간(cell)에 start, end 다 있을경우
        renderSpecificSave.add(new RenderSpecificSave(date: int.parse(lec[i].date), hour: j, startMinute: startMinute, endMinute: endMinute, type: 0));
        print ("같은시간 " + lec[i].date + " " + j.toString() + " " + startMinute.toString() + " " + endMinute.toString());
      }
      else if(j == startHour){ // 시작 시간(cell)인 경우
        renderSpecificSave.add(new RenderSpecificSave(date: int.parse(lec[i].date), hour: j, startMinute: startMinute, endMinute: 60, type: 0));
        // print ("시작시간 " + lec[i].date + " " + j.toString() + " " + startMinute.toString() + " " + "60");
      }
      else if (j == endHour && endMinute != 0){
        renderSpecificSave.add(new RenderSpecificSave(date: int.parse(lec[i].date), hour: j, startMinute: 0, endMinute: endMinute, type: 0));
        // print ("끝인시간 " + lec[i].date + " " + j.toString() + " " + "0" + " " + endMinute.toString());
      }
      else if (endMinute != 0){
        renderSpecificSave.add(new RenderSpecificSave(date: int.parse(lec[i].date), hour: j, startMinute: 0, endMinute: 60, type: 0));
        // print ("중간시간 " + lec[i].date + " " + j.toString() + " " + "0" + " " + "60");
      }
    }
    // print("\n");
  }

  /// 리턴함
  return renderSpecificSave;
}

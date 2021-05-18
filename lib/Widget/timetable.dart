import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gcrs/src/anHour.dart';
import 'package:gcrs/src/header.dart';
import 'package:gcrs/src/indicator.dart';
import 'package:gcrs/src/weekly_times.dart';
import 'package:http/http.dart' as http;
import 'package:gcrs/views/reservationView.dart';



class WeeklyTimeTable extends StatefulWidget {
  /*** variables ***/
  // color
  final Color cellColor;
  final Color cellSelectedColor;
  final Color boarderColor;

  final bool draggable;
  // use language
  final String locale;

  List<Lecture> lec = []; // TODO: 강의 받아와서 저장 -> 요일 별 정렬 후 저장해 줍시다

  WeeklyTimeTable({
    /* set color */
    this.cellColor = Colors.white,
    this.cellSelectedColor = Colors.blue,
    this.boarderColor = Colors.grey,
    this.draggable = false,
    this.locale = "en",
  });

  @override
  // _WeeklyTimeTableState createState() => _WeeklyTimeTableState(this.initialSchedule);
  _WeeklyTimeTableState createState() => _WeeklyTimeTableState();
}

class _WeeklyTimeTableState extends State<WeeklyTimeTable> {
  List widgets = [];
  String locale = 'en';
  List<Lecture> lec = [];


  // _WeeklyTimeTableState(this.selected);
  _WeeklyTimeTableState();

  @override
  void initState() {
    if (WeeklyTimes.localContains(widget.locale)) {
      setState(() {
        /// TEST TODO: remove test
        lec.add(Lecture(date: "1", time: "1"));
        // lec.add(Lecture(date: "1", time: "2"));
        lec.add(Lecture(date: "3", time: "21"));
        // lec.add(Lecture(date: "3", time: "22"));

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
        Header(WeeklyTimes.dates[this.locale]), // 일, 월, 화, 수 ... 토
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: WeeklyTimes.times[this.locale].length,
            itemBuilder: (BuildContext context, int index) {
              List<Widget> children = [];
              /* time bar (left) */
              children.add(
                  Indicator(WeeklyTimes.times[this.locale][index])
              );
              bool isLecture;
              for (int dateIdx = 0; dateIdx < 7; dateIdx++){
                isLecture = false;
                for (int lectureIdx = 0; lectureIdx < lec.length; lectureIdx++){
                  if (dateIdx == int.parse(lec[lectureIdx].date) && index == dateIdx){
                    // TODO: if lecture가 있을때
                    /// timecal.return을 해서 잘 해서 잘 그린다...
                    isLecture = true;
                    children.add(
                        Column(
                          children: [
                            LectureBox(height: 30),
                            LectureBox(height: 30),
                          ],
                        )
                    );
                  }
                }
                if (isLecture == false){
                  children.add(
                      Cell()
                  );
                }
              }
              /*
              for (int lectureIdx = 0; lectureIdx < lec.length; lectureIdx++){
                if (dateIdx == int.parse(lec[lectureIdx].date)){
                  children.add(
                      Column(
                        children: [
                          LectureBox(height: 30),
                          LectureBox(height: 30),
                        ],
                      )
                  );
                }
                if (lectureIdx == index){

                }
                children.add(
                  Cell(),
                );
              }
              */
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
      // TODO: day 순 , time 순,(?) 으로 정렬 필요 -> 나중에 정하자...
      // widgets = json.decode(response.body);
    });
  }
}
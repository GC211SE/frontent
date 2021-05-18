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
        lec.add(Lecture(date: "1", time: "2"));
        lec.add(Lecture(date: "3", time: "21"));
        lec.add(Lecture(date: "3", time: "22"));

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
          child:
              ListView.builder(
                itemCount: WeeklyTimes.dates[this.locale].length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  List<Widget> children = [];
                  if(index == 0){
                    for (int i = 0; i < WeeklyTimes.times[this.locale].length; i++) {
                      children.add(
                          Container(
                            height: 60.0,
                            child: Indicator(WeeklyTimes.times[this.locale][i]),
                          )
                      );
                    }
                  }
                  return Column(children: children);
                }
              ),
              /*
              ListView.builder(
                  itemCount: WeeklyTimes.dates[this.locale].length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    List<Widget> children = [];
                    if(index == 0){
                      for (int i = 0; i < WeeklyTimes.times[this.locale].length; i++) {
                        children.add(
                            Container(
                              height: 60.0,
                              child: Indicator(WeeklyTimes.times[this.locale][i]),
                            )
                        );
                      }
                    }
                    return Row(children: children);
                  }
              )
              */

        /*
        Expanded(
          child: ListView.builder( // list view를 요일별로 따로 만들어 줘...?
            // itemCount: WeeklyTimes.times[this.locale].length,
            itemCount: WeeklyTimes.dates[this.locale].length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              List<Widget> children = [];
              if(index == 0){
                for (int i = 0; i < WeeklyTimes.times[this.locale].length; i++) {
                  children.add(
                      Container(
                        height: 60.0,
                        child: Indicator(WeeklyTimes.times[this.locale][i]),
                      )
                  );
                }
              }
              else{
                int hourskip; /// hourskip counter
                /*
              children.addAll(
                /// 민약 lecture에 해당 시간 idx가 있을 경우 -------이거 으케함...
                /// 2개자른걸 그려준다!
                List.generate(
                  WeeklyTimes.dates[this.locale].length - 1,
                      (i) => Cell(
                    day: i,
                    timeRange: index,
                    cellColor: widget.cellColor,
                    cellSelectedColor: widget.cellSelectedColor,
                    boarderColor: widget.boarderColor,
                        isLecture: false,
                  ),
                ),
              );
              */
                /// add로 다바꾸면 되려나? -> 가로 세로를 바꾸도록하자
                children.add(
                    Cell(
                      day: 1,
                      timeRange: index,
                      cellColor: widget.cellColor,
                      cellSelectedColor: widget.cellSelectedColor,
                      boarderColor: widget.boarderColor,
                      isLecture: false,
                    )
                );
                for (int count = 0; count < lec.length; count++){
                  if(int.parse(lec[count].date) == index){

                  }
                }
              }
              // return Row(children: children);
              return Column(children: children);
            },

          ),
        ),*/
        )],
    );
  }

  loadData() async {
    Uri dataURL = Uri.parse("https://gcse.doky.space/api/schedule?bd=IT대학&crn=304");
    http.Response response = await http.get(dataURL);
    setState(() {
      // TODO: change 적용이 이안에 들어가야할 듯?
      // TODO: day 순 , time 순, 으로 정렬 필요(이게 맞는듯)
      // widgets = json.decode(response.body);
    });
  }
}
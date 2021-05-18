import 'package:flutter/material.dart';

class Cell extends StatefulWidget {
  final int day;
  final int timeRange;
  final Color cellColor;
  final Color cellSelectedColor;
  final Color boarderColor;

  /// 시간에 따라  cell 잘라야함
  final double height;
  final bool isLecture;

  Cell({
    @required this.day,
    @required this.timeRange,
    this.height = 60.0,
    this.cellColor = Colors.white,
    this.cellSelectedColor = Colors.blueAccent,
    this.boarderColor = Colors.grey,
    this.isLecture,
  });

  @override
  _CellState createState() => _CellState();
}

class _CellState extends State<Cell> {
  Key key;

  @override
  void initState() {
    key = Key("timecell-${widget.day}-${widget.timeRange}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      key: key,
      child: Container(
        decoration: BoxDecoration(
          // color: currentColor,
          color: widget.isLecture? widget.cellSelectedColor : widget.cellColor ,
          border: Border(
            right: BorderSide(width: 1.0, color: widget.boarderColor),
            left: BorderSide(width: 0.0, color: widget.boarderColor),
            bottom: BorderSide(width: 0.0, color: widget.boarderColor),
          ),
        ),
        width: widget.height,
        height: widget.height,
      ),
    );
  }
}
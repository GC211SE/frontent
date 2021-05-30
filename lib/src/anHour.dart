import 'package:flutter/material.dart';

// a cell indicate an hour
class Cell extends StatefulWidget {
  final Color cellColor;
  final Color boarderColor;

  Cell({
    this.cellColor = Colors.white,
    this.boarderColor = Colors.grey,
  });

  @override
  _CellState createState() => _CellState();
}

class _CellState extends State<Cell> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: widget.cellColor,
          border: Border(
            top: BorderSide(width: 1.0, color: widget.boarderColor),
            left: BorderSide(width: 0.0, color: widget.boarderColor),
            right: BorderSide(width: 0.0, color: widget.boarderColor),
          ),
        ),
        height: 60 *4/5,
      ),
    );
  }
}

/* box that shows less then an hour */
class LectureBox extends StatefulWidget {
  final Color boarderColor;
  final double height;
  final int type;

  LectureBox({
    required this.type,
    required this.height,
    this.boarderColor = Colors.grey,
  });

  @override
  _LectureBoxState createState() => _LectureBoxState();
}

class _LectureBoxState extends State<LectureBox> {
  late Color cellColor;
  @override
  void initState() {
    super.initState();
    /* color of cell 0: lecture, 1: reservation, 2: nothing? */
    if (widget.type == 0){
      cellColor = Colors.blue;
    }
    else if (widget.type == 1){
      cellColor = Colors.deepOrangeAccent;
    }
    else if (widget.type == 2){
      cellColor = Colors.white;
    }
  }


  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: cellColor,
          border: Border(
            top: BorderSide(width: 1.0, color: widget.boarderColor),
            left: BorderSide(width: 0.0, color: widget.boarderColor),
            right: BorderSide(width: 0.0, color: widget.boarderColor),
          ),
        ),
        height: widget.height *4/5,
        width: MediaQuery.of(context).size.width / 8, // device width / 8
      );
}

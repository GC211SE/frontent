import 'package:flutter/material.dart';

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
        height: 60,
      ),
    );
  }
}

class LectureBox extends StatefulWidget {
  final Color cellColor;
  final Color boarderColor;
  final double height;

  LectureBox({
    required this.height,
    this.cellColor = Colors.blue,
    this.boarderColor = Colors.grey,
  });

  @override
  _LectureBoxState createState() => _LectureBoxState();
}

class _LectureBoxState extends State<LectureBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: widget.cellColor,
          border: Border(
            top: BorderSide(width: 1.0, color: widget.boarderColor),
            left: BorderSide(width: 0.0, color: widget.boarderColor),
            right: BorderSide(width: 0.0, color: widget.boarderColor),
          ),
        ),
        height: widget.height,
        width: MediaQuery.of(context).size.width / 8, // 디바이스 넓이 / 8
      );
}

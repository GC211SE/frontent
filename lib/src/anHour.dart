import 'package:flutter/material.dart';

class Cell extends StatefulWidget {
  final int day;
  final int timeRange;
  // final bool isSelected;
  // final Function(int, int, bool) onCellTapped;
  final Color cellColor;
  final Color cellSelectedColor;
  final Color boarderColor;

  final double height;

  Cell({
    @required this.day,
    @required this.timeRange,
    // @required this.isSelected,
    // @required this.onCellTapped,
    this.height = 60.0,
    this.cellColor = Colors.white,
    this.cellSelectedColor = Colors.black,
    this.boarderColor = Colors.grey,
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
          color: widget.cellColor,
          border: Border(
            top: BorderSide(width: 1.0, color: widget.boarderColor),
            left: BorderSide(width: 0.0, color: widget.boarderColor),
            right: BorderSide(width: 0.0, color: widget.boarderColor),
          ),
        ),
        height: widget.height,
      ),
    );
  }
}
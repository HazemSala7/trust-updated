import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../Constants/constants.dart';

class TableRowCard extends StatefulWidget {
  final countryName;
  int inProgressCount, pendingCount, doneCount, index;
  TableRowCard({
    Key? key,
    required this.index,
    required this.countryName,
    required this.inProgressCount,
    required this.pendingCount,
    required this.doneCount,
  }) : super(key: key);

  @override
  State<TableRowCard> createState() => _TableRowCardState();
}

class _TableRowCardState extends State<TableRowCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: widget.index % 2 == 0 ? Colors.white : Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(right: 5, left: 5),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xffD6D3D3))),
                child: Center(
                  child: Text(
                    "${widget.countryName}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xffDFDFDF),
                    border: Border.all(color: Color(0xffD6D3D3))),
                child: Center(
                  child: Text(
                    "${widget.inProgressCount}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: MAIN_COLOR),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xffD6D3D3))),
                child: Center(
                  child: Text(
                    "${widget.pendingCount}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: MAIN_COLOR),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xffDFDFDF),
                    border: Border.all(color: Color(0xffD6D3D3))),
                child: Center(
                  child: Text(
                    "${widget.doneCount}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: MAIN_COLOR),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

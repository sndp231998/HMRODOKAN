import 'package:flutter/material.dart';

class TableBody extends StatelessWidget {
  final String tableData;
  const TableBody({super.key, required this.tableData});

  @override
  Widget build(BuildContext context) {
    return TableCell(child: Text(tableData));
  }
}

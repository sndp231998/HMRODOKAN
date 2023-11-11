import 'package:flutter/material.dart';

class TableHead extends StatelessWidget {
  final String tableData;
  const TableHead({super.key, required this.tableData});

  @override
  Widget build(BuildContext context) {
    return TableCell(
        child: Text(
      tableData,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:hmrodokan/components/table_body.dart';
import 'package:hmrodokan/components/table_head.dart';

class Sales extends StatelessWidget {
  const Sales({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // table

          Table(
            children: const [
              TableRow(children: [
                TableHead(tableData: 'Sales ID'),
                TableHead(tableData: 'Product'),
                TableHead(tableData: 'Sold Date'),
                TableHead(tableData: 'Payment Type'),
                TableHead(tableData: 'Counter ID'),
              ]),
              TableRow(children: [
                TableBody(tableData: '50123'),
                TableBody(tableData: 'Samayang Noodles'),
                TableBody(tableData: '2023/01/12'),
                TableBody(tableData: 'Cash'),
                TableBody(tableData: '10234'),
              ])
            ],
          )
        ],
      ),
    );
  }
}

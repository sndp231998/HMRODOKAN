import 'package:flutter/material.dart';
import 'package:hmrodokan/components/table_body.dart';
import 'package:hmrodokan/components/table_head.dart';

class Sales extends StatelessWidget {
  const Sales({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                headingRowColor: const MaterialStatePropertyAll(Colors.black12),
                columns: const [
                  DataColumn(label: Text('Product')),
                  DataColumn(label: Text('Sold Date')),
                  DataColumn(label: Text('Payment')),
                  DataColumn(label: Text('Counter ID')),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('Samayang Noodles')),
                    DataCell(Text('2023/01/12')),
                    DataCell(Text('Cash')),
                    DataCell(Text('10234')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Samayang Noodles')),
                    DataCell(Text('2023/01/12')),
                    DataCell(Text('Cash')),
                    DataCell(Text('10234')),
                  ]),
                ]),
          ),
        ],
      ),
    );
  }
}

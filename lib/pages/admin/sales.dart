import 'package:flutter/material.dart';

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
                  DataColumn(label: Text('Sold Date')),
                  DataColumn(label: Text('Product Name')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Payment')),
                  DataColumn(label: Text('Paid Amount')),
                  DataColumn(label: Text('Counter ID')),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('2023/01/12')),
                    DataCell(Text('Oreo')),
                    DataCell(Text('10')),
                    DataCell(Text('Cash')),
                    DataCell(Text('Rs. 1100')),
                    DataCell(Text('10234')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('2023/04/04')),
                    DataCell(Text('Monitor')),
                    DataCell(Text('1')),
                    DataCell(Text('Esewa')),
                    DataCell(Text('Rs. 967')),
                    DataCell(Text('10235')),
                  ]),
                ]),
          ),
        ],
      ),
    );
  }
}

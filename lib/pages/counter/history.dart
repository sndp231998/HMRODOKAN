import 'package:flutter/material.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
          children: const [
            TableRow(
              decoration: BoxDecoration(
                color: Colors.black26,
              ),
              children: [
                TableCell(
                    child: Text(
                  'Sales ID',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                )),
                TableCell(
                    child: Text(
                  'Date',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                )),
                TableCell(
                    child: Text(
                  'Payment',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                )),
                TableCell(
                    child: Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                )),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Text('1234')),
                TableCell(child: Text('2034/00/12')),
                TableCell(child: Text('Cash')),
                TableCell(child: Text('Rs. 2031.08')),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Text('1234')),
                TableCell(child: Text('2034/00/12')),
                TableCell(child: Text('Cash')),
                TableCell(child: Text('Rs. 2031.08')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

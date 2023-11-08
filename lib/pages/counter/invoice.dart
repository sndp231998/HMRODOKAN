import 'package:flutter/material.dart';

class Invoice extends StatelessWidget {
  const Invoice({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Hamro Dokan'),
        const Text('Counter Id: 11013'),
        const Text('Address 13 Street'),
        Table(
          children: const [
            TableRow(children: [
              Text('Description'),
              Text('QTY'),
              Text('PRICE'),
              Text('TOTAL'),
            ]),
            TableRow(children: [
              TableCell(child: Text('Woofers')),
              TableCell(child: Text('2')),
              TableCell(child: Text('100.00')),
              TableCell(child: Text('200.00')),
            ])
          ],
        ),
        // calculate total and change

        // Thank you text
      ],
    );
  }
}

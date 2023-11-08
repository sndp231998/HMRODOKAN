import 'package:flutter/material.dart';

class Invoice extends StatelessWidget {
  const Invoice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 70,
          ),
          const Column(children: [
            Text(
              'Hamro Dokan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Counter ID: 11013',
              style: TextStyle(),
            ),
            Text(
              'Invoice ID: 22310',
              style: TextStyle(),
            ),
            Text('Address 13 Street'),
          ]),
          const SizedBox(
            height: 20,
          ),
          Container(
            decoration: const BoxDecoration(
                border: Border(
              top: BorderSide(
                width: 1.0,
                color: Colors.black,
              ),
              bottom: BorderSide(
                width: 1.0,
                color: Colors.black,
              ),
            )),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Table(
                children: const [
                  TableRow(children: [
                    Text(
                      'DESCRIPTION',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'QTY',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'PRICE',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'TOTAL',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ]),
                  TableRow(children: [
                    TableCell(child: Text('Woofers')),
                    TableCell(child: Text('2')),
                    TableCell(child: Text('100.00')),
                    TableCell(child: Text('200.00')),
                  ])
                ],
              ),
            ),
          ),
          // calculate total and change
          const SizedBox(
            height: 10,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total: Rs 100000',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Cash: Rs 100000000',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Change: Rs 10000',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          ),
          // Thank you text
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Thank you for purchasing!',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

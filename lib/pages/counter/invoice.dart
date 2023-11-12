import 'package:flutter/material.dart';

class Invoice extends StatelessWidget {
  const Invoice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Counter ID:',
                      ),
                      Text(
                        'Invoice ID:',
                      ),
                      Text('Payment:'),
                      Text('Date:'),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '11013',
                        style: TextStyle(),
                      ),
                      Text(
                        '22310',
                        style: TextStyle(),
                      ),
                      Text('Cash'),
                      Text('2024/07/12'),
                    ],
                  ),
                ],
              ),
            ]),
            const SizedBox(
              height: 20,
            ),
            Table(
              children: const [
                TableRow(
                    decoration: BoxDecoration(
                      color: Colors.black12,
                    ),
                    children: [
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
            // calculate total and change
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(top: 5),
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(
                color: Colors.black54,
                width: 1.0,
              ))),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Net Total:',
                      ),
                      Text(
                        'Discount:',
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Rs. 1103',
                        style: TextStyle(),
                      ),
                      Text(
                        'Rs. 10',
                        style: TextStyle(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(top: 5),
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(
                color: Colors.black54,
                width: 1.0,
              ))),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount:',
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Rs. 2200',
                        style: TextStyle(),
                      ),
                    ],
                  ),
                ],
              ),
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
      ),
    );
  }
}

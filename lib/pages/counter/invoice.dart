import 'package:flutter/material.dart';
import 'package:hmrodokan/firebase/firebase_firestore.dart';
import 'package:hmrodokan/model/bill.dart';
import 'package:hmrodokan/model/sales.dart';

class Invoice extends StatefulWidget {
  final BillModel bill;
  const Invoice({super.key, required this.bill});

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  FirebaseFirestoreHelper firebaseFirestoreHelper = FirebaseFirestoreHelper();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebaseFirestoreHelper.listSales(widget.bill.uid),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return snapshot.data!.isNotEmpty
              ? Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 70,
                        ),
                        Column(children: [
                          const Text(
                            'Hamro Dokan',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
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
                                    widget.bill.counterId,
                                    style: const TextStyle(),
                                  ),
                                  Text(
                                    widget.bill.uid,
                                    style: const TextStyle(),
                                  ),
                                  Text(widget.bill.paymentMethod),
                                  Text('${widget.bill.issueDate}'),
                                ],
                              ),
                            ],
                          ),
                        ]),
                        const SizedBox(
                          height: 20,
                        ),
                        Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            const TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                ),
                                children: [
                                  Text(
                                    'DESCRIPTION',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'QTY',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'PRICE',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'TOTAL',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ]),
                            for (SalesModel salesData in snapshot.data!)
                              TableRow(children: [
                                TableCell(child: Text(salesData.name)),
                                TableCell(
                                    child: Text(salesData.quantity.toString())),
                                TableCell(
                                    child: Text(salesData.soldAt.toString())),
                                TableCell(
                                    child: Text(
                                        (salesData.soldAt * salesData.quantity)
                                            .toString())),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
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
                                    'Rs. ${widget.bill.totalAmount}',
                                    style: const TextStyle(),
                                  ),
                                  Text(
                                    'Rs. ${widget.bill.discount}',
                                    style: const TextStyle(),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
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
                                    'Rs. ${widget.bill.paidAmount}',
                                    style: const TextStyle(),
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(
                  child: Text('No Sales data to show'),
                );
        }));
  }
}

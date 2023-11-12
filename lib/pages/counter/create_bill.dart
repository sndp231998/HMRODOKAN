import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hmrodokan/components/bar_qr_scanner.dart';
import 'package:hmrodokan/components/products_card.dart';
import 'package:hmrodokan/pages/counter/counter_dashboard.dart';
import 'package:hmrodokan/pages/counter/invoice.dart';

class CreateBill extends StatefulWidget {
  const CreateBill({super.key});

  @override
  State<CreateBill> createState() => _CreateBillState();
}

class _CreateBillState extends State<CreateBill> {
  late final searchController;

  final List _paymentItems = [
    'Cash',
    'Due',
    'Card',
    'Esewa',
    'Khalti',
    'Mobile Banking'
  ];

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
    searchController.addListener(_handleSearchText);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _handleSearchText() {
    final text = searchController.text;

    if (text != '') {
      // search for items
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                padding: const EdgeInsets.only(top: 15.0),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(color: Colors.black26, width: 1.0))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Back button
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back)),
                    // Search Input
                    Expanded(
                        child: SearchAnchor.bar(
                            viewBackgroundColor: Colors.white,
                            barBackgroundColor:
                                const MaterialStatePropertyAll(Colors.white),
                            suggestionsBuilder: (BuildContext context,
                                SearchController controller) {
                              return List<ListTile>.generate(5, (int index) {
                                final String item = 'item $index';
                                return ListTile(
                                  title: Text(item),
                                  onTap: () {
                                    setState(() {
                                      controller.closeView(item);
                                    });
                                  },
                                );
                              });
                            })),
                    // Scanner QR
                    PopupMenuButton(
                        icon: const Icon(Icons.qr_code),
                        onSelected: (value) {
                          ScanMode getScanMode = ScanMode.DEFAULT;
                          if (value == 0) {
                            getScanMode = ScanMode.QR;
                          }
                          if (value == 1) {
                            getScanMode = ScanMode.BARCODE;
                          }

                          setState(() async {
                            searchController.text =
                                await BarQRScan.scanBarQrCodeNormal(
                                    getScanMode);
                          });
                        },
                        itemBuilder: (context) {
                          return const [
                            PopupMenuItem(
                                value: 0,
                                child: ListTile(
                                  leading: Icon(Icons.qr_code),
                                  title: Text('Scan QR Code'),
                                )),
                            PopupMenuItem(
                                value: 1,
                                child: ListTile(
                                  leading: Icon(Icons.barcode_reader),
                                  title: Text('Scan Bar Code'),
                                )),
                          ];
                        })
                  ],
                ),
              )),
          // Main Screen
          Positioned(
              top: 80,
              left: 0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: const SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      ProductsCard(),
                      ProductsCard(),
                    ],
                  ),
                ),
              )),
          // Bottom Screen
          Positioned(
              bottom: 0,
              left: 0,
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // payment methods
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Payment Type'),
                          DropdownButton(
                              value: 'Cash',
                              items: _paymentItems.map((item) {
                                return DropdownMenuItem(
                                    alignment: Alignment.centerLeft,
                                    value: item,
                                    child: Text(
                                      item,
                                    ));
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  // change here
                                });
                              }),
                        ],
                      ),
                    ),
                  ),

                  // create bill

                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        showOrderCompletionModal(context);
                      },
                      child: Container(
                        color: Colors.green,
                        child: const Center(
                            child: Text(
                          'Create Bill',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ),

                  // total
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.blueGrey,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Rs. 1000',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }

  void showOrderCompletionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Set to true for centering on the screen
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.check_circle),
                const Text(
                  'Order Completed!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your order has been successfully completed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Perform the print action
                        // Add your print logic here
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Invoice()));
                      },
                      child: const Text('Print'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Perform the share action
                        // Add your share logic here
                      },
                      child: const Text('Share'),
                    ),
                  ],
                ),
                IntrinsicWidth(
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.green),
                        foregroundColor:
                            MaterialStatePropertyAll(Colors.white)),
                    onPressed: () {
                      // Navigate to the home screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CounterDashboard())); // Close the modal
                      // Add your navigation logic here
                    },
                    child: const Text('Go to Home'),
                  ),
                ),
                IntrinsicWidth(
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.green),
                        foregroundColor:
                            MaterialStatePropertyAll(Colors.white)),
                    onPressed: () {
                      // Navigate to the home screen
                      Navigator.pop(context); // Close the modal
                      // Add your navigation logic here
                    },
                    child: const Text('Create New Bill'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

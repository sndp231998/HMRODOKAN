import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class CounterDashboard extends StatefulWidget {
  const CounterDashboard({super.key});

  @override
  State<CounterDashboard> createState() => _CounterDashboardState();
}

class _CounterDashboardState extends State<CounterDashboard> {
  String _barqrRes = '';

  List products = [
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
  ];

  Future<void> scanBarQrCodeNormal(ScanMode scanmode) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, scanmode);

      debugPrint(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version';
    }

    if (!mounted) return;
    setState(() {
      _barqrRes = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          title: const Text(
            "Hamro Dokan",
          )),
      body: Column(
        children: [
          SizedBox(
            height: 350,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(children: [
                  const TableRow(children: [
                    Text(
                      "ID",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Name",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Price",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Qty",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Total",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Action",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ]),
                  for (int i = 0; i < products.length; i++)
                    TableRow(children: [
                      Text('${products[i]["id"]}'),
                      Text('${products[i]["name"]}'),
                      Text('${products[i]["price"]}'),
                      Text('${products[i]["qty"]}'),
                      Text('${products[i]["total"]}'),
                      GestureDetector(
                        onTap: () {
                          products = products
                              .where((element) =>
                                  element["id"] != products[i]["id"])
                              .toList();
                        },
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
                    ]),
                ]),
              ),
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      "Total: Rs 400000",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                        onPressed: null,
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStatePropertyAll<Color>(Colors.white),
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.green),
                        ),
                        child: Text("Invoice"))
                  ],
                ),
              ),
              // AddInventory
            ],
          ),
          Text(_barqrRes),
        ],
      ),

// icon: Icon(Icons.category), label: 'Category'),
      bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.inventory), label: ''),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner),
              label: '',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: '')
          ],
          onTap: (int index) async {
            if (index == 1) {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      height: 150,
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () {
                              scanBarQrCodeNormal(ScanMode.QR);
                            },
                            leading: const Icon(Icons.qr_code),
                            title: const Text('Scan QR Code'),
                          ),
                          ListTile(
                            onTap: () {
                              scanBarQrCodeNormal(ScanMode.BARCODE);
                            },
                            leading: const Icon(Icons.barcode_reader),
                            title: const Text('Scan Barcode'),
                          )
                        ],
                      ),
                    );
                  });
            }
          }),
    );
  }
}

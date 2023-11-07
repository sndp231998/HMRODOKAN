import 'package:flutter/material.dart';

class CounterDashboard extends StatefulWidget {
  const CounterDashboard({super.key});

  @override
  State<CounterDashboard> createState() => _CounterDashboardState();
}

class _CounterDashboardState extends State<CounterDashboard> {
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
          )
        ],
      ),

// icon: Icon(Icons.category), label: 'Category'),
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.inventory), label: ''),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner),
              label: '',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: '')
          ],
          onTap: (int index) {
            if (index == 1) {
              scanQRCode();
            }
          }),
    );
  }

  void scanQRCode() async {
    try {
      // String? result = await scanner.scan(); // Use String? instead of String
      String? result = '';
      if (result != null) {
        // Handle the scanned QR code result here when it's not null.
        print("Scanned QR code result: $result");
      } else {
        // Handle the case when the result is null, if needed.
        print("No QR code was scanned.");
      }
    } catch (e) {
      // Handle errors, if any.
      print("Error while scanning QR code: $e");
    }
  }
}

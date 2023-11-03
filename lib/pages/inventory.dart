import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory App',
    );
  }
}

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<Item> items = [];
  List<Item> filteredItems = [];

  void addItem(String name, double price, String code) {
    setState(() {
      items.add(Item(name, price, code));
      updateFilteredItems('');
    });
  }

  void updateFilteredItems(String searchTerm) {
    filteredItems.clear();
    if (searchTerm.isEmpty) {
      filteredItems.addAll(items);
    } else {
      filteredItems.addAll(items.where((item) {
        return item.name.toLowerCase().contains(searchTerm.toLowerCase());
      }));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Page'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.teal],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Inventory',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Search Item'),
                      onChanged: (value) {
                        updateFilteredItems(value);
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Implement category functionality
                    },
                    child: Text('Category'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Item Name')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Code')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: filteredItems.map((item) {
                    return DataRow(cells: [
                      DataCell(Text(item.name)),
                      DataCell(Text('\$${item.price.toStringAsFixed(2)}')),
                      DataCell(Text(item.code)),
                      DataCell(
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  items.remove(item);
                                  updateFilteredItems('');
                                });
                              },
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      TextEditingController nameController =
                          TextEditingController();
                      TextEditingController priceController =
                          TextEditingController();
                      TextEditingController codeController =
                          TextEditingController();
                      return AlertDialog(
                        title: Text('Add New Item'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: nameController,
                              decoration:
                                  InputDecoration(labelText: 'Item Name'),
                            ),
                            TextField(
                              controller: priceController,
                              decoration:
                                  InputDecoration(labelText: 'Item Price'),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                            ),
                            TextField(
                              controller: codeController,
                              decoration:
                                  InputDecoration(labelText: 'Item Code'),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Add'),
                            onPressed: () {
                              String name = nameController.text;
                              double price =
                                  double.tryParse(priceController.text) ?? 0.0;
                              String code = codeController.text;

                              if (name.isNotEmpty &&
                                  price > 0 &&
                                  code.isNotEmpty) {
                                addItem(name, price, code);
                              }
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Add Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Item {
  final String name;
  final double price;
  final String code;

  Item(this.name, this.price, this.code);
}

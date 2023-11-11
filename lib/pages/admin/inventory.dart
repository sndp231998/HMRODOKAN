import 'package:flutter/material.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

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
    return Container(
      decoration: const BoxDecoration(
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
            const Text(
              'Inventory',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Search Item'),
                    onChanged: (value) {
                      updateFilteredItems(value);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // Implement category functionality
                  },
                  child: const Text('Category'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: DataTable(
                columns: const [
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
                            child: const Text('Delete'),
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
                      title: const Text('Add New Item'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: nameController,
                            decoration:
                                const InputDecoration(labelText: 'Item Name'),
                          ),
                          TextField(
                            controller: priceController,
                            decoration:
                                const InputDecoration(labelText: 'Item Price'),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                          ),
                          TextField(
                            controller: codeController,
                            decoration:
                                const InputDecoration(labelText: 'Item Code'),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Add'),
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
              child: const Text('Add Item'),
            ),
          ],
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

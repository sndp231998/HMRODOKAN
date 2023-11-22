import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hmrodokan/components/bar_qr_scanner.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  AddItemPageState createState() => AddItemPageState();
}

class AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();

  String _barqrRes = '';

  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _mrpController = TextEditingController();
  final _taxController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _productNameController,
                      decoration: const InputDecoration(
                        labelText: 'Product Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a product name.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a quantity.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _purchasePriceController,
                      decoration: const InputDecoration(
                        labelText: 'Purchase Price',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a purchase price.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _mrpController,
                      decoration: const InputDecoration(
                        labelText: 'MRP',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an MRP.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _taxController,
                      decoration: const InputDecoration(
                        labelText: 'Tax (%)',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a tax percentage.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _barcodeController,
                      decoration: const InputDecoration(
                        labelText: 'Barcode',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.qr_code_scanner),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: 150,
                                child: Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        setState(() async {
                                          _barqrRes = await BarQRScan
                                              .scanBarQrCodeNormal(ScanMode.QR);
                                        });
                                      },
                                      leading: const Icon(Icons.qr_code),
                                      title: const Text('Scan QR Code'),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        setState(() async {
                                          _barqrRes = await BarQRScan
                                              .scanBarQrCodeNormal(
                                                  ScanMode.BARCODE);
                                        });
                                      },
                                      leading: const Icon(Icons.barcode_reader),
                                      title: const Text('Scan Barcode'),
                                    )
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                    TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a category.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Add item to database
                          }
                        },
                        child: const Text('Add Item')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

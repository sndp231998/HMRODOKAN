// import 'package:flutter/material.dart';
// //import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

// class AddItemPage extends StatefulWidget {
//   const AddItemPage({super.key});

//   @override
//   _AddItemPageState createState() => _AddItemPageState();
// }

// class _AddItemPageState extends State<AddItemPage> {
//   final _formKey = GlobalKey<FormState>();

//   final _productNameController = TextEditingController();
//   final _priceController = TextEditingController();
//   final _quantityController = TextEditingController();
//   final _purchasePriceController = TextEditingController();
//   final _mrpController = TextEditingController();
//   final _taxController = TextEditingController();
//   final _barcodeController = TextEditingController();
//   final _categoryController = TextEditingController();

//   void scanBarcode() async {
//     String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
//         "#ff6666", "Cancel", true, ScanMode.BARCODE);
//     setState(() {
//       _barcodeController.text = barcodeScanRes;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Item'),
//         backgroundColor: Colors.green,
//       ),
//       body: Form(
//         key: _formKey,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _productNameController,
//                 decoration: InputDecoration(
//                   labelText: 'Product Name',
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a product name.';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _priceController,
//                 decoration: InputDecoration(
//                   labelText: 'Price',
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a price.';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _quantityController,
//                 decoration: InputDecoration(
//                   labelText: 'Quantity',
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a quantity.';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _purchasePriceController,
//                 decoration: InputDecoration(
//                   labelText: 'Purchase Price',
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a purchase price.';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _mrpController,
//                 decoration: InputDecoration(
//                   labelText: 'MRP',
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter an MRP.';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _taxController,
//                 decoration: InputDecoration(
//                   labelText: 'Tax (%)',
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a tax percentage.';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _barcodeController,
//                 decoration: InputDecoration(
//                   labelText: 'Barcode',
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.qr_code_scanner),
//                 onPressed: scanBarcode,
//               ),
//               TextFormField(
//                 controller: _categoryController,
//                 decoration: InputDecoration(
//                   labelText: 'Category',
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a category.';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     // Add item to database
//                   }
//                 },
//                 child: Text('Add Item'),
              

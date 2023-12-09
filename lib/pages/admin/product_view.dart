import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hmrodokan/components/bar_qr_scanner.dart';
import 'package:hmrodokan/firebase/firebase_firestore.dart';
import 'package:hmrodokan/firebase/firebase_storage.dart';
import 'package:hmrodokan/model/category.dart';
import 'package:hmrodokan/model/product.dart';
import 'package:hmrodokan/services/image_helper.dart';
import 'package:hmrodokan/utils.dart';
import 'package:image_picker/image_picker.dart';

class ProductView extends StatefulWidget {
  final bool isEditing;
  final ProductModel? product;
  const ProductView({super.key, required this.isEditing, this.product});

  @override
  State<ProductView> createState() => _ProductViewState();
}

InputDecoration viewDecoration =
    const InputDecoration(border: InputBorder.none);

InputDecoration editDecoration =
    const InputDecoration(border: OutlineInputBorder());

class _ProductViewState extends State<ProductView> {
  File? _image;

  List<CategoryModel> dropDownList = [];
  List<String> unitList = ['pc', 'kg', 'ltr'];

  String dropDownCategory = '';

  bool isSaving = false;

  late String scanCode;

  late final _productNameController =
      TextEditingController(text: widget.product!.title);
  late final _priceController =
      TextEditingController(text: widget.product!.sellingPrice.toString());
  late final _quantityController =
      TextEditingController(text: widget.product!.quantity.toString());
  late final _purchasePriceController =
      TextEditingController(text: widget.product!.purchasePrice.toString());
  late final _imageUrlController =
      TextEditingController(text: widget.product!.imageUrl);
  late String unitValue = widget.product!.unit;

  FirebaseFirestoreHelper firebaseFirestoreHelper = FirebaseFirestoreHelper();

  void toggleIsSaving(bool value) {
    setState(() {
      isSaving = value;
    });
  }

  Future<void> handleEdit(BuildContext context) async {
    toggleIsSaving(true);
    String productName = _productNameController.text;
    String imageUrl = _imageUrlController.text;
    double sellingPrice = double.parse(_priceController.text);
    double purchasePrice = double.parse(_priceController.text);
    double quantity = double.parse(_quantityController.text);

    if (productName.isEmpty ||
        scanCode.isEmpty ||
        imageUrl.isEmpty ||
        dropDownCategory.isEmpty) {
      return Utils().toastor(context, 'Some fields are empty.');
    }

    try {
      // store images if image is uploaded
      if (_image != null) {
        FirebaseStorageHelper firebaseStorageHelper = FirebaseStorageHelper();
        imageUrl = await firebaseStorageHelper.uploadImage(_image!, 'products');
      }

      ProductModel editedProduct = ProductModel(
          uid: widget.product!.uid,
          title: productName,
          storeId: widget.product!.storeId,
          categoryId: dropDownCategory,
          imageUrl: imageUrl,
          unit: unitValue,
          quantity: quantity,
          purchasePrice: purchasePrice,
          scannerCode: scanCode,
          sellingPrice: sellingPrice);

      await firebaseFirestoreHelper.editProducts(editedProduct);
      if (context.mounted) Utils().toastor(context, 'Edited Successfully');
    } catch (e) {
      if (context.mounted) Utils().toastor(context, e.toString());
    }
    toggleIsSaving(false);
  }

  @override
  void initState() {
    super.initState();

    listCategory();
    setState(() {
      scanCode = widget.product!.scannerCode;
    });
  }

  Future<void> listCategory() async {
    List<CategoryModel> listCategories =
        await firebaseFirestoreHelper.listCategories();

    setState(() {
      dropDownList = listCategories;
      dropDownCategory = widget.product!.categoryId;
    });
  }

  void handleChange(String id) {
    setState(() {
      dropDownCategory = id;
    });
  }

  _showDialog(BuildContext context) {
    ImageHelper imageHelper = ImageHelper();
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              TextButton(
                  onPressed: () {
                    setState(() async {
                      _image =
                          await imageHelper.getImageURL(ImageSource.gallery);
                    });
                  },
                  child: const Text('Choose from gallery')),
              TextButton(
                  onPressed: () {
                    setState(() async {
                      _image =
                          await imageHelper.getImageURL(ImageSource.camera);
                    });
                  },
                  child: const Text('Capture new Photo')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'))
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();

    _productNameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _purchasePriceController.dispose();
    _imageUrlController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back_sharp)),
        title: Text(widget.isEditing ? 'Edit Product' : 'View Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Image.network(_imageUrlController.text),
                  if (widget.isEditing)
                    IconButton(
                        onPressed: () {
                          _showDialog(context);
                        },
                        icon: const Icon(Icons.add_a_photo))
                ],
              ),
              if (widget.isEditing) const Text('Paste URL of image here'),
              if (widget.isEditing)
                TextField(
                  controller: _imageUrlController,
                  readOnly: !widget.isEditing,
                  decoration:
                      widget.isEditing ? editDecoration : viewDecoration,
                ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _productNameController,
                readOnly: !widget.isEditing,
                decoration: widget.isEditing ? editDecoration : viewDecoration,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Selling Price:'),
                  SizedBox(
                    width: 100.0,
                    child: TextField(
                      controller: _priceController,
                      readOnly: !widget.isEditing,
                      decoration:
                          widget.isEditing ? editDecoration : viewDecoration,
                    ),
                  )
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Purchase Price:'),
                  SizedBox(
                    width: 100.0,
                    child: TextField(
                      controller: _purchasePriceController,
                      readOnly: !widget.isEditing,
                      decoration:
                          widget.isEditing ? editDecoration : viewDecoration,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Quantity:'),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: 100.0,
                    child: TextField(
                      controller: _quantityController,
                      readOnly: !widget.isEditing,
                      decoration:
                          widget.isEditing ? editDecoration : viewDecoration,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButton(
                  hint: const Text('Choose Unit'),
                  value: unitValue.isNotEmpty ? unitValue : null,
                  items: unitList.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: widget.isEditing
                      ? (String? value) {
                          setState(() {
                            unitValue = value!;
                          });
                        }
                      : null),
              const SizedBox(
                height: 10,
              ),
              DropdownButton(
                  hint: const Text('Choose Category'),
                  value: dropDownCategory.isNotEmpty ? dropDownCategory : null,
                  items: dropDownList.map((value) {
                    return DropdownMenuItem<String>(
                      value: value.uid,
                      child: Text(value.title),
                    );
                  }).toList(),
                  onChanged: widget.isEditing
                      ? (String? value) => handleChange(value!)
                      : null),
              const SizedBox(
                height: 10,
              ),
              const Text('Bar/Qr code'),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isEditing)
                    IconButton(
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
                                            scanCode = await BarQRScan
                                                .scanBarQrCodeNormal(
                                                    ScanMode.QR);
                                          });
                                        },
                                        leading: const Icon(Icons.qr_code),
                                        title: const Text('Scan QR Code'),
                                      ),
                                      ListTile(
                                        onTap: () {
                                          setState(() async {
                                            scanCode = await BarQRScan
                                                .scanBarQrCodeNormal(
                                                    ScanMode.BARCODE);
                                          });
                                        },
                                        leading:
                                            const Icon(Icons.barcode_reader),
                                        title: const Text('Scan Barcode'),
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                        icon: const Icon(Icons.qr_code_scanner)),
                  Text(scanCode),
                  if (widget.isEditing)
                    TextButton(
                        onPressed: () {
                          setState(() {
                            scanCode = Utils().generateRandomString();
                          });
                        },
                        child: const Text('Generate code'))
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              if (widget.isEditing)
                ElevatedButton(
                    onPressed: () {
                      handleEdit(context);
                    },
                    child: isSaving
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Save'))
            ],
          ),
        ),
      ),
    );
  }
}

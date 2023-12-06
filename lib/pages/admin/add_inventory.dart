import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hmrodokan/components/bar_qr_scanner.dart';
import 'package:hmrodokan/firebase/firebase_firestore.dart';
import 'package:hmrodokan/firebase/firebase_storage.dart';
import 'package:hmrodokan/model/category.dart';
import 'package:hmrodokan/provider/user.dart';
import 'package:hmrodokan/services/image_helper.dart';
import 'package:hmrodokan/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  AddItemPageState createState() => AddItemPageState();
}

class AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  FirebaseFirestoreHelper firebaseFirestoreHelper = FirebaseFirestoreHelper();

  List<CategoryModel> dropDownList = [];
  List<String> unitList = ['pc', 'kg', 'ltr'];

  String _barqrRes = '';
  bool isSaving = false;
  String dropDownCategory = '';
  String unitValue = 'pc';

  File? _image;

  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _taxController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    listCategory();
  }

  void toggleIsSaving(bool value) {
    setState(() {
      isSaving = value;
    });
  }

  Future<void> listCategory() async {
    List<CategoryModel> listCategories =
        await firebaseFirestoreHelper.listCategories();

    setState(() {
      dropDownList = listCategories;
      dropDownCategory = dropDownList.first.uid;
    });
  }

  Future<void> createNewProduct() async {
    toggleIsSaving(true);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    String titleText = _productNameController.text;
    String unitText = unitValue;
    double quantityText = double.parse(_quantityController.text);
    double purchaseText = double.parse(_purchasePriceController.text);
    double sellingText = double.parse(_priceController.text);
    String imageUrl = _imageUrlController.text;
    try {
      if (titleText.isNotEmpty &&
          unitText.isNotEmpty &&
          (imageUrl.isNotEmpty || _image != null) &&
          _barqrRes.isNotEmpty) {
        // store images if image is uploaded
        if (_image != null) {
          FirebaseStorageHelper firebaseStorageHelper = FirebaseStorageHelper();
          imageUrl =
              await firebaseStorageHelper.uploadImage(_image!, 'products');
        }

        await firebaseFirestoreHelper.createNewProducts(
            titleText,
            userProvider.getUser.storeId,
            dropDownCategory,
            unitText,
            quantityText,
            purchaseText,
            sellingText,
            imageUrl,
            _barqrRes);
        _productNameController.text = '';
        _quantityController.text = '';
        _purchasePriceController.text = '';
        _priceController.text = '';
        _imageUrlController.text = '';
        unitValue = 'pc';
        _image = null;
        _barqrRes = '';

        if (context.mounted) {
          Utils().toastor(context, 'Products added Successfully.');
        }
      }
    } catch (e) {
      if (context.mounted) Utils().toastor(context, e.toString());
    }

    toggleIsSaving(false);
  }

  _showDialog(BuildContext context) {
    ImageHelper imageHelper = ImageHelper();
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              TextButton(
                  onPressed: () async {
                    File? imageFile =
                        await imageHelper.getImageURL(ImageSource.gallery);
                    setState(() {
                      _image = imageFile;
                    });
                    if (context.mounted) Navigator.of(context).pop();
                  },
                  child: const Text('Choose from gallery')),
              TextButton(
                  onPressed: () async {
                    File? imageFile =
                        await imageHelper.getImageURL(ImageSource.camera);

                    setState(() {
                      _image = imageFile;
                    });
                    if (context.mounted) Navigator.of(context).pop();
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
    _taxController.dispose();
  }

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
                        onChanged: (value) {
                          setState(() {
                            unitValue = value!;
                          });
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    // TextFormField(
                    //   controller: _taxController,
                    //   decoration: const InputDecoration(
                    //     labelText: 'Tax (%)',
                    //   ),
                    //   keyboardType: TextInputType.number,
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Please enter a tax percentage.';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    const Text('Barcode'),
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
                    Text(_barqrRes),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _barqrRes = Utils().generateRandomString();
                          });
                        },
                        child: const Text('Generate Code')),
                    DropdownButton(
                        hint: const Text('Choose Category'),
                        value: dropDownCategory.isNotEmpty
                            ? dropDownCategory
                            : null,
                        items: dropDownList.map((value) {
                          return DropdownMenuItem<String>(
                            value: value.uid,
                            child: Text(value.title),
                          );
                        }).toList(),
                        onChanged: (category) {
                          setState(() {
                            dropDownCategory = category!;
                          });
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('Insert Image'),
                    IconButton(
                      onPressed: () {
                        _showDialog(context);
                      },
                      icon: const Icon(Icons.add_a_photo),
                    ),
                    _image == null
                        ? const Text('No image selected')
                        : Image(
                            image: FileImage(_image!),
                            height: 50,
                          ),
                    TextField(
                      controller: _imageUrlController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(hintText: 'Paste URL'),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                        onPressed: () {
                          createNewProduct();
                        },
                        child: isSaving
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : const Text('Add Item')),
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

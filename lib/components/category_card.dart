import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hmrodokan/firebase/firebase_firestore.dart';
import 'package:hmrodokan/firebase/firebase_storage.dart';
import 'package:hmrodokan/model/category.dart';
import 'package:hmrodokan/provider/admin.dart';
import 'package:hmrodokan/provider/products.dart';
import 'package:hmrodokan/provider/user.dart';
import 'package:hmrodokan/services/image_helper.dart';
import 'package:hmrodokan/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CategoryCard extends StatefulWidget {
  final CategoryModel category;
  const CategoryCard({super.key, required this.category});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  File? _image;
  late final TextEditingController _imageUrlController;

  late final TextEditingController _titleController;

  Future<void> handleDelete(
      BuildContext context, CategoryModel category) async {
    FirebaseFirestoreHelper firestoreHelper = FirebaseFirestoreHelper();
    try {
      await firestoreHelper.deleteCategories(category);
      if (context.mounted) Utils().toastor(context, 'Deleted Successfully');
    } catch (e) {
      if (context.mounted) Utils().toastor(context, e.toString());
    }
    if (context.mounted) Navigator.of(context).pop();
  }

  Future<void> handleEdit(BuildContext context, String storeId) async {
    FirebaseFirestoreHelper firestoreHelper = FirebaseFirestoreHelper();

    String titleText = _titleController.text;
    String imageText = _imageUrlController.text;

    if (titleText.isEmpty || (imageText.isEmpty || _image != null)) {
      return Utils().toastor(context, 'Some fields are empty');
    }

    try {
      // store images if image is uploaded
      if (_image != null) {
        FirebaseStorageHelper firebaseStorageHelper = FirebaseStorageHelper();
        imageText =
            await firebaseStorageHelper.uploadImage(_image!, 'categories');
      }

      CategoryModel categoriesModel = CategoryModel(
        uid: widget.category.uid,
        title: titleText,
        imageUrl: imageText,
        isPrivate: widget.category.isPrivate,
        storeId: storeId,
      );

      await firestoreHelper.editCategories(categoriesModel);
      if (context.mounted) Utils().toastor(context, 'Edit Successful');
    } catch (e) {
      if (context.mounted) Utils().toastor(context, e.toString());
    }
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    _imageUrlController = TextEditingController(text: widget.category.imageUrl);
    _titleController = TextEditingController(text: widget.category.title);
  }

  @override
  Widget build(BuildContext context) {
    ProductsProvider productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    AdminProvider adminProvider =
        Provider.of<AdminProvider>(context, listen: false);

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        productsProvider.setFilterValue = widget.category.uid;
        // next route to product listing
        adminProvider.setCurrentIndex = 2;
      },
      child: Container(
        // width: 200,
        // height: 200,
        margin: const EdgeInsets.all(5),
        // padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Colors.black12,
              width: 1.0,
            )),
        child: Stack(
          children: [
            // name of category
            Positioned(
              top: 1,
              left: 1,
              right: 1,
              bottom: 1,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      widget.category.imageUrl,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.category.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ]),
            ),

            if (!widget.category.isPrivate)
              Positioned(
                top: 0,
                right: 0,
                // width: 200,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return SingleChildScrollView(
                                child: AlertDialog(
                                  title: const Text('Edit Category'),
                                  content: Column(
                                    children: [
                                      TextField(
                                        controller: _titleController,
                                        decoration: const InputDecoration(
                                          hintText: 'Category Title',
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Stack(
                                        children: [
                                          if (widget
                                              .category.imageUrl.isNotEmpty)
                                            Image.network(
                                              widget.category.imageUrl,
                                              width: 80,
                                            ),
                                          Positioned(
                                            top: 1,
                                            left: 1,
                                            right: 1,
                                            bottom: 1,
                                            child: IconButton(
                                              onPressed: () {
                                                _showDialog(context);
                                              },
                                              icon:
                                                  const Icon(Icons.add_a_photo),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TextField(
                                        controller: _imageUrlController,
                                        keyboardType: TextInputType.name,
                                        decoration: const InputDecoration(
                                            hintText: 'Paste URL'),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          handleEdit(context,
                                              userProvider.getUser!.storeId);
                                        },
                                        child: const Text('Save')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel')),
                                  ],
                                ),
                              );
                            });
                      },
                      child: const Icon(
                        Icons.edit,
                        // size: 18,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Delete Category'),
                                content: const Text(
                                    'Are you sure want to remove category?'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        handleDelete(context, widget.category);
                                      },
                                      child: const Text('Yes')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel')),
                                ],
                              );
                            });
                      },
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        // size: 18,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
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
}

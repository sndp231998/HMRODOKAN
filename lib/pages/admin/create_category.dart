import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hmrodokan/firebase/firebase_firestore.dart';
import 'package:hmrodokan/firebase/firebase_storage.dart';
import 'package:hmrodokan/services/image_helper.dart';
import 'package:hmrodokan/utils.dart';
import 'package:image_picker/image_picker.dart';

class CreateCategory extends StatefulWidget {
  const CreateCategory({super.key});

  @override
  State<CreateCategory> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  File? _image;
  bool isSaving = false;

  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  void toggleIsSaving(bool value) {
    setState(() {
      isSaving = value;
    });
  }

  // create category
  Future<void> handleSave() async {
    toggleIsSaving(true);
    String titleText = _titleController.text;
    String imageUrlText = _imageUrlController.text;
    if (titleText.isEmpty || (_image == null && imageUrlText.isEmpty)) {
      return Utils().toastor(context, 'Some Fields are empty');
    }

    // store images if image is uploaded
    if (_image != null) {
      FirebaseStorageHelper firebaseStorageHelper = FirebaseStorageHelper();
      imageUrlText =
          await firebaseStorageHelper.uploadImage(_image!, 'categories');
    }

    // save to firestore
    FirebaseFirestoreHelper firebaseFirestoreHelper = FirebaseFirestoreHelper();
    await firebaseFirestoreHelper.createNewCategories(titleText, imageUrlText);
    _titleController.text = '';
    _imageUrlController.text = '';
    toggleIsSaving(false);
    if (context.mounted) Utils().toastor(context, 'Successfully saved');
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

    _imageUrlController.dispose();
    _titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Category'),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Category Title'),
            ),
            const SizedBox(
              height: 10,
            ),
            IconButton(
              onPressed: () {
                _showDialog(context);
              },
              icon: const Icon(Icons.add_a_photo),
            ),
            TextField(
              controller: _imageUrlController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(hintText: 'Paste URL'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                handleSave();
              },
              child: isSaving
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const Text('Create'),
            )
          ],
        ),
      )),
    );
  }
}

import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  Future<File?> getImageURL(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    return File(pickedFile!.path);
  }
}

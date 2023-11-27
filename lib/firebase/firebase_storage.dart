import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageHelper {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadImage(File? image, String rootDirectory) async {
    try {
      if (image == null) {
        throw Exception('Image is empty');
      }
      final String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference storageReference =
          _firebaseStorage.ref().child('$rootDirectory/$imageName.jpg');

      final UploadTask uploadTask = storageReference.putFile(image);

      // Use a Completer to create a future that completes when the upload is finished
      final Completer<String> completer = Completer<String>();

      await uploadTask.whenComplete(() async {
        final url = await storageReference.getDownloadURL();
        completer.complete(url);
      });

      // Return the future from the Completer
      return completer.future;
    } catch (e) {
      throw Exception(e);
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String uid;
  final String title;
  final String imageUrl;
  final bool isPrivate;
  final String storeId;

  CategoryModel({
    required this.uid,
    required this.title,
    required this.imageUrl,
    required this.isPrivate,
    required this.storeId,
  });

  factory CategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return CategoryModel(
        uid: data['uid'],
        title: data['title'],
        imageUrl: data['imageUrl'],
        isPrivate: data['isPrivate'],
        storeId: data['storeId']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
      'imageUrl': imageUrl,
      'isPrivate': isPrivate,
      'storeId': storeId,
    };
  }

  static CategoryModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return CategoryModel(
        uid: snapshot['uid'],
        title: snapshot['title'],
        imageUrl: snapshot['imageUrl'],
        isPrivate: snapshot['isPrivate'],
        storeId: snapshot['storeId']);
  }
}
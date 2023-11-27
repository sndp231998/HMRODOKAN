import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String uid;
  final String title;
  final String storeId;
  final String categoryId;
  final String imageUrl;
  final int quantity;
  final double purchasePrice;
  final double sellingPrice;

  ProductModel({
    required this.uid,
    required this.title,
    required this.storeId,
    required this.categoryId,
    required this.imageUrl,
    required this.quantity,
    required this.purchasePrice,
    required this.sellingPrice,
  });

  factory ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return ProductModel(
        uid: data['uid'],
        title: data['title'],
        storeId: data['storeId'],
        categoryId: data['categoryId'],
        imageUrl: data['imageUrl'],
        quantity: data['quantity'],
        purchasePrice: data['purchasePrice'],
        sellingPrice: data['sellingPrice']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
      'storeId': storeId,
      'categoryId': categoryId,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'purchasePrice': purchasePrice,
      'sellingPrice': sellingPrice,
    };
  }

  static ProductModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return ProductModel(
        uid: snapshot['uid'],
        title: snapshot['title'],
        storeId: snapshot['storeId'],
        categoryId: snapshot['categoryId'],
        imageUrl: snapshot['imageUrl'],
        quantity: snapshot['quantity'],
        purchasePrice: snapshot['purchasePrice'],
        sellingPrice: snapshot['sellingPrice']);
  }
}

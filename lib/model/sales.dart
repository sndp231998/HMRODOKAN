import 'package:cloud_firestore/cloud_firestore.dart';

class SalesModel {
  final String uid;
  final double soldAt;
  final String billId;
  final String productId;
  final String name;
  final double quantity;
  final double discount;
  final double purchaseAt;

  SalesModel({
    required this.uid,
    required this.soldAt,
    required this.billId,
    required this.name,
    required this.quantity,
    required this.productId,
    required this.discount,
    required this.purchaseAt,
  });

  factory SalesModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return SalesModel(
      uid: data['uid'],
      soldAt: data['soldAt'],
      billId: data['billId'],
      productId: data['productId'],
      name: data['name'],
      quantity: data['quantity'],
      discount: data['discount'],
      purchaseAt: data['purchaseAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'soldAt': soldAt,
      'billId': billId,
      'productId': productId,
      'name': name,
      'quantity': quantity,
      'discount': discount,
      'purchaseAt': purchaseAt,
    };
  }

  static SalesModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return SalesModel(
      uid: snapshot['uid'],
      soldAt: snapshot['soldAt'],
      billId: snapshot['billId'],
      productId: snapshot['productId'],
      name: snapshot['name'],
      quantity: snapshot['quantity'],
      discount: snapshot['discount'],
      purchaseAt: snapshot['purchaseAt'],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class BillModel {
  final String uid;
  final double totalAmount;
  final String storeId;
  final String counterId;
  final DateTime issueDate;
  final double discount;
  final double paidAmount;
  final String paymentMethod;
  final String name;
  final String phonenumber;
  final bool isDue;

  BillModel({
    required this.uid,
    required this.totalAmount,
    required this.storeId,
    required this.counterId,
    required this.issueDate,
    required this.discount,
    required this.paidAmount,
    required this.paymentMethod,
    required this.name,
    required this.phonenumber,
    required this.isDue,
  });

  factory BillModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return BillModel(
      uid: data['uid'],
      totalAmount: data['totalAmount'],
      storeId: data['storeId'],
      counterId: data['counterId'],
      issueDate: data['issueDate'].toDate(),
      discount: data['discount'],
      paidAmount: data['paidAmount'],
      paymentMethod: data['paymentMethod'],
      name: data['name'],
      phonenumber: data['phonenumber'],
      isDue: data['isDue'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'totalAmount': totalAmount,
      'storeId': storeId,
      'counterId': counterId,
      'issueDate': issueDate,
      'discount': discount,
      'paidAmount': paidAmount,
      'paymentMethod': paymentMethod,
      'name': name,
      'phonenumber': phonenumber,
      'isDue': isDue,
    };
  }

  static BillModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return BillModel(
      uid: snapshot['uid'],
      totalAmount: snapshot['totalAmount'],
      storeId: snapshot['storeId'],
      counterId: snapshot['counterId'],
      issueDate: snapshot['issueDate'].toDate(),
      discount: snapshot['discount'],
      paidAmount: snapshot['paidAmount'],
      paymentMethod: snapshot['paymentMethod'],
      name: snapshot['name'],
      phonenumber: snapshot['phonenumber'],
      isDue: snapshot['isDue'],
    );
  }
}

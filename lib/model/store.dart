import 'package:cloud_firestore/cloud_firestore.dart';

class StoreModel {
  final String uid;
  final String ownerId;
  final String name;
  final String contact;
  final String address;

  StoreModel({
    required this.uid,
    required this.ownerId,
    required this.name,
    required this.contact,
    required this.address,
  });

  factory StoreModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return StoreModel(
      uid: data['uid'],
      ownerId: data['ownerId'],
      name: data['name'],
      address: data['address'],
      contact: data['contact'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'ownerId': ownerId,
      'name': name,
      'address': address,
      'contact': contact,
    };
  }
}

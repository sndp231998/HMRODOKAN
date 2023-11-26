import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fullname;
  final String email;
  final String address;
  final String phonenumber;
  final String role;
  final String username;
  final String storeId;

  UserModel({
    required this.uid,
    required this.fullname,
    required this.email,
    required this.address,
    required this.phonenumber,
    required this.role,
    required this.username,
    required this.storeId,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
        uid: data['uid'],
        fullname: data['fullname'],
        email: data['email'],
        address: data['address'],
        phonenumber: data['phonenumber'],
        role: data['role'],
        username: data['username'],
        storeId: data['storeId']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullname': fullname,
      'email': email,
      'address': address,
      'phonenumber': phonenumber,
      'role': role,
      'username': username,
      'storeId': storeId,
    };
  }

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshotData = snap.data() as Map<String, dynamic>?;

    if (snapshotData != null) {
      return UserModel(
        uid: snapshotData['uid'] ??
            '', // Provide a default value if 'uid' is null
        fullname: snapshotData['fullname'] ?? '',
        email: snapshotData['email'] ?? '',
        address: snapshotData['address'] ?? '',
        phonenumber: snapshotData['phonenumber'] ?? '',
        role: snapshotData['role'] ?? '',
        username: snapshotData['username'] ?? '',
        storeId: snapshotData['storeId'] ?? '',
      );
    } else {
      // Return a default UserModel or throw an exception, depending on your needs
      return UserModel(
          uid: '',
          fullname: '',
          email: '',
          address: '',
          phonenumber: '',
          role: '',
          username: '',
          storeId: ''); // Provide default values or handle the null case
    }
  }

  // Factory method to create a UserModel instance from stored JSON data
  factory UserModel.fromJson(String json) {
    Map<String, dynamic> data = jsonDecode(json);
    return UserModel(
      uid: data['uid'],
      fullname: data['fullname'],
      email: data['email'],
      address: data['address'],
      phonenumber: data['phonenumber'],
      role: data['role'],
      username: data['username'],
      storeId: data['storeId'],
    );
  }

  // Convert the UserModel instance to JSON format for storage
  String toJson() {
    return json.encode({
      'uid': uid,
      'fullname': fullname,
      'email': email,
      'address': address,
      'phonenumber': phonenumber,
      'role': role,
      'username': username,
      'storeId': storeId,
    });
  }
}

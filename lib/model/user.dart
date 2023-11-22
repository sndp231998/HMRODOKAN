import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fullname;
  final String email;
  final String address;
  final String phonenumber;
  final String role;
  final String username;

  UserModel({
    required this.uid,
    required this.fullname,
    required this.email,
    required this.address,
    required this.phonenumber,
    required this.role,
    required this.username,
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
        username: data['username']);
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
    };
  }

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
        uid: snapshot['uid'],
        fullname: snapshot['fullname'],
        email: snapshot['email'],
        address: snapshot['address'],
        phonenumber: snapshot['phonenumber'],
        role: snapshot['role'],
        username: snapshot['username']);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String fullname;
  final String email;
  final String address;
  final String phonenumber;
  final bool isAdmin;
  final String loginId;
  final String password;

  UserModel(
      {required this.fullname,
      required this.email,
      required this.address,
      required this.phonenumber,
      required this.isAdmin,
      required this.loginId,
      required this.password});

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
        fullname: data['fullname'],
        email: data['email'],
        address: data['address'],
        phonenumber: data['phonenumber'],
        isAdmin: data['isAdmin'],
        loginId: data['loginId'],
        password: data['password']);
  }

  Map<String, dynamic> toMap() {
    return {
      'fullname': fullname,
      'email': email,
      'address': address,
      'phonenumber': phonenumber,
      'isAdmin': isAdmin,
      'loginId': loginId,
      'password': password
    };
  }

  // create users
  Future<void> createNewUser(UserModel user) async {
    try {
      await FirebaseFirestore.instance.collection('users').add(user.toMap());
    } catch (e) {
      throw Exception(e);
    }
  }

  // create users
  Future<void> listUsers() async {
    try {
      await FirebaseFirestore.instance.collection('users').get();
    } catch (e) {
      throw Exception(e);
    }
  }

  // edit users
  Future<void> editUser(String uid, UserModel user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update(user.toMap());
    } catch (e) {
      throw Exception(e);
    }
  }

  // delete users
  Future<void> deleteUser(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
    } catch (e) {
      throw Exception(e);
    }
  }
}

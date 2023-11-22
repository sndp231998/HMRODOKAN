import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hmrodokan/model/user.dart';

class FirebaseAuthHelper {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // get user instance
  Future<UserModel> getUserInstance() async {
    try {
      User currentUser = _firebaseAuth.currentUser!;

      DocumentSnapshot documentSnapshot = await _firebaseFirestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      return UserModel.fromSnap(documentSnapshot);
    } catch (e) {
      throw Exception(e);
    }
  }

// login admin
  Future<void> loginUser(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      throw Exception(e);
    }
  }

  // create users
  Future<void> createNewUser({
    required String email,
    required String fullname,
    required String password,
    required String role,
    required String address,
    required String phonenumber,
    required String username,
  }) async {
    try {
      UserCredential cred = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      UserModel user = UserModel(
          uid: cred.user!.uid,
          fullname: fullname,
          email: email,
          address: address,
          phonenumber: phonenumber,
          role: role,
          username: username);

      await _firebaseFirestore
          .collection('users')
          .doc(cred.user!.uid)
          .set(user.toMap());
    } catch (e) {
      throw Exception(e);
    }
  }

  // list users with pagination
  Future<List<UserModel>> listUsers() async {
    List<UserModel> userList = [];
    try {
      await _firebaseFirestore.collection('users').get().then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          String uid = docSnapshot.get('uid');
          String fullname = docSnapshot.get('fullname');
          String email = docSnapshot.get('email');
          String role = docSnapshot.get('role');
          String address = docSnapshot.get('address');
          String phonenumber = docSnapshot.get('phonenumber');
          String username = docSnapshot.get('username');

          UserModel user = UserModel(
              uid: uid,
              fullname: fullname,
              email: email,
              address: address,
              phonenumber: phonenumber,
              role: role,
              username: username);

          userList.add(user);
        }
      });
      return userList;
    } catch (e) {
      throw Exception(e);
    }
  }

  // edit users
  Future<void> editUser(String uid, UserModel user) async {
    try {
      await _firebaseFirestore
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
      await _firebaseFirestore.collection('users').doc(uid).delete();
    } catch (e) {
      throw Exception(e);
    }
  }

  // signout
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }
}

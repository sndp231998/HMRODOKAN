import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hmrodokan/model/store.dart';
import 'package:hmrodokan/model/user.dart';

class FirebaseAuthHelper {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // get user instance
  Future<UserModel?> getUserInstance() async {
    try {
      User? currentUser = _firebaseAuth.currentUser;
      if (currentUser != null && currentUser.uid.isNotEmpty) {
        DocumentSnapshot documentSnapshot = await _firebaseFirestore
            .collection('users')
            .doc(currentUser.uid)
            .get();
        // Check if the document exists, has data, and the 'uid' field is not null
        if (documentSnapshot.exists) {
          return UserModel.fromSnap(documentSnapshot);
        }
      }
      return null;
    } catch (e) {
      // Log the error and return null
      throw Exception(e);
    }
  }

// login
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
    required String storeId,
  }) async {
    try {
      UserCredential cred = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      UserModel user = UserModel(
          uid: cred.user!.uid,
          fullname: fullname,
          storeId: storeId,
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
  Future<List<UserModel>> listUsers(String storeId, UserModel? lastUser) async {
    List<UserModel> userList = [];
    final Query<Map<String, dynamic>> queryRef;
    if (lastUser == null) {
      queryRef = _firebaseFirestore
          .collection('users')
          .where('storeId', isEqualTo: storeId);
    } else {
      var lastRef =
          await _firebaseFirestore.collection('users').doc(lastUser.uid).get();
      if (!lastRef.exists) throw Exception('no more data to load');

      queryRef = _firebaseFirestore
          .collection('users')
          .where('storeId', isEqualTo: storeId)
          .startAfterDocument(lastRef);
    }
    try {
      await queryRef.limit(20).get().then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          String uid = docSnapshot.get('uid');
          String storeId = docSnapshot.get('storeId');
          String fullname = docSnapshot.get('fullname');
          String email = docSnapshot.get('email');
          String role = docSnapshot.get('role');
          String address = docSnapshot.get('address');
          String phonenumber = docSnapshot.get('phonenumber');
          String username = docSnapshot.get('username');

          UserModel user = UserModel(
              uid: uid,
              storeId: storeId,
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
  Future<void> editUser(UserModel user) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .update(user.toMap());
    } catch (e) {
      throw Exception(e);
    }
  }

  // delete users
  Future<void> deleteUser(String storeId, String uid) async {
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

  // send password reset email
  Future<void> sendPasswordReset(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception(e);
    }
  }

// get number of counters
  Future<int> getNoCounters(String storeId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('users')
          .where('storeId', isEqualTo: storeId)
          .get();

      return querySnapshot.size;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<StoreModel?> getStoreInfo(String storeId) async {
    var querySnapshot = await _firebaseFirestore
        .collection('stores')
        .where('uid', isEqualTo: storeId)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      var documentSnapshot = querySnapshot.docs.first;

      return StoreModel.fromSnapshot(documentSnapshot);
    }
    return null;
  }
}

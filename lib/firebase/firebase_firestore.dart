import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hmrodokan/model/category.dart';
import 'package:hmrodokan/model/product.dart';
import 'package:uuid/uuid.dart';

class FirebaseFirestoreHelper {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();
  // ----------------------------------------------------------------------
  // Categories
  // save categories
  Future<void> createNewCategories(String title, String imageUrl) async {
    var randomId = _uuid.v4();

    CategoryModel categoryModel = CategoryModel(
        uid: randomId.toString(),
        imageUrl: imageUrl,
        isPrivate: false,
        title: title);
    await _firebaseFirestore
        .collection('categories')
        .doc(randomId.toString())
        .set(categoryModel.toMap());
  }

  // list categories
  Future<List<CategoryModel>> listCategories() async {
    List<CategoryModel> categoryList = [];

    await _firebaseFirestore
        .collection('categories')
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        String uid = docSnapshot.get('uid');
        String title = docSnapshot.get('title');
        String imageUrl = docSnapshot.get('imageUrl');
        bool isPrivate = docSnapshot.get('isPrivate');

        CategoryModel category = CategoryModel(
          uid: uid,
          title: title,
          imageUrl: imageUrl,
          isPrivate: isPrivate,
        );

        categoryList.add(category);
      }
    });
    return categoryList;
  }

  // edit categories
  Future<void> editCategories(CategoryModel category) async {
    await _firebaseFirestore
        .collection('categories')
        .doc(category.uid)
        .update({'title': category.title, 'imageUrl': category.imageUrl});
  }

  // delete categories
  Future<void> deleteCategories(CategoryModel category) async {
    await _firebaseFirestore
        .collection('categories')
        .doc(category.uid)
        .delete();
  }

  // -------------------------------------------------------------------------
  // Product
  // save Products @grab code
  Future<void> createNewProducts(
    String title,
    String storeId,
    String categoryId,
    int quantity,
    double purchasePrice,
    double sellingPrice,
    String imageUrl,
    String code,
  ) async {
    var randomId = _uuid.v4();
    ProductModel productModel = ProductModel(
      uid: randomId.toString(),
      imageUrl: imageUrl,
      title: title,
      storeId: storeId,
      categoryId: categoryId,
      quantity: quantity,
      purchasePrice: purchasePrice,
      sellingPrice: sellingPrice,
      scannerCode: code,
    );
    await _firebaseFirestore
        .collection('Products')
        .doc(randomId.toString())
        .set(productModel.toMap());
  }

  // list Products
  Future<List<ProductModel>> listProducts(String filterValue) async {
    List<ProductModel> productList = [];

    final queryRef;

    if (filterValue.isEmpty) {
      queryRef = _firebaseFirestore.collection('Products');
    } else {
      queryRef = _firebaseFirestore
          .collection('Products')
          .where('categoryId', isEqualTo: filterValue);
    }

    await queryRef.get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        String uid = docSnapshot.get('uid');
        String title = docSnapshot.get('title');
        String imageUrl = docSnapshot.get('imageUrl');
        String storeId = docSnapshot.get('storeId');
        String categoryId = docSnapshot.get('categoryId');
        int quantity = docSnapshot.get('quantity');
        double sellingPrice = docSnapshot.get('sellingPrice');
        double purchasePrice = docSnapshot.get('purchasePrice');
        String scannerCode = docSnapshot.get('scannerCode');

        ProductModel product = ProductModel(
          uid: uid,
          imageUrl: imageUrl,
          title: title,
          storeId: storeId,
          categoryId: categoryId,
          quantity: quantity,
          purchasePrice: purchasePrice,
          sellingPrice: sellingPrice,
          scannerCode: scannerCode,
        );

        productList.add(product);
      }
    });
    return productList;
  }

  // edit Products @grab code
  Future<void> editProducts(ProductModel product) async {
    await _firebaseFirestore.collection('Products').doc(product.uid).update({
      'title': product.title,
      'imageUrl': product.imageUrl,
      'categoryId': product.categoryId,
      'quantity': product.quantity,
      'purchasePrice': product.purchasePrice,
      'sellingPrice': product.sellingPrice,
    });
  }

  // delete Products
  Future<void> deleteProducts(ProductModel product) async {
    await _firebaseFirestore.collection('Products').doc(product.uid).delete();
  }

  // get number of products sold and total Sales
  Future<Map<String, int>> getSalesWithProducts(String storeId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('sales')
          .where('storeId', isEqualTo: storeId)
          .get();

      int totalProductsSold = querySnapshot.size;
      int totalSales = 0;

      for (var doc in querySnapshot.docs) {
        int totalBill = doc['paidAmount'] ?? 0;
        totalSales += totalBill;
      }

      return {'totalProductsSold': totalProductsSold, 'totalSales': totalSales};
    } catch (e) {
      throw Exception(e);
    }
  }

  // get out of stock products
  Future<int> getOutOfStock(String storeId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('Products')
          .where('storeId', isEqualTo: storeId)
          .get();
      int count = 0;
      for (var doc in querySnapshot.docs) {
        count += doc['quantity'] == 0 ? 1 : 0;
      }
      return count;
    } catch (e) {
      throw Exception(e);
    }
  }
}

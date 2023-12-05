import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hmrodokan/model/bill.dart';
import 'package:hmrodokan/model/category.dart';
import 'package:hmrodokan/model/product.dart';
import 'package:hmrodokan/model/sales.dart';
import 'package:hmrodokan/utils.dart';
import 'package:uuid/uuid.dart';

class FirebaseFirestoreHelper {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();
  // ----------------------------------------------------------------------
  // Categories
  // save categories
  Future<void> createNewCategories(
      String title, String imageUrl, String storeId) async {
    var randomId = _uuid.v4();

    CategoryModel categoryModel = CategoryModel(
        uid: randomId.toString(),
        imageUrl: imageUrl,
        isPrivate: false,
        storeId: storeId,
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
        String storeId = docSnapshot.get('storeId');

        CategoryModel category = CategoryModel(
          uid: uid,
          title: title,
          imageUrl: imageUrl,
          isPrivate: isPrivate,
          storeId: storeId,
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
  Future<List<ProductModel>> listProducts(
      String filterValue, String storeId) async {
    List<ProductModel> productList = [];

    final Query<Map<String, dynamic>> queryRef;

    if (filterValue.isEmpty) {
      queryRef = _firebaseFirestore
          .collection('Products')
          .where('storeId', isEqualTo: storeId);
    } else {
      queryRef = _firebaseFirestore
          .collection('Products')
          .where('storeId', isEqualTo: storeId)
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
      'scannerCode': product.scannerCode,
    });
  }

  // delete Products
  Future<void> deleteProducts(ProductModel product) async {
    await _firebaseFirestore.collection('Products').doc(product.uid).delete();
  }

  // get number of products sold and total Sales
  Future<Map<String, dynamic>> getSalesWithProducts(String storeId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('bills')
          .where('storeId', isEqualTo: storeId)
          .get();

      int totalProductsSold = 0;
      double totalSales = 0;
      double totalProfit = 0;

      for (var doc in querySnapshot.docs) {
        double totalBill = doc['totalAmount'] ?? 0;
        totalSales += totalBill;

        var salesSnapshot = await _firebaseFirestore
            .collection('sales')
            .where('billId', isEqualTo: doc['uid'])
            .get();

        for (var salesDoc in salesSnapshot.docs) {
          totalProductsSold += 1;
          totalProfit += salesDoc['soldAt'] - salesDoc['purchaseAt'];
        }
      }

      return {
        'totalProductsSold': totalProductsSold,
        'totalSales': totalSales,
        'totalProfit': totalProfit
      };
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

  // Search product through input
  Future<List<ProductModel>> fetchProductSuggestions(String query) async {
    List<ProductModel> productList = [];

    query = Utils().capitalizeFirstLetter(query.toLowerCase());

    await _firebaseFirestore
        .collection('Products')
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThan: '$query\uf8ff')
        .limit(10)
        .get()
        .then((querySnapshot) {
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

  // Search By Scanner
  Future<ProductModel?> searchByScanner(String code) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firebaseFirestore
        .collection('Products')
        .where('scannerCode', isEqualTo: code)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // If there's at least one matching document, return the first one.
      return ProductModel.fromSnapshot(querySnapshot.docs.first);
    } else {
      // If no matching documents found, return null or handle accordingly.
      return null;
    }
  }

  // -------------------------------------------------------------------
  // Bill
  // list bill
  Future<List<BillModel>> listBill(String counterId) async {
    List<BillModel> bills = [];

    try {
      await _firebaseFirestore
          .collection('bills')
          .where('counterId', isEqualTo: counterId)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          String uid = docSnapshot.get('uid');
          double totalAmount = docSnapshot.get('totalAmount');
          String storeId = docSnapshot.get('storeId');
          DateTime issueDate = docSnapshot.get('issueDate').toDate();
          double discount = docSnapshot.get('discount');
          double paidAmount = docSnapshot.get('paidAmount');
          String paymentMethod = docSnapshot.get('paymentMethod');

          BillModel newBill = BillModel(
              uid: uid,
              totalAmount: totalAmount,
              storeId: storeId,
              counterId: counterId,
              issueDate: issueDate,
              discount: discount,
              paidAmount: paidAmount,
              paymentMethod: paymentMethod);

          bills.add(newBill);
        }
      });
    } catch (e) {
      throw Exception(e);
    }
    return bills;
  }

  // list bill by store id
  Future<List<BillModel>> listBillByStore(String storeId) async {
    List<BillModel> bills = [];

    try {
      await _firebaseFirestore
          .collection('bills')
          .where('storeId', isEqualTo: storeId)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          String uid = docSnapshot.get('uid');
          double totalAmount = docSnapshot.get('totalAmount');
          String storeId = docSnapshot.get('storeId');
          String counterId = docSnapshot.get('counterId');
          DateTime issueDate = docSnapshot.get('issueDate').toDate();
          double discount = docSnapshot.get('discount');
          double paidAmount = docSnapshot.get('paidAmount');
          String paymentMethod = docSnapshot.get('paymentMethod');

          BillModel newBill = BillModel(
              uid: uid,
              totalAmount: totalAmount,
              storeId: storeId,
              counterId: counterId,
              issueDate: issueDate,
              discount: discount,
              paidAmount: paidAmount,
              paymentMethod: paymentMethod);

          bills.add(newBill);
        }
      });
    } catch (e) {
      throw Exception(e);
    }
    return bills;
  }

  // create bill
  Future<BillModel> createBill(
      String counterId,
      String storeId,
      double totalAmount,
      double discount,
      double paidAmount,
      String paymentMethod) async {
    var uid = _uuid.v4();
    DateTime issueDate = DateTime.now();
    uid = uid.toString();

    BillModel bill = BillModel(
        uid: uid,
        totalAmount: totalAmount,
        storeId: storeId,
        counterId: counterId,
        issueDate: issueDate,
        discount: discount,
        paidAmount: paidAmount,
        paymentMethod: paymentMethod);
    await _firebaseFirestore.collection('bills').doc(uid).set(bill.toMap());

    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection('bills').doc(bill.uid).get();

    BillModel updatedBill = BillModel.fromSnap(snapshot);

    return updatedBill;
  }

  // ------------------------------------------------------------------
  // Sales
  // list sales
  Future<List<SalesModel>> listSales(String billId) async {
    List<SalesModel> sales = [];

    await _firebaseFirestore
        .collection('sales')
        .where('billId', isEqualTo: billId)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        String uid = docSnapshot.get('uid');
        double soldAt = docSnapshot.get('soldAt');
        String productId = docSnapshot.get('productId');
        String name = docSnapshot.get('name');
        int quantity = docSnapshot.get('quantity');
        double discount = docSnapshot.get('discount');
        double purchaseAt = docSnapshot.get('purchaseAt');

        SalesModel newSales = SalesModel(
            uid: uid,
            soldAt: soldAt,
            billId: billId,
            productId: productId,
            name: name,
            quantity: quantity,
            discount: discount,
            purchaseAt: purchaseAt);

        sales.add(newSales);
      }
    });

    return sales;
  }

  // list sales by Storeid
  Future<List<SalesModel>> listSalesByStoreId(String storeId) async {
    List<String> billIdList = [];
    List<SalesModel> sales = [];

    await _firebaseFirestore
        .collection('bills')
        .where('storeId', isEqualTo: storeId)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        String uid = docSnapshot.get('uid');
        billIdList.add(uid);
      }
    });

    for (var billId in billIdList) {
      await _firebaseFirestore
          .collection('sales')
          .where('billId', isEqualTo: billId)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          String uid = docSnapshot.get('uid');
          double soldAt = docSnapshot.get('soldAt');
          String productId = docSnapshot.get('productId');
          String name = docSnapshot.get('name');
          int quantity = docSnapshot.get('quantity');
          double discount = docSnapshot.get('discount');
          double purchaseAt = docSnapshot.get('purchaseAt');

          SalesModel newSales = SalesModel(
              uid: uid,
              soldAt: soldAt,
              billId: billId,
              productId: productId,
              name: name,
              quantity: quantity,
              discount: discount,
              purchaseAt: purchaseAt);

          sales.add(newSales);
        }
      });
    }

    return sales;
  }

  // create sales
  Future<void> createSales(String billId, String productId, double soldAt,
      double purchaseAt, String name, int quantity) async {
    var uid = _uuid.v4();
    uid = uid.toString();
    SalesModel sales = SalesModel(
        uid: uid,
        soldAt: soldAt,
        billId: billId,
        productId: productId,
        name: name,
        quantity: quantity,
        discount: 0,
        purchaseAt: purchaseAt);
    await _firebaseFirestore
        .collection('Products')
        .doc(productId)
        .update({'quantity': FieldValue.increment(-quantity)});
    await _firebaseFirestore.collection('sales').doc(uid).set(sales.toMap());
  }
}

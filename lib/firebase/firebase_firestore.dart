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
    String unit,
    double quantity,
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
      unit: unit,
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
      String filterValue, String storeId, ProductModel? lastProduct) async {
    List<ProductModel> productList = [];

    final Query<Map<String, dynamic>> queryRef;

    if (filterValue.isEmpty) {
      if (lastProduct == null) {
        queryRef = _firebaseFirestore
            .collection('Products')
            .where('storeId', isEqualTo: storeId);
      } else {
        var lastRef = await _firebaseFirestore
            .collection('Products')
            .doc(lastProduct.uid)
            .get();
        if (!lastRef.exists) throw Exception('no more data to load');
        queryRef = _firebaseFirestore
            .collection('Products')
            .where('storeId', isEqualTo: storeId)
            .startAfterDocument(lastRef);
      }
    } else {
      if (lastProduct == null) {
        queryRef = _firebaseFirestore
            .collection('Products')
            .where('storeId', isEqualTo: storeId)
            .where('categoryId', isEqualTo: filterValue);
      } else {
        var lastRef = await _firebaseFirestore
            .collection('Products')
            .doc(lastProduct.uid)
            .get();
        if (!lastRef.exists) throw Exception('no more data to load');

        queryRef = _firebaseFirestore
            .collection('Products')
            .where('storeId', isEqualTo: storeId)
            .where('categoryId', isEqualTo: filterValue)
            .orderBy('uid')
            .startAfterDocument(lastRef);
      }
    }

    await queryRef.limit(20).get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        String uid = docSnapshot.get('uid');
        String title = docSnapshot.get('title');
        String imageUrl = docSnapshot.get('imageUrl');
        String storeId = docSnapshot.get('storeId');
        String categoryId = docSnapshot.get('categoryId');
        double quantity = double.parse(docSnapshot.get('quantity').toString());
        String unit = docSnapshot.get('unit');
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
          unit: unit,
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
      'unit': product.unit,
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
      double dueAmount = 0;

      for (var doc in querySnapshot.docs) {
        if (doc['isDue']) {
          totalSales += double.parse(doc['paidAmount'].toString());
          dueAmount += double.parse(doc['totalAmount'].toString()) -
              double.parse(doc['paidAmount'].toString());
          continue;
        }
        double totalBill = double.parse(doc['totalAmount'].toString());
        totalSales += totalBill;

        var salesSnapshot = await _firebaseFirestore
            .collection('sales')
            .where('billId', isEqualTo: doc['uid'])
            .get();

        for (var salesDoc in salesSnapshot.docs) {
          totalProductsSold += 1;
          totalProfit += double.parse(salesDoc['soldAt'].toString()) -
              double.parse(salesDoc['purchaseAt'].toString());
        }
      }

      return {
        'totalProductsSold': totalProductsSold,
        'totalSales': totalSales,
        'totalProfit': totalProfit,
        'dueAmount': dueAmount
      };
    } catch (e) {
      throw Exception(e);
    }
  }

  // list Products
  Future<List<ProductModel>> listOutOfStock(
      String storeId, ProductModel? lastProduct) async {
    List<ProductModel> productList = [];

    final Query<Map<String, dynamic>> queryRef;

    if (lastProduct == null) {
      queryRef = _firebaseFirestore
          .collection('Products')
          .where('storeId', isEqualTo: storeId)
          .where('quantity', isEqualTo: 0);
    } else {
      var lastRef = await _firebaseFirestore
          .collection('Products')
          .doc(lastProduct.uid)
          .get();

      if (!lastRef.exists) throw Exception('no more data to load');
      queryRef = _firebaseFirestore
          .collection('Products')
          .where('storeId', isEqualTo: storeId)
          .where('quantity', isEqualTo: 0)
          .startAfterDocument(lastRef);
    }

    await queryRef.limit(20).get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        String uid = docSnapshot.get('uid');
        String title = docSnapshot.get('title');
        String imageUrl = docSnapshot.get('imageUrl');
        String storeId = docSnapshot.get('storeId');
        String categoryId = docSnapshot.get('categoryId');
        double quantity = double.parse(docSnapshot.get('quantity').toString());
        String unit = docSnapshot.get('unit');
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
          unit: unit,
          purchasePrice: purchasePrice,
          sellingPrice: sellingPrice,
          scannerCode: scannerCode,
        );

        productList.add(product);
      }
    });
    return productList;
  }

  // get out of stock products
  Future<int> getOutOfStock(String storeId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('Products')
          .where('storeId', isEqualTo: storeId)
          .where('quantity', isEqualTo: 0)
          .get();
      return querySnapshot.size;
    } catch (e) {
      throw Exception(e);
    }
  }

  // Search product through input
  Future<List<ProductModel>> fetchProductSuggestions(String query) async {
    List<ProductModel> productList = [];
    String searchQueryType = 'title';
    try {
      int.parse(query);
      searchQueryType = 'scannerCode';
    } catch (e) {
      // print('String ' + query);
      searchQueryType = 'title';
    }
    query = Utils().capitalizeFirstLetter(query.toLowerCase());

    await _firebaseFirestore
        .collection('Products')
        .where(searchQueryType, isGreaterThanOrEqualTo: query)
        .where(searchQueryType, isLessThan: '$query\uf8ff')
        .limit(20)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        String uid = docSnapshot.get('uid');
        String title = docSnapshot.get('title');
        String imageUrl = docSnapshot.get('imageUrl');
        String storeId = docSnapshot.get('storeId');
        String categoryId = docSnapshot.get('categoryId');
        double quantity = double.parse(docSnapshot.get('quantity').toString());
        String unit = docSnapshot.get('unit');
        double sellingPrice = docSnapshot.get('sellingPrice');
        double purchasePrice = docSnapshot.get('purchasePrice');
        String scannerCode = docSnapshot.get('scannerCode');
        if (quantity == 0) continue;
        ProductModel product = ProductModel(
          uid: uid,
          imageUrl: imageUrl,
          title: title,
          storeId: storeId,
          categoryId: categoryId,
          unit: unit,
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
  Future<List<BillModel>> listBill(
      String counterId, BillModel? lastBill) async {
    List<BillModel> bills = [];

    final Query<Map<String, dynamic>> queryRef;

    if (lastBill == null) {
      queryRef = _firebaseFirestore
          .collection('bills')
          .where('counterId', isEqualTo: counterId)
          .orderBy('issueDate', descending: true);
    } else {
      var lastBillRef =
          await _firebaseFirestore.collection('bills').doc(lastBill.uid).get();
      if (lastBillRef.exists) {
        queryRef = _firebaseFirestore
            .collection('bills')
            .where('counterId', isEqualTo: counterId)
            .orderBy('issueDate', descending: true)
            .startAfterDocument(lastBillRef);
      } else {
        throw Exception('No more data to load');
      }
    }

    try {
      await queryRef.limit(20).get().then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          String uid = docSnapshot.get('uid');
          double totalAmount =
              double.parse(docSnapshot.get('totalAmount').toString());
          String storeId = docSnapshot.get('storeId');
          DateTime issueDate = docSnapshot.get('issueDate').toDate();
          double discount =
              double.parse(docSnapshot.get('discount').toString());
          double paidAmount =
              double.parse(docSnapshot.get('paidAmount').toString());
          String paymentMethod = docSnapshot.get('paymentMethod');
          String name = docSnapshot.get('name');
          String phonenumber = docSnapshot.get('phonenumber');
          bool isDue = docSnapshot.get('isDue');

          BillModel newBill = BillModel(
            uid: uid,
            totalAmount: totalAmount,
            storeId: storeId,
            counterId: counterId,
            issueDate: issueDate,
            discount: discount,
            paidAmount: paidAmount,
            paymentMethod: paymentMethod,
            name: name,
            phonenumber: phonenumber,
            isDue: isDue,
          );

          bills.add(newBill);
        }
      });
    } catch (e) {
      throw Exception(e);
    }
    return bills;
  }

  // list bill by store id
  Future<List<BillModel>> listBillByStore(
      String storeId, BillModel? lastBill) async {
    List<BillModel> bills = [];

    final Query<Map<String, dynamic>> queryRef;

    if (lastBill == null) {
      queryRef = _firebaseFirestore
          .collection('bills')
          .where('storeId', isEqualTo: storeId);
    } else {
      var lastBillRef =
          await _firebaseFirestore.collection('bills').doc(lastBill.uid).get();
      if (lastBillRef.exists) {
        queryRef = _firebaseFirestore
            .collection('bills')
            .where('storeId', isEqualTo: storeId)
            .startAfterDocument(lastBillRef);
      } else {
        throw Exception('No more data to load');
      }
    }

    try {
      await queryRef.limit(10).get().then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          String uid = docSnapshot.get('uid');
          double totalAmount =
              double.parse(docSnapshot.get('totalAmount').toString());
          String storeId = docSnapshot.get('storeId');
          String counterId = docSnapshot.get('counterId');
          DateTime issueDate = docSnapshot.get('issueDate').toDate();
          double discount =
              double.parse(docSnapshot.get('discount').toString());
          double paidAmount =
              double.parse(docSnapshot.get('paidAmount').toString());
          String paymentMethod = docSnapshot.get('paymentMethod');
          String name = docSnapshot.get('name');
          String phonenumber = docSnapshot.get('phonenumber');
          bool isDue = docSnapshot.get('isDue');

          BillModel newBill = BillModel(
            uid: uid,
            totalAmount: totalAmount,
            storeId: storeId,
            counterId: counterId,
            issueDate: issueDate,
            discount: discount,
            paidAmount: paidAmount,
            paymentMethod: paymentMethod,
            name: name,
            phonenumber: phonenumber,
            isDue: isDue,
          );

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
      String paymentMethod,
      String name,
      String phonenumber) async {
    var uid = _uuid.v4();
    DateTime issueDate = DateTime.now();
    uid = uid.toString();
    bool isDue = false;
    if (paidAmount < totalAmount - discount) isDue = true;

    BillModel bill = BillModel(
      uid: uid,
      totalAmount: totalAmount,
      storeId: storeId,
      counterId: counterId,
      issueDate: issueDate,
      discount: discount,
      paidAmount: paidAmount,
      paymentMethod: paymentMethod,
      name: name,
      phonenumber: phonenumber,
      isDue: isDue,
    );
    await _firebaseFirestore.collection('bills').doc(uid).set(bill.toMap());

    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection('bills').doc(bill.uid).get();

    BillModel updatedBill = BillModel.fromSnap(snapshot);

    return updatedBill;
  }

  // update bill
  Future<void> updateBill(BillModel bill) async {
    await _firebaseFirestore
        .collection('bills')
        .doc(bill.uid)
        .update(bill.toMap());
  }

  // count due bill
  Future<int> countDue(String storeId) async {
    var querySnapshot = await _firebaseFirestore
        .collection('bills')
        .where('storeId', isEqualTo: storeId)
        .where('isDue', isEqualTo: true)
        .get();

    return querySnapshot.size;
  }

  // Due bill
  Future<List<BillModel>> listDueBill(
      String storeId, BillModel? lastBill) async {
    List<BillModel> dueLists = [];
    final Query<Map<String, dynamic>> queryRef;
    if (lastBill == null) {
      queryRef = _firebaseFirestore
          .collection('bills')
          .where('storeId', isEqualTo: storeId)
          .where('isDue', isEqualTo: true);
    } else {
      var lastRef =
          await _firebaseFirestore.collection('bills').doc(lastBill.uid).get();
      if (lastRef.exists) {
        queryRef = _firebaseFirestore
            .collection('bills')
            .where('storeId', isEqualTo: storeId)
            .where('isDue', isEqualTo: true)
            .startAfterDocument(lastRef);
      } else {
        throw Exception('No more data to load');
      }
    }

    await queryRef.limit(20).get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        String uid = docSnapshot.get('uid');
        double totalAmount = docSnapshot.get('totalAmount');
        String storeId = docSnapshot.get('storeId');
        String counterId = docSnapshot.get('counterId');
        DateTime issueDate = docSnapshot.get('issueDate').toDate();
        double discount = docSnapshot.get('discount');
        double paidAmount = docSnapshot.get('paidAmount');
        String paymentMethod = docSnapshot.get('paymentMethod');
        String name = docSnapshot.get('name');
        String phonenumber = docSnapshot.get('phonenumber');
        bool isDue = docSnapshot.get('isDue');

        BillModel newBill = BillModel(
          uid: uid,
          totalAmount: totalAmount,
          storeId: storeId,
          counterId: counterId,
          issueDate: issueDate,
          discount: discount,
          paidAmount: paidAmount,
          paymentMethod: paymentMethod,
          name: name,
          phonenumber: phonenumber,
          isDue: isDue,
        );

        dueLists.add(newBill);
      }
    });
    return dueLists;
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
        String storeId = docSnapshot.get('storeId');
        String name = docSnapshot.get('name');
        double quantity = double.parse(docSnapshot.get('quantity').toString());
        double discount = docSnapshot.get('discount');
        double purchaseAt = docSnapshot.get('purchaseAt');

        SalesModel newSales = SalesModel(
            uid: uid,
            soldAt: soldAt,
            billId: billId,
            productId: productId,
            storeId: storeId,
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
  Future<List<SalesModel>> listSalesByStoreId(
      String storeId, SalesModel? lastSales) async {
    List<SalesModel> sales = [];

    final Query<Map<String, dynamic>> queryRef;

    if (lastSales == null) {
      queryRef = _firebaseFirestore
          .collection('sales')
          .where('storeId', isEqualTo: storeId);
    } else {
      var lastSalesRef =
          await _firebaseFirestore.collection('sales').doc(lastSales.uid).get();
      if (lastSalesRef.exists) {
        queryRef = _firebaseFirestore
            .collection('sales')
            .where('storeId', isEqualTo: storeId)
            .startAfterDocument(lastSalesRef);
      } else {
        throw Exception('No more data to load');
      }
    }

    await queryRef.limit(10).get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        String uid = docSnapshot.get('uid');
        double soldAt = double.parse(docSnapshot.get('soldAt').toString());
        String billId = docSnapshot.get('billId');
        String productId = docSnapshot.get('productId');
        String name = docSnapshot.get('name');
        String storeId = docSnapshot.get('storeId');
        double quantity = double.parse(docSnapshot.get('quantity').toString());
        double discount = double.parse(docSnapshot.get('discount').toString());
        double purchaseAt =
            double.parse(docSnapshot.get('purchaseAt').toString());

        SalesModel newSales = SalesModel(
            uid: uid,
            soldAt: soldAt,
            billId: billId,
            productId: productId,
            storeId: storeId,
            name: name,
            quantity: quantity,
            discount: discount,
            purchaseAt: purchaseAt);

        sales.add(newSales);
      }
    });

    return sales;
  }

  // create sales
  Future<void> createSales(String billId, String productId, double soldAt,
      double purchaseAt, String name, double quantity, String storeId) async {
    var uid = _uuid.v4();
    uid = uid.toString();
    SalesModel sales = SalesModel(
        uid: uid,
        soldAt: soldAt,
        billId: billId,
        productId: productId,
        storeId: storeId,
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

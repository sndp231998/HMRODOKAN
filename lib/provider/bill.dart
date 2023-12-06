import 'package:flutter/material.dart';
import 'package:hmrodokan/model/product.dart';

class BillProvider extends ChangeNotifier {
  List<ProductModel> productList = [];
  List<ProductModel> originalProductList = [];
  double totalAmount = 0;

  void addProduct(ProductModel product) {
    bool doExist = false;

    // update the existing product
    for (ProductModel prod in productList) {
      if (product.uid == prod.uid) {
        if (checkQuantity(product)) {
          // update quantity
          prod.quantity += 1;
          doExist = true;
          break;
        }
      }
    }

    // add new product
    if (!doExist) {
      // adding original product list
      originalProductList.add(ProductModel(
          uid: product.uid,
          title: product.title,
          storeId: product.storeId,
          categoryId: product.categoryId,
          unit: product.unit,
          imageUrl: product.imageUrl,
          quantity: product.quantity,
          purchasePrice: product.purchasePrice,
          sellingPrice: product.sellingPrice,
          scannerCode: product.scannerCode));
      // modifying the list
      product.quantity = 1;
      productList.add(product);
    }
    calculateTotalAmount();

    notifyListeners();
  }

  void updateQuantity(ProductModel product, bool status) {
    for (ProductModel prod in productList) {
      if (product.uid == prod.uid) {
        if (status) {
          // increase
          if (checkQuantity(prod)) prod.quantity += 1;
        } else {
          // decrease
          if (prod.quantity == 1) {
            return removeProduct(product);
          }
          prod.quantity -= 1;
        }
      }
    }
    calculateTotalAmount();

    notifyListeners();
  }

  void removeProduct(ProductModel product) {
    originalProductList.removeWhere((element) => element.uid == product.uid);
    productList.removeWhere((item) => item.uid == product.uid);
    calculateTotalAmount();
    notifyListeners();
  }

  void clearBill() {
    originalProductList = [];
    productList = [];
    totalAmount = 0;

    notifyListeners();
  }

  // calculate total amount
  void calculateTotalAmount() {
    totalAmount = 0;
    for (ProductModel product in productList) {
      totalAmount += product.quantity * product.sellingPrice;
    }
  }

  // check the quanity value in original product list
  bool checkQuantity(ProductModel currentProduct) {
    for (ProductModel originalProduct in originalProductList) {
      if (originalProduct.uid == currentProduct.uid &&
          originalProduct.quantity > currentProduct.quantity) {
        return true;
      }
    }

    return false;
  }
}

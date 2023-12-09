import 'package:flutter/material.dart';
import 'package:hmrodokan/components/admin_product.dart';
import 'package:hmrodokan/firebase/firebase_firestore.dart';
import 'package:hmrodokan/model/product.dart';
import 'package:hmrodokan/provider/products.dart';
import 'package:hmrodokan/provider/user.dart';
import 'package:hmrodokan/utils.dart';
import 'package:provider/provider.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  FirebaseFirestoreHelper firebaseFirestoreHelper = FirebaseFirestoreHelper();

  late final ScrollController _controller = ScrollController();

  bool isLoading = true;
  List<ProductModel> productsList = [];

  Future<void> listProducts(
      BuildContext context, ProductModel? lastProduct) async {
    ProductsProvider productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      List<ProductModel> fetchList = [];
      fetchList = await firebaseFirestoreHelper.listProducts(
          productsProvider.getFilterValue,
          userProvider.getUser.storeId,
          lastProduct);
      setState(() {
        if (lastProduct != null) {
          productsList.addAll(fetchList);
        } else {
          productsList = fetchList;
        }
      });
    } catch (e) {
      if (context.mounted) Utils().toastor(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  void handleScroll() {
    if (isLoading) return;
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      listProducts(context, productsList[productsList.length - 1]);
    }
  }

  @override
  void initState() {
    listProducts(context, null);
    _controller.addListener(handleScroll);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(handleScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return productsList.isNotEmpty
        ? RefreshIndicator(
            onRefresh: () {
              return listProducts(context, null);
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              controller: _controller,
              child: Column(
                children: [
                  for (ProductModel products in productsList)
                    AdminProduct(products: products),
                ],
              ),
            ),
          )
        : const Center(
            child: Text('Add Products to view'),
          );
  }
}

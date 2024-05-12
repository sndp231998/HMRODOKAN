import 'package:flutter/material.dart';
import 'package:hmrodokan/components/admin_product.dart';
import 'package:hmrodokan/firebase/firebase_firestore.dart';
import 'package:hmrodokan/model/product.dart';
import 'package:hmrodokan/provider/user.dart';
import 'package:hmrodokan/utils.dart';
import 'package:provider/provider.dart';

class FilteredProduct extends StatefulWidget {
  final String filterValue;
  const FilteredProduct({super.key, required this.filterValue});

  @override
  State<FilteredProduct> createState() => _FilteredProductState();
}

class _FilteredProductState extends State<FilteredProduct> {
  FirebaseFirestoreHelper firebaseFirestoreHelper = FirebaseFirestoreHelper();

  late final ScrollController _controller = ScrollController();

  bool isLoading = true;
  bool isMoreLoading = false;
  List<ProductModel> productsList = [];

  void toggleMoreLoading(bool value) {
    setState(() {
      isMoreLoading = value;
    });
  }

  void toggleLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> listProducts(
      BuildContext context, ProductModel? lastProduct) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    try {
      List<ProductModel> fetchList = [];
      fetchList = await firebaseFirestoreHelper.listProducts(
          widget.filterValue, userProvider.getUser.storeId, lastProduct);
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
    toggleLoading(false);
    toggleMoreLoading(false);
  }

  void handleScroll() {
    if (!isMoreLoading &&
        _controller.position.pixels == _controller.position.maxScrollExtent) {
      toggleMoreLoading(true);
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

    return Scaffold(
        appBar: AppBar(
          title: const Text('Filtered Products'),
        ),
        body: productsList.isNotEmpty
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
                      if (isMoreLoading)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              )
            : const Center(
                child: Text('Add Products to view'),
              ));
  }
}
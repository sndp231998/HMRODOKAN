import 'package:flutter/material.dart';
import 'package:hmrodokan/components/category_card.dart';
import 'package:hmrodokan/firebase/firebase_firestore.dart';
import 'package:hmrodokan/model/category.dart';
import 'package:hmrodokan/utils.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  FirebaseFirestoreHelper firebaseFirestoreHelper = FirebaseFirestoreHelper();

  bool isLoading = true;
  List<CategoryModel> categoryList = [];

  Future<void> listCategories(BuildContext context) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      List<CategoryModel> fetchList = [];
      fetchList = await firebaseFirestoreHelper.listCategories();
      if (mounted) {
        setState(() {
          categoryList = fetchList;
        });
      }
    } catch (e) {
      if (context.mounted) Utils().toastor(context, e.toString());
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    listCategories(context);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return categoryList.isNotEmpty
        ? RefreshIndicator(
            onRefresh: () {
              return listCategories(context);
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(crossAxisCount: 2, children: [
                for (CategoryModel category in categoryList)
                  CategoryCard(
                    category: category,
                  ),
              ]),
            ),
          )
        : (const Center(
            child: Text('Add some categories to view here'),
          ));
  }
}

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
  List<CategoryModel> _categories = [];

  Future<void> getCategoryList() async {
    FirebaseFirestoreHelper firebaseFirestoreHelper = FirebaseFirestoreHelper();
    List<CategoryModel> categoryList =
        await firebaseFirestoreHelper.listCategories();
    setState(() {
      _categories = categoryList;
    });
  }

  @override
  void initState() {
    super.initState();

    getCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return _categories.isNotEmpty
        ? Container(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(crossAxisCount: 2, children: [
              for (CategoryModel category in _categories)
                CategoryCard(
                  category: category,
                ),
            ]),
          )
        : (const Center(
            child: Text('Add some categories to view here'),
          ));
  }
}

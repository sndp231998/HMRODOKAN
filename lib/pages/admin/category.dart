import 'package:flutter/material.dart';
import 'package:hmrodokan/components/category_card.dart';

class Category extends StatelessWidget {
  const Category({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: GridView.count(crossAxisCount: 3, children: [
        CategoryCard(),
        CategoryCard(),
        CategoryCard(),
        CategoryCard(),
        CategoryCard(),
      ]),
    );
  }
}

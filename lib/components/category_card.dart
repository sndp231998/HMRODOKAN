import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            Color.fromARGB(255, 57, 211, 136),
            Colors.green,
          ]),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: Colors.black38,
            width: 1.0,
          )),
      child: const Column(
        children: [
          // more button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.edit,
                size: 18,
                color: Colors.white,
              ),
              Icon(
                Icons.delete,
                size: 18,
                color: Colors.white,
              ),
            ],
          ),

          // name of category
          Expanded(
              child: Center(
                  child: Text(
            'Noodles',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17,
              color: Colors.white,
            ),
          ))),
        ],
      ),
    );
  }
}

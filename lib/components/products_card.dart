import 'package:flutter/material.dart';

class ProductsCard extends StatelessWidget {
  const ProductsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black26, width: 1.0)),
      child: Row(
        children: [
          // image
          Image.asset(
            'assets/images/admin.png',
            width: 30,
          ),
          // name & quantity
          Expanded(
            child: Container(
              // color: Colors.red,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name of the Product'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: null,
                        icon: Icon(Icons.exposure_minus_1),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('1'),
                      SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        onPressed: null,
                        icon: Icon(Icons.plus_one),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          // delete
          const Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}

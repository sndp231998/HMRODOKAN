import 'package:flutter/material.dart';
import 'package:hmrodokan/model/product.dart';

class InventoryCard extends StatelessWidget {
  final ProductModel product;
  const InventoryCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      decoration: BoxDecoration(
          border: Border.all(
        color: Colors.black38,
        width: 1.0,
      )),
      child: Row(
        children: [
          // image
          Center(
            child: Image.network(
              product.imageUrl,
              height: 50,
              width: 30,
            ),
          ),
          // name & price
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Quantity. ${product.quantity}pc',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

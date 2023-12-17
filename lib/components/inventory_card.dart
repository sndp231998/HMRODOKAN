import 'package:flutter/material.dart';
import 'package:hmrodokan/components/image_widget.dart';
import 'package:hmrodokan/model/product.dart';

class InventoryCard extends StatelessWidget {
  final ProductModel product;
  const InventoryCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    bool validURL = Uri.tryParse(product.imageUrl)?.isAbsolute ?? false;

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
            child: ImageWidget(imageUrl: product.imageUrl, validURL: validURL),
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
                  'Quantity: ${product.unit == 'pc' ? product.quantity.toString().split('.')[0] : product.quantity.toString()}${product.unit}',
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

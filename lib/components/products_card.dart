import 'package:flutter/material.dart';
import 'package:hmrodokan/components/image_widget.dart';
import 'package:hmrodokan/model/product.dart';
import 'package:hmrodokan/provider/bill.dart';
import 'package:provider/provider.dart';

class ProductsCard extends StatelessWidget {
  final ProductModel product;
  const ProductsCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    BillProvider billProvider =
        Provider.of<BillProvider>(context, listen: true);

    bool validURL = Uri.tryParse(product.imageUrl)?.isAbsolute ?? false;
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black26, width: 1.0)),
      child: Row(
        children: [
          // image
          ImageWidget(
            imageUrl: product.imageUrl,
            validURL: validURL,
          ),
          // name & quantity
          Expanded(
            child: Column(
              children: [
                Text(
                  product.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        billProvider.updateQuantity(product, false);
                      },
                      icon: const Icon(Icons.arrow_downward),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.black54,
                        width: 1.0,
                      )),
                      child: Row(children: [
                        Text(
                          product.unit == 'pc'
                              ? product.quantity.toString().split('.')[0]
                              : product.quantity.toString(),
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(product.unit),
                      ]),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      onPressed: () {
                        billProvider.updateQuantity(product, true);
                      },
                      icon: const Icon(Icons.arrow_upward),
                    ),
                  ],
                ),
                Text(
                  'Rs. ${product.sellingPrice}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          // delete
          IconButton(
            onPressed: () {
              billProvider.removeProduct(product);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

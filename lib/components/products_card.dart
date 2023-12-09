import 'package:flutter/material.dart';
import 'package:hmrodokan/model/product.dart';
import 'package:hmrodokan/provider/bill.dart';
import 'package:provider/provider.dart';

class ProductsCard extends StatefulWidget {
  final ProductModel product;
  const ProductsCard({super.key, required this.product});

  @override
  State<ProductsCard> createState() => _ProductsCardState();
}

class _ProductsCardState extends State<ProductsCard> {
  @override
  Widget build(BuildContext context) {
    BillProvider billProvider =
        Provider.of<BillProvider>(context, listen: true);

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black26, width: 1.0)),
      child: Row(
        children: [
          // image
          Image.network(
            widget.product.imageUrl,
            width: 50,
          ),
          // name & quantity
          Expanded(
            child: Column(
              children: [
                Text(
                  widget.product.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        billProvider.updateQuantity(widget.product, false);
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
                          widget.product.unit == 'pc'
                              ? widget.product.quantity.toString().split('.')[0]
                              : widget.product.quantity.toString(),
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(widget.product.unit),
                      ]),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      onPressed: () {
                        billProvider.updateQuantity(widget.product, true);
                      },
                      icon: const Icon(Icons.arrow_upward),
                    ),
                  ],
                ),
                Text(
                  'Rs. ${widget.product.sellingPrice}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          // delete
          IconButton(
            onPressed: () {
              billProvider.removeProduct(widget.product);
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

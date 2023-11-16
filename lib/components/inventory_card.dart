import 'package:flutter/material.dart';

class InventoryCard extends StatelessWidget {
  const InventoryCard({super.key});

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
            child: Image.asset(
              'assets/images/samayang.jpeg',
              height: 50,
              width: 30,
            ),
          ),
          // name & price
          const SizedBox(
            width: 20,
          ),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name of the Product goes here',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Quantity. 1100pc',
                  textAlign: TextAlign.start,
                  style: TextStyle(
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

import 'package:flutter/material.dart';
import 'package:hmrodokan/components/admin_product.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          // container for each product display
          AdminProduct(),
        ],
      ),
    );
  }
}

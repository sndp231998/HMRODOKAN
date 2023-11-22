import 'package:flutter/material.dart';
import 'package:hmrodokan/components/inventory_card.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // top nav
          Positioned(
            top: 0,
            left: 0,
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(
                    color: Colors.black38,
                    width: 1.0,
                  ))),
              child: Row(
                children: [
                  // back arrow
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back),
                  ),

                  const SizedBox(
                    width: 10,
                  ),
                  // search
                  Expanded(
                    child: SearchAnchor.bar(
                      suggestionsBuilder: (context, controller) {
                        return List<ListTile>.generate(5, (int index) {
                          final String item = 'item $index';
                          return ListTile(
                            title: Text(item),
                            onTap: () {
                              setState(() {
                                controller.closeView(item);
                              });
                            },
                          );
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),

                  // scan qr/bar code
                  GestureDetector(
                    onTap: () {
                      // pop out modal for qr scan
                    },
                    child: const Icon(Icons.qr_code_scanner),
                  )
                ],
              ),
            ),
          ),
          // body
          Positioned(
            top: 100,
            left: 0,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const SingleChildScrollView(
              child: Column(
                children: [
                  InventoryCard(),
                  InventoryCard(),
                  InventoryCard(),
                  InventoryCard(),
                  InventoryCard(),
                  InventoryCard(),
                  InventoryCard(),
                  InventoryCard(),
                  InventoryCard(),
                  InventoryCard(),
                  InventoryCard(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

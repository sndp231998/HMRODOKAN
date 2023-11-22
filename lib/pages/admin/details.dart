import 'package:flutter/material.dart';

class Details extends StatelessWidget {
  final String productname;
  //final double productprice;
  final double quentity;
  final double selling;
  final double purchased;
  final double tax;
  const Details({
    Key? key,
    required this.productname,
    //required this.productprice,
    required this.quentity,
    required this.selling,
    required this.purchased,
    required this.tax,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.account_balance_wallet_outlined),
              title: Text(productname),
            ),
            // ListTile(
            //   leading: Icon(Icons.attach_money),
            //   title: Text("Product Price: $productprice"),
            // ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet_outlined),
              title: Text("Quentity: $quentity"),
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet_outlined),
              title: Text("Selling : $selling"),
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet_outlined),
              title: Text("Purchased : $purchased"),
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet_outlined),
              title: Text("Tax : $tax"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hmrodokan/pages/admin/details.dart';

class MyForm extends StatefulWidget {
  const MyForm({Key? key}) : super(key: key);

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  var _productname;
  // var _productprice;
  var _quentity;
  var _sp, _pp, _tax;
  var _qrCodeData = '';

  void _updateText(val) {
    setState(() {
      _productname = val;
    });
  }

  // void _updatePrice(val) {
  //   setState(() {
  //     _productprice = val;
  //   });
  // }

  void _updateQuentitye(val) {
    setState(() {
      _quentity = val;
    });
  }

  void _updateSellingPrice(val) {
    setState(() {
      _sp = val;
    });
  }

  void _updatePurchasedPrice(val) {
    setState(() {
      _pp = val;
    });
  }

//QR---------------------------------------------------------------------------

  void _generateQRCode() {
    final qrCodeData =
        "Product: $_productname\nQuantity: $_quentity\nSelling Price: $_sp\nPurchased Price: $_pp\nTax: $_tax";
    setState(() {
      _qrCodeData = qrCodeData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Add Item"),
            backgroundColor: Colors.green,
            centerTitle: true),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              TextFormField(
                onChanged: (val) {
                  _updateText(val);
                },
                decoration: const InputDecoration(
                    labelText: 'Product Name',
                    prefixIcon: Icon(Icons.verified_user_outlined),
                    border: OutlineInputBorder()),
              ),
              //Text("Product Name is $_productname")

              const SizedBox(
                height: 20.0,
              ),

//quentity-----------------------------------------------------
              TextFormField(
                onChanged: (val) {
                  _updateText(val);
                },
                decoration: const InputDecoration(
                    labelText: 'Quentity',
                    prefixIcon: Icon(Icons.verified_user_outlined),
                    border: OutlineInputBorder()),
              ),
              //Text("Product Name is $_productname")

              const SizedBox(
                height: 20.0,
              ),

//prchasing price ----------------------------------------------
              TextFormField(
                onChanged: (val) {
                  _updateText(val);
                },
                decoration: const InputDecoration(
                    labelText: 'Purchased Price',
                    prefixIcon: Icon(Icons.verified_user_outlined),
                    border: OutlineInputBorder()),
              ),
              //Text("Product Name is $_productname")

              const SizedBox(
                height: 20.0,
              ),

//Selling prince----------------------------------------------
              TextFormField(
                onChanged: (val) {
                  _updateText(val);
                },
                decoration: const InputDecoration(
                    labelText: 'Selling Price',
                    prefixIcon: Icon(Icons.verified_user_outlined),
                    border: OutlineInputBorder()),
              ),
              //Text("Product Name is $_productname")

              const SizedBox(
                height: 20.0,
              ),

//Tax----------------------------------------------------
              TextFormField(
                onChanged: (val) {
                  _updateText(val);
                },
                decoration: const InputDecoration(
                    labelText: 'Tax(%)',
                    prefixIcon: Icon(Icons.verified_user_outlined),
                    border: OutlineInputBorder()),
              ),
              //Text("Product Name is $_productname")

              const SizedBox(
                height: 20.0,
              ),

              MyBtn(context),
            ],
          ),
        ));
  }

  OutlinedButton MyBtn(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Details(
                productname: _productname,
                // productprice: double.parse(_productprice),
                quentity: double.parse(_quentity),
                selling: double.parse(_sp),
                purchased: double.parse(_pp),
                tax: double.parse(_tax),

                //productQuentity
              );
            },
          ),
        );
      },
      child: Text(
        "Submit".toUpperCase(),
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
      ),
    );
  }
}

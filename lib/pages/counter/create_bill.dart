import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hmrodokan/components/bar_qr_scanner.dart';
import 'package:hmrodokan/components/inventory_card.dart';
import 'package:hmrodokan/components/products_card.dart';
import 'package:hmrodokan/firebase/firebase_firestore.dart';
import 'package:hmrodokan/model/bill.dart';
import 'package:hmrodokan/model/product.dart';
import 'package:hmrodokan/pages/counter/counter_dashboard.dart';
import 'package:hmrodokan/pages/counter/invoice.dart';
import 'package:hmrodokan/provider/bill.dart';
import 'package:hmrodokan/provider/user.dart';
import 'package:hmrodokan/utils.dart';
import 'package:provider/provider.dart';

class CreateBill extends StatefulWidget {
  const CreateBill({super.key});

  @override
  State<CreateBill> createState() => _CreateBillState();
}

TextStyle headerText = const TextStyle(
  fontSize: 21,
  fontWeight: FontWeight.bold,
);

TextStyle highlightedText = const TextStyle(
  fontWeight: FontWeight.bold,
);

class _CreateBillState extends State<CreateBill> {
  FirebaseFirestoreHelper firebaseFirestoreHelper = FirebaseFirestoreHelper();
  late final SearchController searchController;
  late final TextEditingController nameController;
  late final TextEditingController phoneNumberController;

  late BillModel billData;

  final List _paymentItems = [
    'Cash',
    'Due',
    'Card',
    'Esewa',
    'Khalti',
    'Mobile Banking'
  ];

  @override
  void initState() {
    searchController = SearchController();
    nameController = TextEditingController();
    phoneNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    nameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  // void _handleSearchText() {
  //   final text = searchController.text;

  //   if (text != '') {
  //     // search for items
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    BillProvider billProvider =
        Provider.of<BillProvider>(context, listen: true);

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                padding: const EdgeInsets.only(top: 20.0),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(color: Colors.black26, width: 1.0))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Back button
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back)),
                    // Search Input
                    Expanded(
                      child: SearchAnchor.bar(
                        searchController: searchController,
                        barHintText: 'Search products',
                        barElevation: const MaterialStatePropertyAll<double>(0),
                        viewBackgroundColor: Colors.white,
                        barBackgroundColor:
                            const MaterialStatePropertyAll(Colors.white),
                        suggestionsBuilder: (BuildContext context,
                            SearchController controller) async {
                          List<ProductModel> productModel =
                              await firebaseFirestoreHelper
                                  .fetchProductSuggestions(controller.text);

                          return List.generate(productModel.length,
                              (int index) {
                            return GestureDetector(
                              onTap: () {
                                billProvider.addProduct(productModel[index]);

                                Navigator.of(context).pop();
                              },
                              child: InventoryCard(
                                product: productModel[index],
                              ),
                            );
                          });
                        },
                      ),
                    ),
                    // Scanner QR
                    PopupMenuButton(
                        icon: const Icon(Icons.qr_code),
                        onSelected: (value) async {
                          ScanMode getScanMode = ScanMode.DEFAULT;
                          if (value == 0) {
                            getScanMode = ScanMode.QR;
                          }
                          if (value == 1) {
                            getScanMode = ScanMode.BARCODE;
                          }

                          String code =
                              await BarQRScan.scanBarQrCodeNormal(getScanMode);

                          if (code.isEmpty && context.mounted) {
                            return Utils().toastor(context,
                                'Scanner Code not Found for the given item in db');
                          }
                          // query to db and add to provider
                          ProductModel? prod = await firebaseFirestoreHelper
                              .searchByScanner(code);
                          if (prod == null && context.mounted) {
                            return Utils().toastor(context,
                                'Product Not Found in db for given code');
                          }
                          // add to provider
                          billProvider.addProduct(prod!);
                        },
                        itemBuilder: (context) {
                          return const [
                            PopupMenuItem(
                                value: 0,
                                child: ListTile(
                                  leading: Icon(Icons.qr_code),
                                  title: Text('Scan QR Code'),
                                )),
                            PopupMenuItem(
                                value: 1,
                                child: ListTile(
                                  leading: Icon(Icons.barcode_reader),
                                  title: Text('Scan Bar Code'),
                                )),
                          ];
                        })
                  ],
                ),
              )),
          // Main Screen
          Positioned(
              top: 80,
              left: 0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  // physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      for (ProductModel product in billProvider.productList)
                        ProductsCard(product: product),
                    ],
                  ),
                ),
              )),
          // Bottom Screen
          Positioned(
              bottom: 0,
              left: 0,
              // height: 150,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                    child: Row(
                      children: [
                        // create bill

                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (billProvider.productList.isNotEmpty) {
                                showOrderInProcess(
                                    context, billProvider, userProvider);
                              }
                            },
                            child: Container(
                              color: Colors.green,
                              child: const Center(
                                  child: Text(
                                'Create Bill',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                        ),

                        // total
                        Expanded(
                          child: Container(
                            color: Colors.blueGrey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Total',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Rs. ${billProvider.totalAmount}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  void showOrderInProcess(BuildContext context, BillProvider billProvider,
      UserProvider userProvider) {
    String dropDownValue = _paymentItems.first;
    double discount = 0;
    double paidAmount = 0;
    double refundAmount = 0;
    double totalAmount = billProvider.totalAmount;
    bool isLoading = false;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (context) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: StatefulBuilder(builder: ((context, setState) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Order in Progress',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          // input box
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Discount Amount',
                                      style: highlightedText,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: TextField(
                                        onChanged: (String value) {
                                          setState(() {
                                            discount = double.parse(value);
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Paid Amount',
                                      style: highlightedText,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextField(
                                      onChanged: (String value) {
                                        setState(() {
                                          paidAmount = double.parse(value);
                                          refundAmount = paidAmount -
                                              discount -
                                              totalAmount;
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // amounts
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          'Total Amount',
                                          style: highlightedText,
                                        ),
                                        Text(
                                          'Rs. ${totalAmount.toString()}',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Refund Amount',
                                          style: highlightedText,
                                        ),
                                        Text(
                                          'Rs. ${refundAmount.toString()}',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width * .7,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Payment Type'),
                              DropdownButton(
                                  value: dropDownValue,
                                  items: _paymentItems.map((item) {
                                    return DropdownMenuItem<String>(
                                        alignment: Alignment.centerLeft,
                                        value: item,
                                        child: Text(
                                          item,
                                        ));
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      dropDownValue = value!;
                                    });
                                  }),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: nameController,
                        decoration:
                            const InputDecoration(hintText: 'Enter Name'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: phoneNumberController,
                        decoration: const InputDecoration(
                            hintText: 'Enter Phonenumber'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          style: const ButtonStyle(
                            padding: MaterialStatePropertyAll(
                                EdgeInsets.symmetric(vertical: 20)),
                          ),
                          onPressed: isLoading
                              ? null
                              : () async {
                                  // create bill
                                  if (paidAmount == 0 && totalAmount == 0) {
                                    return Utils().toastor(context,
                                        'Please enter either name or phonenumber for due amount');
                                  }
                                  if (paidAmount < totalAmount &&
                                      (nameController.text.isEmpty ||
                                          phoneNumberController.text.isEmpty)) {
                                    return Utils().toastor(context,
                                        'Please enter either name or phonenumber for due amount');
                                  }

                                  setState(
                                    () {
                                      isLoading = true;
                                    },
                                  );
                                  try {
                                    billData = await firebaseFirestoreHelper
                                        .createBill(
                                            userProvider.getUser.uid,
                                            userProvider.getUser.storeId,
                                            totalAmount,
                                            discount,
                                            paidAmount,
                                            paidAmount < totalAmount
                                                ? 'due'
                                                : dropDownValue,
                                            nameController.text,
                                            phoneNumberController.text);

                                    // billProvider.productList
                                    // grab discount amount
                                    // paid amount

                                    for (ProductModel product
                                        in billProvider.productList) {
                                      await firebaseFirestoreHelper.createSales(
                                          billData.uid,
                                          product.uid,
                                          product.sellingPrice,
                                          product.purchasePrice,
                                          product.title,
                                          product.quantity,
                                          product.storeId);
                                    }

                                    billProvider.clearBill();
                                    setState(
                                      () {
                                        isLoading = false;
                                        discount = 0;
                                        paidAmount = 0;
                                        refundAmount = 0;
                                      },
                                    );

                                    if (context.mounted) {
                                      Utils().toastor(
                                          context, 'Bill Creation Successful');
                                      showOrderCompletionModal(context);
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      Utils().toastor(context, e.toString());
                                      Navigator.of(context).pop();
                                    }
                                  }

                                  billProvider.clearBill();
                                  setState(
                                    () {
                                      isLoading = false;
                                      discount = 0;
                                      paidAmount = 0;
                                      refundAmount = 0;
                                    },
                                  );
                                },
                          child: isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : const Text(
                                  'Create Bill',
                                  style: TextStyle(fontSize: 18),
                                )),
                    ],
                  ),
                );
              })),
            ),
          );
        });
  }

  void showOrderCompletionModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: MediaQuery.of(context).size.height * .5,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.check_circle),
                const Text(
                  'Order Completed!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your order has been successfully completed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        // get the bill id;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Invoice(bill: billData)));
                      },
                      child: const Text('Print'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Perform the share action
                        // Add your share logic here
                      },
                      child: const Text('Share'),
                    ),
                  ],
                ),
                IntrinsicWidth(
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.green),
                        foregroundColor:
                            MaterialStatePropertyAll(Colors.white)),
                    onPressed: () {
                      // Navigate to the home screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CounterDashboard())); // Close the modal
                      // Add your navigation logic here
                    },
                    child: const Text('Go to Home'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                IntrinsicWidth(
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.green),
                        foregroundColor:
                            MaterialStatePropertyAll(Colors.white)),
                    onPressed: () {
                      // Navigate to the home screen
                      Navigator.pop(context); // Close the modal
                      // Add your navigation logic here
                    },
                    child: const Text('Create New Bill'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

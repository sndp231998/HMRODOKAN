import 'package:flutter/material.dart';
import 'package:hmrodokan/firebase/firebase_firestore.dart';
import 'package:hmrodokan/model/bill.dart';
import 'package:hmrodokan/pages/counter/invoice.dart';
import 'package:hmrodokan/provider/user.dart';
import 'package:hmrodokan/utils.dart';
import 'package:provider/provider.dart';

TextStyle headerText = const TextStyle(
  fontSize: 21,
  fontWeight: FontWeight.bold,
);

TextStyle highlightedText = const TextStyle(
  fontWeight: FontWeight.bold,
);

class Due extends StatefulWidget {
  const Due({super.key});

  @override
  State<Due> createState() => _DueState();
}

class _DueState extends State<Due> {
  final FirebaseFirestoreHelper firebaseFirestoreHelper =
      FirebaseFirestoreHelper();

  bool isLoading = true;

  final List _paymentItems = [
    'Cash',
    'Due',
    'Card',
    'Esewa',
    'Khalti',
    'Mobile Banking'
  ];

  List<BillModel> billList = [];
  late final ScrollController _controller = ScrollController();

  Future<void> listBill(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    List<BillModel> bills;
    BillModel? lastBill =
        billList.isEmpty ? null : billList[billList.length - 1];
    try {
      bills = await firebaseFirestoreHelper.listDueBill(
          userProvider.getUser.storeId, lastBill);
      setState(() {
        if (lastBill == null) {
          billList = bills;
        } else {
          billList.addAll(bills);
        }
      });
    } catch (e) {
      if (context.mounted) return Utils().toastor(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  void handleScroll() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      listBill(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(handleScroll);

    listBill(context);
  }

  @override
  void dispose() {
    _controller.removeListener(handleScroll);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('Due Bills'),
      ),
      body: billList.isEmpty
          ? const Center(
              child: Text('No due bills to show'),
            )
          : RefreshIndicator(
              onRefresh: () {
                return listBill(context);
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: _controller,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Phone Number')),
                        DataColumn(label: Text('Issue Date')),
                        DataColumn(label: Text('Due Amount')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: [
                        for (BillModel bill in billList)
                          DataRow(cells: [
                            DataCell(Text(bill.name)),
                            DataCell(Text(bill.phonenumber)),
                            DataCell(Text(bill.issueDate.toString())),
                            DataCell(Text((bill.totalAmount -
                                    bill.discount -
                                    bill.paidAmount)
                                .toString())),
                            DataCell(IconButton(
                              onPressed: () {
                                // open dialog to perform actions
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        child: SizedBox(
                                          height: 140,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Invoice(
                                                                    bill:
                                                                        bill)));
                                                  },
                                                  child:
                                                      const Text('View Bill')),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    showOrder(context, bill);
                                                  },
                                                  child: const Text(
                                                      'Update Bill')),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              icon: const Icon(Icons.more_vert),
                            )),
                          ])
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void showOrder(BuildContext context, BillModel bill) {
    String dropDownValue = _paymentItems.first;
    double paidAmount = 0;
    double refundAmount = 0;
    double remainingAmount = bill.totalAmount - bill.discount - bill.paidAmount;
    bool isLoading = false;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: StatefulBuilder(builder: ((context, setState) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Pay Due Bill',
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Amount',
                                      style: highlightedText,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Rs. ${bill.totalAmount.toString()}',
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
                                          refundAmount =
                                              paidAmount - remainingAmount;
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
                                          'Due Amount',
                                          style: highlightedText,
                                        ),
                                        Text(
                                          'Rs. ${remainingAmount.toString()}',
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
                                  if (paidAmount == 0) {
                                    return Utils().toastor(context,
                                        'Please enter either name or phonenumber for due amount');
                                  }
                                  bool isDue = paidAmount < remainingAmount;
                                  setState(
                                    () {
                                      isLoading = true;
                                    },
                                  );
                                  BillModel updatedBill = BillModel(
                                      uid: bill.uid,
                                      totalAmount: bill.totalAmount,
                                      storeId: bill.storeId,
                                      counterId: bill.counterId,
                                      issueDate: bill.issueDate,
                                      discount: bill.discount,
                                      paidAmount: bill.paidAmount + paidAmount,
                                      paymentMethod: dropDownValue,
                                      name: bill.name,
                                      phonenumber: bill.phonenumber,
                                      isDue: isDue);
                                  try {
                                    await firebaseFirestoreHelper
                                        .updateBill(updatedBill);

                                    if (context.mounted) {
                                      Utils().toastor(
                                          context, 'Due Payment Successful');

                                      // Delay for a short duration before showing the completion modal
                                      await Future.delayed(
                                          const Duration(seconds: 2));
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      Utils().toastor(context, e.toString());
                                    }
                                  }

                                  setState(
                                    () {
                                      // isLoading = false;
                                      // paidAmount = 0;
                                      // refundAmount = 0;
                                    },
                                  );
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                },
                          child: isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : const Text(
                                  'Finish Bill',
                                  style: TextStyle(fontSize: 18),
                                )),
                    ],
                  ),
                ),
              );
            })),
          );
        });
  }
}

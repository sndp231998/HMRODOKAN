import 'package:flutter/material.dart';
import 'package:hmrodokan/firebase/firebase_firestore.dart';
import 'package:hmrodokan/model/bill.dart';
import 'package:hmrodokan/pages/counter/invoice.dart';
import 'package:hmrodokan/provider/user.dart';
import 'package:hmrodokan/utils.dart';
import 'package:provider/provider.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final FirebaseFirestoreHelper firebaseFirestoreHelper =
      FirebaseFirestoreHelper();

  bool isLoading = true;

  List<BillModel> billList = [];

  Future<void> listBill(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    List<BillModel> bills;
    try {
      bills = await firebaseFirestoreHelper.listBill(userProvider.getUser!.uid);
      setState(() {
        billList = bills;
      });
    } catch (e) {
      if (context.mounted) return Utils().toastor(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    listBill(context);
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
        title: const Text('History'),
      ),
      body: billList.isEmpty
          ? const Center(
              child: Text('No history to show'),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Sales ID')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Payment')),
                  DataColumn(label: Text('Total')),
                  DataColumn(label: Text('Action')),
                ],
                rows: [
                  for (BillModel bill in billList)
                    DataRow(cells: [
                      DataCell(Text(bill.uid)),
                      DataCell(Text(bill.issueDate.toString())),
                      DataCell(Text(bill.paymentMethod)),
                      DataCell(Text('Rs. ${bill.paidAmount.toString()}')),
                      DataCell(TextButton(
                        child: const Text('View'),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Invoice(bill: bill)));
                        },
                      )),
                    ])
                ],
              ),
            ),
    );
  }
}

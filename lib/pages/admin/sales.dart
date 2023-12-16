import 'package:flutter/material.dart';
import 'package:hmrodokan/firebase/firebase_firestore.dart';
import 'package:hmrodokan/model/bill.dart';
import 'package:hmrodokan/model/sales.dart';
import 'package:hmrodokan/provider/user.dart';
import 'package:hmrodokan/utils.dart';
import 'package:provider/provider.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

ButtonStyle activeTab = const ButtonStyle(
    side: MaterialStatePropertyAll(BorderSide(color: Colors.green, width: 1)));

class _SalesState extends State<Sales> {
  final FirebaseFirestoreHelper firebaseFirestoreHelper =
      FirebaseFirestoreHelper();
  bool isLoading = false;
  bool isMoreLoading = false;

  String currentTab = 'counter';
  final ScrollController _controller = ScrollController();

  List<SalesModel> salesList = [];
  List<BillModel> billList = [];

  void toggleTab(String value) {
    setState(() {
      currentTab = value;
    });
    listTab();
  }

  Future<void> listSales(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    List<SalesModel> sales;
    SalesModel? lastSales =
        salesList.isEmpty ? null : salesList[salesList.length - 1];
    try {
      sales = await firebaseFirestoreHelper.listSalesByStoreId(
          userProvider.getUser.storeId, lastSales);

      if (lastSales == null) {
        salesList = sales;
      } else {
        salesList.addAll(sales);
      }
    } catch (e) {
      if (context.mounted) return Utils().toastor(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> listBill(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    List<BillModel> bills;
    BillModel? lastBill =
        billList.isEmpty ? null : billList[billList.length - 1];
    try {
      bills = await firebaseFirestoreHelper.listBillByStore(
          userProvider.getUser.storeId, lastBill);
      if (lastBill == null) {
        billList = bills;
      } else {
        billList.addAll(bills);
      }
    } catch (e) {
      if (context.mounted) return Utils().toastor(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  void listTab() async {
    setState(() {
      isLoading = true;
    });
    if (currentTab == 'counter') {
      await listBill(context);
    }
    if (currentTab == 'product') {
      if (context.mounted) await listSales(context);
    }
  }

  void toggleMoreLoading(bool value) {
    setState(() {
      isMoreLoading = value;
    });
  }

  void handleScroll() async {
    toggleMoreLoading(true);
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      if (currentTab == 'counter' && mounted) {
        await listBill(context);
      }
      if (currentTab == 'product' && mounted) {
        await listSales(context);
      }
    }
    toggleMoreLoading(false);
  }

  @override
  void initState() {
    super.initState();
    listTab();
    _controller.addListener(handleScroll);
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
    return SingleChildScrollView(
      controller: _controller,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: TextButton(
                        style: currentTab == 'counter' ? activeTab : null,
                        onPressed: () {
                          toggleTab('counter');
                        },
                        child: const Text('Bills'))),
                Expanded(
                    child: TextButton(
                        style: currentTab == 'product' ? activeTab : null,
                        onPressed: () {
                          toggleTab('product');
                        },
                        child: const Text('Products'))),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
                child: currentTab == 'counter'
                    ? counterWidget()
                    : productWidget()),
            if (isMoreLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
          ],
        ),
      ),
    );
  }

  Widget counterWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
          headingRowColor: const MaterialStatePropertyAll(Colors.black12),
          columns: const [
            DataColumn(label: Text('Counter ID')),
            DataColumn(label: Text('Total Amount')),
            DataColumn(label: Text('Paid Amount')),
            DataColumn(label: Text('Discount')),
            DataColumn(label: Text('Payment Method')),
            DataColumn(label: Text('Issue At')),
          ],
          rows: [
            for (BillModel bills in billList)
              DataRow(cells: [
                DataCell(Text(bills.counterId)),
                DataCell(Text(bills.totalAmount.toString())),
                DataCell(Text(bills.paidAmount.toString())),
                DataCell(Text(bills.discount.toString())),
                DataCell(Text(bills.paymentMethod)),
                DataCell(Text(bills.issueDate.toString())),
                // DataCell(Text(sales.)),
              ]),
          ]),
    );
  }

  Widget productWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
          headingRowColor: const MaterialStatePropertyAll(Colors.black12),
          columns: const [
            DataColumn(label: Text('UID')),
            DataColumn(label: Text('Product Name')),
            DataColumn(label: Text('Quantity')),
            DataColumn(label: Text('Purchase At')),
            DataColumn(label: Text('Sold At')),
            // DataColumn(label: Text('Counter ID')),
          ],
          rows: [
            for (SalesModel sales in salesList)
              DataRow(cells: [
                DataCell(Text(sales.uid)),
                DataCell(Text(sales.name)),
                DataCell(Text(sales.quantity.toString())),
                DataCell(Text(sales.purchaseAt.toString())),
                DataCell(Text(sales.soldAt.toString())),
                // DataCell(Text(sales.)),
              ]),
          ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hmrodokan/components/dashboard_card.dart';
import 'package:hmrodokan/firebase/firebase_auth.dart';
import 'package:hmrodokan/firebase/firebase_firestore.dart';
import 'package:hmrodokan/provider/user.dart';
import 'package:hmrodokan/utils.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  FirebaseFirestoreHelper firebaseFirestoreHelper = FirebaseFirestoreHelper();
  FirebaseAuthHelper firebaseAuthHelper = FirebaseAuthHelper();

  bool isFetching = false;

  final List _analytics = [
    {
      'icon': Icon(
        Icons.attach_money,
        size: 50,
        color: Colors.green[800],
      ),
      'title': 'Total Profit',
      'amount': 'Rs. 22110',
    },
    {
      'icon': Icon(
        Icons.point_of_sale_sharp,
        size: 50,
        color: Colors.green[800],
      ),
      'title': 'Total Sales',
      'amount': 'Rs. 22110',
    },
    {
      'icon': Icon(
        Icons.money_off,
        size: 50,
        color: Colors.green[800],
      ),
      'title': 'Due Amount',
      'amount': 'Rs. 22110',
    },
    {
      'icon': Icon(
        Icons.inventory,
        size: 50,
        color: Colors.green[800],
      ),
      'title': 'Products Sold',
      'amount': '55',
    },
    {
      'icon': Icon(
        Icons.category,
        size: 50,
        color: Colors.green[800],
      ),
      'title': 'Out of Stock',
      'amount': '5',
    },
    {
      'icon': Icon(
        Icons.countertops,
        size: 50,
        color: Colors.green[800],
      ),
      'title': 'Counters',
      'amount': '3',
    },
    {
      'icon': Icon(
        Icons.warning,
        size: 50,
        color: Colors.green[800],
      ),
      'title': 'Due',
      'amount': '3',
    },
  ];

  void toggleIsFetching(bool value) {
    setState(() {
      isFetching = value;
    });
  }

  Future<void> loadData() async {
    if (!mounted) return;
    toggleIsFetching(true);
    late double totalSales;
    late int totalProductsSold;
    late int outOfStock;
    late int totalCounters;
    late double totalProfit;
    late int due;
    late double dueAmount;

    // Store the context before entering the asynchronous block
    BuildContext currentContext = context;
    try {
      // Get the user parameter from the provider
      UserProvider userProvider =
          Provider.of<UserProvider>(currentContext, listen: false);
      String storeId =
          userProvider.getUser.storeId; // Adjust this based on your user model

      Map<String, dynamic> salesWithProducts =
          await firebaseFirestoreHelper.getSalesWithProducts(storeId);

      totalProfit = salesWithProducts['totalProfit']!;
      totalSales = salesWithProducts['totalSales']!;
      totalProductsSold = salesWithProducts['totalProductsSold']!;
      dueAmount = salesWithProducts['dueAmount']!;
      outOfStock = await firebaseFirestoreHelper.getOutOfStock(storeId);
      totalCounters = await firebaseAuthHelper.getNoCounters(storeId);
      due =
          await firebaseFirestoreHelper.countDue(userProvider.getUser.storeId);
      if (mounted) {
        setState(() {
          // Update the state to trigger a rebuild with the new data

          _analytics[0]['amount'] = 'Rs. $totalProfit';
          _analytics[1]['amount'] = 'Rs. $totalSales';
          _analytics[2]['amount'] = 'Rs. $dueAmount';
          _analytics[3]['amount'] = '$totalProductsSold';
          _analytics[4]['amount'] = '$outOfStock';
          _analytics[5]['amount'] = '$totalCounters';
          _analytics[6]['amount'] = '$due';
        });
      }
    } catch (e) {
      // Handle error
      if (currentContext.mounted) Utils().toastor(currentContext, e.toString());
    }
    if (mounted) {
      toggleIsFetching(false);
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(_analytics.length, (index) {
        if (isFetching) {
          return SkeletonListView();
        }
        return DashboardCard(
          icon: _analytics[index]['icon'],
          title: _analytics[index]['title'],
          amount: _analytics[index]['amount'],
        );
      }),
    );
  }
}

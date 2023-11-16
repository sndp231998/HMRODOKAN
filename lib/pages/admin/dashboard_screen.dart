import 'package:flutter/material.dart';
import 'package:hmrodokan/components/dashboard_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List _analytics = [
    {
      'icon': const Icon(
        Icons.point_of_sale_sharp,
        size: 50,
        color: Colors.white,
      ),
      'title': 'Sales',
      'amount': 'Rs. 22110',
    },
    {
      'icon': const Icon(
        Icons.inventory,
        size: 50,
        color: Colors.white,
      ),
      'title': 'Products Sold',
      'amount': '55',
    },
    {
      'icon': const Icon(
        Icons.category,
        size: 50,
        color: Colors.white,
      ),
      'title': 'Out of Stock',
      'amount': '5',
    },
    {
      'icon': const Icon(
        Icons.countertops,
        size: 50,
        color: Colors.white,
      ),
      'title': 'Counters',
      'amount': '3',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(_analytics.length, (index) {
        return DashboardCard(
          icon: _analytics[index]['icon'],
          title: _analytics[index]['title'],
          amount: _analytics[index]['amount'],
        );
      }),
    );
  }
}

// add graph too and other stuffs
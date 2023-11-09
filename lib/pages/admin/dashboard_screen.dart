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
      'amount': '110',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(1, (index) {
        return DashboardCard(
          icon: _analytics[index]['icon'],
          title: _analytics[index]['title'],
          amount: _analytics[index]['amount'],
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hmrodokan/components/dashboard_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(5, (index) {
        return DashboardCard();
      }),
    );
  }
}

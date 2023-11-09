import 'package:flutter/material.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('History'),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('invoice');
            },
            shape: const Border(
              bottom: BorderSide(color: Colors.black12, width: 1.0),
            ),
            leading: const Icon(Icons.note_sharp),
            title: const Text('Sales ID: 10234'),
          ),
        ],
      ),
    );
  }
}

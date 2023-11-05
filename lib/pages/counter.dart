import 'dart:ffi';

import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  List producs = [
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
    {"id": 1, "name": 'masu', "price": 12, "qty": 12, "total": 12},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          title: Text(
            "Hmro Dokan",
          )),
      body: Column(
        children: [
          Container(
            height: 300,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(children: [
                  TableRow(children: [
                    Text(
                      "ID",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Name",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Price",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Qty",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Total",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Action",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ]),
                  for (int i = 0; i < producs.length; i++)
                    TableRow(children: [
                      Text('${producs[i]["id"]}'),
                      Text('${producs[i]["name"]}'),
                      Text('${producs[i]["price"]}'),
                      Text('${producs[i]["qty"]}'),
                      Text('${producs[i]["total"]}'),
                      ElevatedButton(
                        onPressed: () {
                          producs = producs
                              .where((element) =>
                                  element["id"] != producs[i]["id"])
                              .toList();
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
                    ]),
                ]),
              ),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text(
                        "Total: Rs 400000",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                          onPressed: null,
                          child: Text("Invoice"),
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStatePropertyAll<Color>(Colors.white),
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(Colors.green),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),

// icon: Icon(Icons.category), label: 'Category'),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: '')
        ],
        onTap: (int index) {
          // showDialog(context: context, builder: builder)
        },
      ),
    );
  }
}




// AlertDialog(
//                {
//                    Key key,
//                    Widget title,
//                    EdgeInsetsGeometry titlePadding,
//                    TextStyle titleTextStyle,
//                    Widget content,
//                    EdgeInsetsGeometry contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
//                    TextStyle contentTextStyle,
//                    List<Widget> actions,
//                    EdgeInsetsGeometry actionsPadding: EdgeInsets.zero,
//                    VerticalDirection actionsOverflowDirection,
//                    double actionsOverflowButtonSpacing,
//                    EdgeInsetsGeometry buttonPadding,
//                    Color backgroundColor,
//                    double elevation,
//                    String semanticLabel,
//                    EdgeInsets insetPadding: _defaultInsetPadding,
//                    Clip clipBehavior: Clip.none,
//                    ShapeBorder shape,
//                    bool scrollable: false
//              }
// )

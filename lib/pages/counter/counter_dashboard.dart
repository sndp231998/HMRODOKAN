import 'package:flutter/material.dart';
import 'package:hmrodokan/firebase/firebase_auth.dart';
import 'package:hmrodokan/firebase/firebase_firestore.dart';
import 'package:hmrodokan/model/store.dart';
import 'package:hmrodokan/pages/counter/create_bill.dart';
import 'package:hmrodokan/pages/counter/due.dart';
import 'package:hmrodokan/pages/counter/history.dart';
import 'package:hmrodokan/pages/counter/list_out_stock.dart';
import 'package:hmrodokan/provider/user.dart';
import 'package:hmrodokan/utils.dart';
import 'package:provider/provider.dart';

class CounterDashboard extends StatefulWidget {
  const CounterDashboard({super.key});

  @override
  State<CounterDashboard> createState() => _CounterDashboardState();
}

class _CounterDashboardState extends State<CounterDashboard> {
  int _currentIndex = 0;
  FirebaseAuthHelper authHelper = FirebaseAuthHelper();
  FirebaseFirestoreHelper firebaseFirestoreHelper = FirebaseFirestoreHelper();
  StoreModel? storeInfo;
  int dueBills = 0;
  bool isLoading = false;
  int outOfStock = 0;

  void toggleIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> fetchDetails() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    toggleIsLoading(true);

    try {
      int outStock = await firebaseFirestoreHelper
          .getOutOfStock(userProvider.getUser.storeId);
      int count =
          await firebaseFirestoreHelper.countDue(userProvider.getUser.storeId);
      StoreModel? result =
          await authHelper.getStoreInfo(userProvider.getUser.storeId);

      setState(() {
        storeInfo = result;
        dueBills = count;
        outOfStock = outStock;
      });
    } catch (e) {
      if (context.mounted) Utils().toastor(context, e.toString());
    }
    toggleIsLoading(false);
  }

  @override
  void initState() {
    fetchDetails();
    super.initState();
  }

  @override
  void dispose() {
    if (context.mounted) Navigator.of(context).pop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          return fetchDetails();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: const EdgeInsets.all(15.0),
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              storeInfo != null ? storeInfo!.name : 'Store ABC',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              storeInfo != null
                                  ? storeInfo!.address
                                  : 'Address XYZ',
                              style: const TextStyle(),
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: () async {
                              try {
                                await authHelper.signOut();
                              } catch (e) {
                                if (context.mounted) {
                                  Utils().toastor(context, e.toString());
                                }
                              }
                            },
                            icon: const Icon(Icons.logout_rounded))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateBill()),
                      );
                    },
                    child: Container(
                      height: 130,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Colors.blueGrey,
                              Colors.green,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black26,
                            width: 1.0,
                          )),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'New Bill',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Icon(
                              Icons.shop,
                              size: 50,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.black12,
                        width: 1.0,
                      ),
                      color: Colors.white,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.warning_amber,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Text(
                          '${isLoading ? 0 : dueBills.toString()} Due Bills',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => const Due())));
                            },
                            icon: const Icon(Icons.arrow_forward))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.black12,
                        width: 1.0,
                      ),
                      color: Colors.white,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.category,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Text(
                          '${isLoading ? 0 : outOfStock.toString()} Out of Stock',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) =>
                                      const ListOutStock())));
                            },
                            icon: const Icon(Icons.arrow_forward))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.black26,
          currentIndex: 0,
          onTap: (value) {
            setState(() {
              _currentIndex = value;
              // if (_currentIndex == 1) {
              //   Navigator.push(context,
              //       MaterialPageRoute(builder: (context) => const Inventory()));
              // }
              if (_currentIndex == 1) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const History()));
              }
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.inventory), label: 'Inventory'),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'History'),
          ]),
    );
  }
}

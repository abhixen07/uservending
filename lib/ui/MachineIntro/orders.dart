/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vending_app/ui/MachineIntro/cart_page.dart';
import 'select_machine_for_item.dart';

class OrderPage extends StatefulWidget {
  final List<String> selectedIds;
  final String machineId;

  OrderPage({required this.selectedIds, required this.machineId});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late Future<List<Map<String, dynamic>>> _selectedItemsFuture;
  late SharedPreferences _prefs; // Add SharedPreferences instance

  Map<String, String> itemQuantities = {};
  double totalBill = 0.0;

  @override
  void initState() {
    super.initState();
    _selectedItemsFuture = _fetchSelectedItems();
    _initSharedPreferences(); // Initialize SharedPreferences
  }

  // Method to initialize SharedPreferences
  _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadItemQuantities(); // Load item quantities from SharedPreferences
  }

  // Method to load item quantities from SharedPreferences
  _loadItemQuantities() {
    for (String id in widget.selectedIds) {
      String? quantity = _prefs.getString(id);
      if (quantity != null) {
        itemQuantities[id] = quantity;
      } else {
        itemQuantities[id] = '1'; // Set default quantity if not found
      }
    }
  }

  Future<List<Map<String, dynamic>>> _fetchSelectedItems() async {
    List<Map<String, dynamic>> selectedItemsData = [];
    await Future.forEach(widget.selectedIds, (String id) async {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Machines')
          .doc(widget.machineId)
          .collection('items')
          .doc(id)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        selectedItemsData.add(data);
      }
    });
    return selectedItemsData;
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFCC00),
        title: Text('Order'),
        centerTitle: true,
      ),
      //Double totalBill = 0.0,

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _selectedItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Order placed yet'));
          } else {
            totalBill = 0.0;
            for (int index = 0; index < snapshot.data!.length; index++) {
              Map<String, dynamic> itemData = snapshot.data![index];
              String itemId = widget.selectedIds[index];
              int quantity = int.parse(itemQuantities[itemId] ?? '1');
              double price = double.parse(itemData['price'].toString());
              double itemTotal = price * quantity;
              totalBill += itemTotal;
            }
            return  Column(
              children: [



                Text(
                  'ORDER SUMMARY',
                   style: TextStyle(fontSize: 20),
                ),
                /*
                Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                Container(
                  width: 100, // Fixed width of the first column
                  height: 40,
                  padding: EdgeInsets.all(8.0), // Fixed height of the first column
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name'),
                    ],
                  ),
                ),
                Container(
                  // Fixed height of the second column
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('price/Quantity'),
                    ],
                  ),
                ),
                Container(
                  // Fixed height of the third column
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Amount'),
                    ],
                  ),
                ),
              ],
            ),
                 */
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> itemData = snapshot.data![index];
                      String itemId = widget.selectedIds[index];
                      int quantity = int.parse(itemQuantities[itemId] ?? '1');
                      String imageUrl = itemData['imageUrl'] ?? '';


                      /*return ListTile(
                        contentPadding: EdgeInsets.all(10),


                        title: Text(
                          itemData['itemName'],
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text('Price: ${itemData['price']}'),
                            Text('Quantity: $quantity'),
                          ],
                        ),

                      );
                       */



                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,

                        children: [
                          Container(
                            width: 200, // Fixed width of the first column
                            height: 40,
                            padding: EdgeInsets.all(8.0), // Fixed height of the first column
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  itemData['itemName'],
                                ),
                              ],
                            ),
                          ),
                          Container(
                             // Fixed height of the second column
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${itemData['price']}'),
                              ],
                            ),
                          ),
                          Container(
                             // Fixed height of the third column
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('X$quantity=${int.parse(itemData['price'])*quantity }'),
                              ],
                            ),
                          ),
                        ],
                      );


                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Total Bill:    Rs.${totalBill.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                  ElevatedButton(
                  onPressed: () {
                    //Navigator.push(context,MaterialPageRoute(builder: (context) =>QRCodeGenerator(selectedIds: widget.selectedIds , machineId: widget.machineId,)),);

                  },
                  child: Text('QR Generator'), // Text displayed on the button
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),

            label: "My Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "My Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );


  }
  int _currentIndex = 2;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Handle tap events for each tab
    switch (index) {
      case 0:
        onHomeTapped();
        break;
      case 1:
        onCartTapped();
        break;
      case 2:
        onOrdersTapped();
        break;
      case 3:
        onProfileTapped();
        break;
    }
  }

  void onHomeTapped() {
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>selectMachineForItems() ),);

  }

  void onCartTapped() {
    //Navigator.of(context).pop();
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>CartPage(selectedIds: widget.selectedIds , machineId: widget.machineId,) ),);

  }

  void onOrdersTapped() {
    // Handle Orders icon tap
    print("Orders tapped");
  }

  void onProfileTapped() {
    // Handle Profile icon tap
    print("Profile tapped");
  }

}







 */

import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vending_app/ui/MachineIntro/cart_page.dart';
import 'package:vending_app/ui/MachineIntro/select_machine_for_item.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vending_app/ui/Pages/ProfilePage.dart';

class OrderPage extends StatefulWidget {
  final List<String> selectedIds;
  final String machineId;

  OrderPage({required this.selectedIds, required this.machineId});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late Future<List<Map<String, dynamic>>> _selectedItemsFuture;
  late SharedPreferences _prefs; // Add SharedPreferences instance

  Map<String, String> itemQuantities = {};
  double totalBill = 0.0;

  @override
  void initState() {
    super.initState();
    _selectedItemsFuture = _fetchSelectedItems();
    _initSharedPreferences(); // Initialize SharedPreferences
  }

  // Method to initialize SharedPreferences
  _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadItemQuantities(); // Load item quantities from SharedPreferences
  }

  // Method to load item quantities from SharedPreferences
  _loadItemQuantities() {
    for (String id in widget.selectedIds) {
      String? quantity = _prefs.getString(id);
      if (quantity != null) {
        itemQuantities[id] = quantity;
      } else {
        itemQuantities[id] = '1'; // Set default quantity if not found
      }
    }
  }

  Future<List<Map<String, dynamic>>> _fetchSelectedItems() async {
    List<Map<String, dynamic>> selectedItemsData = [];
    await Future.forEach(widget.selectedIds, (String id) async {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Machines')
          .doc(widget.machineId)
          .collection('items')
          .doc(id)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        selectedItemsData.add(data);
      }
    });
    return selectedItemsData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFCC00),
        title: Text('Order'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _selectedItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Order placed yet'));
          } else {
            totalBill = 0.0;
            for (int index = 0; index < snapshot.data!.length; index++) {
              Map<String, dynamic> itemData = snapshot.data![index];
              String itemId = widget.selectedIds[index];
              int quantity = int.parse(itemQuantities[itemId] ?? '1');
              double price = double.parse(itemData['price'].toString());
              double itemTotal = price * quantity;
              totalBill += itemTotal;
            }
            return Column(
              children: [
                Text(
                  'ORDER SUMMARY',
                  style: TextStyle(fontSize: 20),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> itemData = snapshot.data![index];
                      String itemId = widget.selectedIds[index];
                      int quantity = int.parse(itemQuantities[itemId] ?? '1');
                      String imageUrl = itemData['imageUrl'] ?? '';

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            height: 40,
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  itemData['itemName'],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${itemData['price']}'),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    'X$quantity=${int.parse(itemData['price']) * quantity}'),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Total Bill:    Rs.${totalBill.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {

                    _generateQRCode(widget.machineId,itemQuantities);
                  },
                  child: Text('QR Generator'),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "My Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "My Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  int _currentIndex = 2;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Handle tap events for each tab
    switch (index) {
      case 0:
        onHomeTapped();
        break;
      case 1:
        onCartTapped();
        break;
      case 2:
        onOrdersTapped();
        break;
      case 3:
        onProfileTapped();
        break;
    }
  }

  void onHomeTapped() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SelectMachineForItems()),
    );
  }

  void onCartTapped() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(
          selectedIds: widget.selectedIds,
          machineId: widget.machineId,
        ),
      ),
    );
  }

  void onOrdersTapped() {

  }

  void onProfileTapped() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }

  void _generateQRCode(String machineId, Map<String, String> itemQuantities) {
    // Generate QR code with machineId and itemIds with quantities
    String qrData = 'Machine ID: $machineId\n';
    qrData += 'Items:\n';
    itemQuantities.forEach((itemId, quantity) {
      qrData += '  $itemId: $quantity\n';
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 200.0,
            ),
            SizedBox(height: 20),
            Text(
              'Scan the QR code to proceed.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }



}

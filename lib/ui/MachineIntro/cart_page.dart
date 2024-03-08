/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatefulWidget {
  final List<String> selectedIds;
  final String machineId;

  CartPage({required this.selectedIds, required this.machineId});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<Map<String, dynamic>>> _selectedItemsFuture;

  Map<String, String> itemQuantities = {};

  @override
  void initState() {
    super.initState();
    _selectedItemsFuture = _fetchSelectedItems();
  }

  Future<List<Map<String, dynamic>>> _fetchSelectedItems() async {
    List<Map<String, dynamic>> selectedItemsData = [];
    // Query Firestore to fetch details of selected items using selectedIds
    await Future.forEach(widget.selectedIds, (String id) async {
      // Fetch the item document from the 'items' subcollection under the machine document
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Machines')
          .doc(widget.machineId)
          .collection('items')
          .doc(id)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        selectedItemsData.add(data);
        itemQuantities[id] = '1'; // Set initial quantity to 1 for each item
      }
    });
    return selectedItemsData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFCC00),
        title: Text('Cart'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _selectedItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items found in the cart'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> itemData = snapshot.data![index];
                String itemId = widget.selectedIds[index];
                // Display details of each selected item
                return ListTile(
                  title: Text(itemData['itemName']),
                  subtitle: Row(
                    children: <Widget>[
                      Text('Price: ${itemData['price']}'),
                      SizedBox(width: 20),
                      Text('Quantity: ${itemData['quantity']}'),
                      SizedBox(width: 20),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            int quantity = int.parse(itemQuantities[itemId] ?? '1');
                            if (quantity > 1) {
                              quantity--;
                              itemQuantities[itemId] = quantity.toString();
                            }
                          });
                        },
                      ),
                      Text('${itemQuantities[itemId]}'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            int quantity = int.parse(itemQuantities[itemId] ?? '1');
                            if (quantity < int.parse(itemData['quantity'])) {
                              quantity++;
                              itemQuantities[itemId] = quantity.toString();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}







 */

/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatefulWidget {
  final List<String> selectedIds;
  final String machineId;

  CartPage({required this.selectedIds, required this.machineId});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<Map<String, dynamic>>> _selectedItemsFuture;

  Map<String, String> itemQuantities = {};

  @override
  void initState() {
    super.initState();
    _selectedItemsFuture = _fetchSelectedItems();
  }

  Future<List<Map<String, dynamic>>> _fetchSelectedItems() async {
    List<Map<String, dynamic>> selectedItemsData = [];
    // Query Firestore to fetch details of selected items using selectedIds
    await Future.forEach(widget.selectedIds, (String id) async {
      // Fetch the item document from the 'items' subcollection under the machine document
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Machines')
          .doc(widget.machineId)
          .collection('items')
          .doc(id)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        selectedItemsData.add(data);
        itemQuantities[id] = '1'; // Set initial quantity to 1 for each item
      }
    });
    return selectedItemsData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFCC00),
        title: Text('Cart'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _selectedItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items found in the cart'));
          } else {
            double totalBill = 0.0; // Initialize total bill

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> itemData = snapshot.data![index];
                      String itemId = widget.selectedIds[index];
                      int quantity = int.parse(itemQuantities[itemId] ?? '1');
                      double price = double.parse(itemData['price'].toString());
                      double itemTotal = price * quantity; // Calculate total for each item
                      totalBill += itemTotal; // Accumulate total bill
                      // Display details of each selected item
                      return ListTile(
                        title: Text(itemData['itemName']),
                        subtitle: Row(
                          children: <Widget>[
                            Text('Price: ${itemData['price']}'),
                            SizedBox(width: 20),
                            Text('Quantity: ${itemData['quantity']}'),
                            SizedBox(width: 20),
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (quantity > 1) {
                                    quantity--;
                                    itemQuantities[itemId] = quantity.toString(); // Update the quantity in the map
                                    totalBill -= double.parse(itemData['price'].toString());
                                  }
                                });
                              },

                            ),
                            Text('$quantity'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  if (quantity < int.parse(itemData['quantity'])) {
                                    quantity++;
                                    itemQuantities[itemId] = quantity.toString();
                                    totalBill += double.parse(itemData['price'].toString());
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Text('Total Bill: \$${totalBill.toStringAsFixed(2)}'), // Display total bill at the bottom
              ],
            );
          }
        },
      ),
    );
  }

}

 */

/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatefulWidget {
  final List<String> selectedIds;
  final String machineId;

  CartPage({required this.selectedIds, required this.machineId});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<Map<String, dynamic>>> _selectedItemsFuture;

  Map<String, String> itemQuantities = {};

  @override
  void initState() {
    super.initState();
    _selectedItemsFuture = _fetchSelectedItems();
  }

  Future<List<Map<String, dynamic>>> _fetchSelectedItems() async {
    List<Map<String, dynamic>> selectedItemsData = [];
    // Query Firestore to fetch details of selected items using selectedIds
    await Future.forEach(widget.selectedIds, (String id) async {
      // Fetch the item document from the 'items' subcollection under the machine document
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Machines')
          .doc(widget.machineId)
          .collection('items')
          .doc(id)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        selectedItemsData.add(data);
        itemQuantities[id] = '1'; // Set initial quantity to 1 for each item
      }
    });
    return selectedItemsData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFCC00),
        title: Text('Cart'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _selectedItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items found in the cart'));
          } else {
            double totalBill = 0.0; // Initialize total bill

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> itemData = snapshot.data![index];
                      String itemId = widget.selectedIds[index];
                      int quantity = int.parse(itemQuantities[itemId] ?? '1');
                      double price = double.parse(itemData['price'].toString());
                      double itemTotal = price * quantity; // Calculate total for each item
                      totalBill += itemTotal; // Accumulate total bill
                      // Display details of each selected item
                      return ListTile(
                        title: Text(itemData['itemName']),
                        subtitle: Row(
                          children: <Widget>[
                            Text('Price: ${itemData['price']}'),
                            SizedBox(width: 20),
                            Text('Quantity: ${itemData['quantity']}'),
                            SizedBox(width: 20),
                            //Text('\$${totalBill.toStringAsFixed(2)}'),
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (quantity > 1) {
                                    quantity--;
                                    itemQuantities[itemId] = quantity.toString();
                                  }
                                });
                              },
                            ),
                            Text('$quantity'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  if (quantity < int.parse(itemData['quantity'])) {
                                    quantity++;
                                    itemQuantities[itemId] = quantity.toString();
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20), // Add some padding
                Text('Total Bill: \$${totalBill.toStringAsFixed(2)}'), // Display total bill at the bottom
              ],
            );
          }
        },
      ),
    );
  }
}
 */

/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatefulWidget {
  final List<String> selectedIds;
  final String machineId;

  CartPage({required this.selectedIds, required this.machineId});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<Map<String, dynamic>>> _selectedItemsFuture;

  Map<String, String> itemQuantities = {};
  double totalBill = 0.0; // Declare totalBill here

  @override
  void initState() {
    super.initState();
    _selectedItemsFuture = _fetchSelectedItems();
  }

  Future<List<Map<String, dynamic>>> _fetchSelectedItems() async {
    List<Map<String, dynamic>> selectedItemsData = [];
    // Query Firestore to fetch details of selected items using selectedIds
    await Future.forEach(widget.selectedIds, (String id) async {
      // Fetch the item document from the 'items' subcollection under the machine document
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Machines')
          .doc(widget.machineId)
          .collection('items')
          .doc(id)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        selectedItemsData.add(data);
        itemQuantities[id] = '1'; // Set initial quantity to 1 for each item
      }
    });
    return selectedItemsData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFCC00),
        title: Text('Cart'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _selectedItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items found in the cart'));
          } else {
            totalBill = 0.0; // Reset totalBill
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> itemData = snapshot.data![index];
                      String itemId = widget.selectedIds[index];
                      int quantity = int.parse(itemQuantities[itemId] ?? '1');
                      double price = double.parse(itemData['price'].toString());
                      double itemTotal = price * quantity; // Calculate total for each item
                      totalBill += itemTotal; // Accumulate total bill
                      // Display details of each selected item
                      return ListTile(
                        title: Text(itemData['itemName']),
                        subtitle: Row(
                          children: <Widget>[
                            Text('Price: ${itemData['price']}'),
                            SizedBox(width: 20),
                            Text('Quantity: ${itemData['quantity']}'),
                            SizedBox(width: 20),
                            Text('${totalBill.toStringAsFixed(2)}'),
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (quantity > 1) {
                                    quantity--;
                                    itemQuantities[itemId] = quantity.toString();
                                  }
                                });
                              },
                            ),
                            Text('$quantity'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  if (quantity < int.parse(itemData['quantity'])) {
                                    quantity++;
                                    itemQuantities[itemId] = quantity.toString();
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20), // Add some padding
                Text('Total Bill: \$${totalBill.toStringAsFixed(2)}'), // Display total bill at the bottom
              ],
            );
          }
        },
      ),
    );
  }
}

 */

/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatefulWidget {
  final List<String> selectedIds;
  final String machineId;

  CartPage({required this.selectedIds, required this.machineId});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<Map<String, dynamic>>> _selectedItemsFuture;

  Map<String, String> itemQuantities = {};
  double totalBill = 0.0; // Declare totalBill here

  @override
  void initState() {
    super.initState();
    _selectedItemsFuture = _fetchSelectedItems();
  }

  Future<List<Map<String, dynamic>>> _fetchSelectedItems() async {
    List<Map<String, dynamic>> selectedItemsData = [];
    // Query Firestore to fetch details of selected items using selectedIds
    await Future.forEach(widget.selectedIds, (String id) async {
      // Fetch the item document from the 'items' subcollection under the machine document
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Machines')
          .doc(widget.machineId)
          .collection('items')
          .doc(id)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        selectedItemsData.add(data);
        itemQuantities[id] = '1'; // Set initial quantity to 1 for each item
      }
    });
    return selectedItemsData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFCC00),
        title: Text('Cart'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _selectedItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items found in the cart'));
          } else {
            totalBill = 0.0; // Reset totalBill
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> itemData = snapshot.data![index];
                      String itemId = widget.selectedIds[index];
                      int quantity = int.parse(itemQuantities[itemId] ?? '1');
                      double price = double.parse(itemData['price'].toString());
                      double itemTotal = price * quantity; // Calculate total for each item
                      totalBill += itemTotal; // Accumulate total bill
                      // Display details of each selected item
                      return ListTile(
                        title: Text(itemData['itemName']),
                        subtitle: Row(
                          children: <Widget>[
                            Text('Price: ${itemData['price']}'),
                            SizedBox(width: 20),
                            Text('Quantity: ${itemData['quantity']}'),
                            SizedBox(width: 20),
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (quantity > 1) {
                                    quantity--;
                                    itemQuantities[itemId] = quantity.toString();
                                  }
                                });
                              },
                            ),
                            Text('$quantity'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  if (quantity < int.parse(itemData['quantity'])) {
                                    quantity++;
                                    itemQuantities[itemId] = quantity.toString();
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20), // Add some padding
                Container( // Wrap Text widget with a Container
                  padding: EdgeInsets.all(10), // Add padding for better appearance
                  child: Text(
                    'Total Bill: \$${totalBill.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20), // Adjust font size if needed
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}



 */

//commit

/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatefulWidget {
  final List<String> selectedIds;
  final String machineId;

  CartPage({required this.selectedIds, required this.machineId});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<Map<String, dynamic>>> _selectedItemsFuture;

  Map<String, String> itemQuantities = {};
  double totalBill = 0.0; // Declare totalBill here

  @override
  void initState() {
    super.initState();
    _selectedItemsFuture = _fetchSelectedItems();
  }

  Future<List<Map<String, dynamic>>> _fetchSelectedItems() async {
    List<Map<String, dynamic>> selectedItemsData = [];
    // Query Firestore to fetch details of selected items using selectedIds
    await Future.forEach(widget.selectedIds, (String id) async {
      // Fetch the item document from the 'items' subcollection under the machine document
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Machines')
          .doc(widget.machineId)
          .collection('items')
          .doc(id)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        selectedItemsData.add(data);
        itemQuantities[id] = '1'; // Set initial quantity to 1 for each item
      }
    });
    return selectedItemsData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFCC00),
        title: Text('Cart'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _selectedItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items found in the cart'));
          } else {
            // Calculate the total bill here
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
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> itemData = snapshot.data![index];
                      String itemId = widget.selectedIds[index];
                      int quantity = int.parse(itemQuantities[itemId] ?? '1');
                      double price = double.parse(itemData['price'].toString());
                      double itemTotal = price * quantity;
                      // Display details of each selected item
                      return ListTile(
                        title: Text(itemData['itemName']),
                        subtitle: Row(
                          children: <Widget>[
                            Text('Price: ${itemData['price']}'),
                            SizedBox(width: 20),
                            Text('Quantity: ${itemData['quantity']}'),
                            SizedBox(width: 20),
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (quantity > 1) {
                                    quantity--;
                                    itemQuantities[itemId] = quantity.toString();
                                  }
                                });
                              },
                            ),
                            Text('$quantity'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  if (quantity < int.parse(itemData['quantity'])) {
                                    quantity++;
                                    itemQuantities[itemId] = quantity.toString();
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20), // Add some padding
                Container( // Wrap Text widget with a Container
                  padding: EdgeInsets.all(10), // Add padding for better appearance
                  child: Text(
                    'Total Bill: \$${totalBill.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20), // Adjust font size if needed
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

 */


//commit


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vending_app/ui/MachineIntro/orders.dart';
import 'package:vending_app/ui/Pages/ProfilePage.dart';
import 'select_machine_for_item.dart';

class CartPage extends StatefulWidget {
  final List<String> selectedIds;
  final String machineId;

  CartPage({required this.selectedIds, required this.machineId});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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
        title: Text('Cart'),
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
            return Center(child: Text('No items found in the cart'));
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
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                       Map<String, dynamic> itemData = snapshot.data![index];
                       String itemId = widget.selectedIds[index];
                       int quantity = int.parse(itemQuantities[itemId] ?? '1');
                       String imageUrl = itemData['imageUrl'] ?? '';
                      // double price = double.parse(itemData['price'].toString());
                      // double itemTotal = price * quantity;
                      // totalBill += itemTotal;
                      /*
                       return ListTile(
                        leading: imageUrl.isNotEmpty ? Image.network(imageUrl) : SizedBox(),
                        title: Text(itemData['itemName'],
                            style: const TextStyle(fontWeight: FontWeight.bold,
                                fontSize: 16),),
                        subtitle: Row(
                          children: <Widget>[
                            Text('Price: ${itemData['price']}\nQuantity: ${itemData['quantity']}'),
                            SizedBox(width: 60),
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (quantity > 1) {
                                    quantity--;
                                    itemQuantities[itemId] = quantity.toString();
                                    _prefs.setString(itemId, quantity.toString()); // Update quantity in SharedPreferences
                                  }
                                });
                              },
                            ),
                            Text('$quantity'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  if (quantity < int.parse(itemData['quantity'])) {
                                    quantity++;
                                    itemQuantities[itemId] = quantity.toString();
                                    _prefs.setString(itemId, quantity.toString()); // Update quantity in SharedPreferences
                                  }
                                });
                              },
                            ),

                          ],
                        ),
                      );

                       */
                       return ListTile(
                         contentPadding: EdgeInsets.all(10),
                         leading: imageUrl.isNotEmpty ? ClipRRect(
                           borderRadius: BorderRadius.circular(8.0),
                           child: Image.network(
                             imageUrl,
                             fit: BoxFit.cover,
                           ),
                         ) : SizedBox(),
                         title: Text(
                           itemData['itemName'],
                           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                         ),
                         subtitle: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text('Price: ${itemData['price']}'),
                             Text('Quantity: ${itemData['quantity']}'),
                           ],
                         ),
                         trailing: Container(
                           width: 130,
                           height: 40,
                           padding: EdgeInsets.all(5),
                           decoration: BoxDecoration(
                             color: Colors.grey,
                             borderRadius: BorderRadius.circular(13),
                           ),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceAround,
                             children: [
                               IconButton(
                                 icon: Icon(
                                   CupertinoIcons.minus,
                                   color: Colors.white,
                                   size: 20,
                                 ),
                                 onPressed: () {
                                   setState(() {
                                     if (quantity > 1) {
                                       quantity--;
                                       itemQuantities[itemId] = quantity.toString();
                                       _prefs.setString(itemId, quantity.toString());
                                     }
                                   });
                                 },
                               ),
                               Text(
                                 '$quantity',
                                 style: TextStyle(
                                   fontSize: 19,
                                   color: Colors.white,
                                   fontWeight: FontWeight.bold,
                                 ),
                               ),
                               IconButton(
                                 icon: Icon(
                                   CupertinoIcons.plus,
                                   color: Colors.white,
                                   size: 20,
                                 ),
                                 onPressed: () {
                                   setState(() {
                                     if (quantity < int.parse(itemData['quantity'])) {
                                       quantity++;
                                       itemQuantities[itemId] = quantity.toString();
                                       _prefs.setString(itemId, quantity.toString());
                                     }
                                   });
                                 },
                               ),
                             ],
                           ),
                         ),
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
                    Navigator.push(context,MaterialPageRoute(builder: (context) =>OrderPage(selectedIds: widget.selectedIds , machineId: widget.machineId,) ),);
                  },
                  child: Text('Checkout'), // Text displayed on the button
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
  int _currentIndex = 1;

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
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>SelectMachineForItems() ),);

  }

  void onCartTapped() {

  }

  void onOrdersTapped() {
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>OrderPage(selectedIds: widget.selectedIds , machineId: widget.machineId,) ),);

  }

  void onProfileTapped() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage()));

  }

}



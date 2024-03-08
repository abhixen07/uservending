/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vending_app/ui/MachineIntro/cart_page.dart';
import 'package:vending_app/ui/MachineIntro/select_machine_for_item.dart';
import 'package:flutter/material.dart';


class ItemListScreen extends StatefulWidget {
  final String machineId;

  ItemListScreen({required this.machineId});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final auth = FirebaseAuth.instance;
  List<String> selectedIds = [];
  int cartItemCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFCC00),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Items List'),
            SizedBox(width: 10),
            buildCartIcon(),
          ],
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Machines')
            .doc(widget.machineId)
            .collection('items')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data found'));
          }
          return ListView(
            children: buildListTilesFromSubcollection(snapshot.data!),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
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
  int _currentIndex = 0;

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
    if (cartItemCount > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CartPage(selectedIds: selectedIds, machineId: widget.machineId),
        ),
      );


    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your cart is empty!')),
      );
    }
  }

  void onOrdersTapped() {
    // Handle Orders icon tap
    print("Orders tapped");
  }

  void onProfileTapped() {
    // Handle Profile icon tap
    print("Profile tapped");
  }


  Widget buildCartIcon() {
    return Stack(
      children: [
        IconButton(
          onPressed: () {
            if (cartItemCount > 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(selectedIds: selectedIds, machineId: widget.machineId),
                ),
              );


            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Your cart is empty!')),
              );
            }
          },
          icon: Icon(Icons.shopping_cart),
        ),
        cartItemCount > 0
            ? Positioned(
          right: 8,
          top: 8,
                 child: CircleAvatar(
            backgroundColor: Colors.red,
            radius: 10,
                   child: Text(
              cartItemCount.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        )
            : SizedBox(),
      ],
    );
  }

  void addToCart(String id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
        cartItemCount--;
      } else {
        selectedIds.add(id);
        cartItemCount++;
      }
    });
  }

  List<Widget> buildListTilesFromSubcollection(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>?;

      if (data != null) {
        String id = doc.id;
        String itemName = data['itemName'] ?? '';
        String price = data['price'] ?? '';
        String quantity = data['quantity'] ?? '';
        String imageUrl = data['imageUrl'] ?? '';
        bool isSelected = selectedIds.contains(id);
        return ListTile(
          leading: imageUrl.isNotEmpty ? Image.network(imageUrl) : SizedBox(),
          title: Text(itemName),
          subtitle: Text('Price: $price, Quantity: $quantity'),
          trailing: ElevatedButton(
            onPressed: () {
              addToCart(id);
            },
            child: Text(isSelected ? 'Remove from Cart' : 'Add to Cart'),
          ),
        );
      } else {
        return SizedBox();
      }
    }).toList();
  }
}

*/

//7commit


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vending_app/ui/MachineIntro/cart_page.dart';
import 'package:vending_app/ui/MachineIntro/orders.dart';
import 'package:vending_app/ui/MachineIntro/select_machine_for_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vending_app/ui/Pages/ProfilePage.dart';

class ItemListScreen extends StatefulWidget {
  final String machineId;

  ItemListScreen({required this.machineId});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final auth = FirebaseAuth.instance;
  List<String> selectedIds = [];
  int cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    _loadSelectedItems();
  }

  _loadSelectedItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedItems = prefs.getStringList(widget.machineId);
    if (storedItems != null) {
      setState(() {
        selectedIds = storedItems;
        cartItemCount = storedItems.length;
      });
    }
  }

  _saveSelectedItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(widget.machineId, selectedIds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFCC00),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Items List'),
            SizedBox(width: 10),
            buildCartIcon(),
          ],
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Machines')
            .doc(widget.machineId)
            .collection('items')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data found'));
          }
          return ListView(
            children: buildListTilesFromSubcollection(snapshot.data!),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
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

  int _currentIndex = 0;

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
    if (cartItemCount > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CartPage(selectedIds: selectedIds, machineId: widget.machineId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your cart is empty!')),
      );
    }
  }

  void onOrdersTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderPage(
            selectedIds: selectedIds, machineId: widget.machineId),
      ),
    );
  }

  void onProfileTapped() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage()));

  }

  Widget buildCartIcon() {
    return Stack(
      children: [
        IconButton(
          onPressed: () {
           // if (cartItemCount > 0)
            {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(
                      selectedIds: selectedIds, machineId: widget.machineId),
                ),
              );
            }
            /*
            else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Your cart is empty!')),
              );
            }

             */
          },
          icon: Icon(Icons.shopping_cart),
        ),
        cartItemCount > 0
            ? Positioned(
          right: 8,
          top: 8,
          child: CircleAvatar(
            backgroundColor: Colors.red,
            radius: 10,
            child: Text(
              cartItemCount.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        )
            : SizedBox(),
      ],
    );
  }

  void addToCart(String id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
        cartItemCount--;
      } else {
        selectedIds.add(id);
        cartItemCount++;
      }
    });
    _saveSelectedItems();
  }

  List<Widget> buildListTilesFromSubcollection(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>?;

      if (data != null) {
        String id = doc.id;
        String itemName = data['itemName'] ?? '';
        String price = data['price'] ?? '';
        String quantity = data['quantity'] ?? '';
        String imageUrl = data['imageUrl'] ?? '';
        bool isSelected = selectedIds.contains(id);
        return ListTile(
          leading: imageUrl.isNotEmpty ? Image.network(imageUrl) : SizedBox(),
          title: Text(itemName),
          subtitle: Text('Price: $price, Quantity: $quantity'),
          trailing: ElevatedButton(
            onPressed: () {
              addToCart(id);
            },
            child: Text(isSelected ? 'Remove from Cart' : 'Add to Cart'),
          ),
        );
      } else {
        return SizedBox();
      }
    }).toList();
  }
}

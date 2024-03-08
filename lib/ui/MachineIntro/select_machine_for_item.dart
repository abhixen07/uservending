import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vending_app/ui/Drawer/drawer_side.dart';
import 'package:vending_app/ui/MachineIntro/item_list_screen.dart';
import 'package:vending_app/ui/Pages/ProfilePage.dart';
import 'package:vending_app/ui/auth/login_screen.dart';
import 'package:vending_app/utils/utils.dart';

class SelectMachineForItems extends StatefulWidget {
  const SelectMachineForItems({Key? key});

  @override
  State<SelectMachineForItems> createState() => _SelectMachineForItemsState();
}

class _SelectMachineForItemsState extends State<SelectMachineForItems> {
  final auth = FirebaseAuth.instance;
  final searchController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('Machines').snapshots();

  String getMachineId(DocumentSnapshot doc) {
    return doc['id'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerSide(),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Color(0xffffcc00),
              automaticallyImplyLeading: false,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ],
              ),
              // title: const Text('Select Machine'),
              // centerTitle: true,

              expandedHeight: 150,
              flexibleSpace: FlexibleSpaceBar(
                background: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                    ),
                    items: [
                      Image.asset('assets/biscuitbanner.png'),
                      Image.asset('assets/milkbanner.png'),
                      Image.asset('assets/chocobanner.png'),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search by item name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String value) {
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: fireStore,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());

                  if (snapshot.hasError)
                    return Text('Error');

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                    return Center(child: Text('No data found'));

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var machineDoc = snapshot.data!.docs[index];
                      var machineId = getMachineId(machineDoc);
                      var machineName = machineDoc['machineName'].toString();
                      var location = machineDoc['location'].toString();
                      var imageUrl = machineDoc['imageUrl'].toString();

                      if (searchController.text.isNotEmpty) {
                        var subcollectionQuery = FirebaseFirestore.instance
                            .collection('Machines')
                            .doc(machineDoc.id)
                            .collection('items')
                            .where('itemName', isGreaterThanOrEqualTo: searchController.text.toUpperCase())
                            .where('itemName', isLessThanOrEqualTo: searchController.text.toUpperCase() + '\uf8ff');
                        return StreamBuilder<QuerySnapshot>(
                          stream: subcollectionQuery.snapshots(),
                          builder: (context, subSnapshot) {
                            if (subSnapshot.connectionState == ConnectionState.waiting)
                              return SizedBox.shrink(); // Hide the item if subcollection data is loading

                            if (subSnapshot.hasError)
                              return SizedBox.shrink(); // Hide the item if there's an error

                            if (!subSnapshot.hasData || subSnapshot.data!.docs.isEmpty)
                              return SizedBox.shrink(); // Hide the item if subcollection is empty

                            // Show the item if subcollection has matching data
                            return ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ItemListScreen(machineId: machineId)),
                                );
                              },
                              title: Text(machineName),
                              subtitle: Text('location: $location'),
                              leading: imageUrl.isNotEmpty
                                  ? Image.network(imageUrl)
                                  : Placeholder(),
                            );
                          },
                        );
                      }

                      // If search text is empty, show the item without checking subcollection
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ItemListScreen(machineId: machineId)),
                          );
                        },
                        title: Text(machineName),
                        subtitle: Text('location: $location'),
                        leading: imageUrl.isNotEmpty
                            ? Image.network(imageUrl)
                            : Placeholder(),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
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
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SelectMachineForItems()));
  }

  void onCartTapped() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select a Machine"),
          content: Text("Please select a machine before proceeding to the cart."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                });
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void onOrdersTapped() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select a Machine"),
          content: Text("Please select a machine before proceeding to the Order."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                });
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void onProfileTapped() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vending_app/ui/MachineIntro/select_machine_for_item.dart';
import 'package:vending_app/ui/Pages/ProfilePage.dart';

class DrawerSide extends StatefulWidget {
  final File? imageFile; // Add this line

  DrawerSide({Key? key, this.imageFile}) : super(key: key); // Modify this line

  @override
  _DrawerSideState createState() => _DrawerSideState();
}

class _DrawerSideState extends State<DrawerSide> {
  Color textColor = Colors.black;
  Color primaryColor = Colors.white;

  Widget listTile({
    String title = "",
    IconData? iconData,
    Color? backgroundColor,
    void Function()? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!), // Add a bottom border
        ),
      ),
      child: ListTile(
        onTap: onTap,
        tileColor: backgroundColor ?? Colors.white,
        trailing: Icon(Icons.arrow_forward_ios),
        leading: Icon(
          iconData ?? Icons.error,
          size: 28,
        ),
        title: Text(
          title,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Replace the following lines with your actual user data retrieval logic
    var userData = UserData(
      userName: "VEND VIBE",
      userEmail: "vendvibe@gmail.com",
      userImage: "assets/avatar.png", // Change to your local asset path
    );

    return Drawer(
      child: Container(
        color: primaryColor,
        child: ListView(
          children: [
            Container(
              color: Color(0xffffcc00), // Set the background color to yellow
              child: DrawerHeader(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 43,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          backgroundColor: Colors.black12,
                          backgroundImage: widget.imageFile != null
                              ? FileImage(widget.imageFile!)
                              : AssetImage(
                            userData.userImage,
                          ) as ImageProvider,
                          radius: 40,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(userData.userName),
                          Text(
                            userData.userEmail,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            listTile(
              iconData: Icons.home_outlined,
              title: "Home",
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SelectMachineForItems()));
              },
            ),
            listTile(
              iconData: Icons.shopping_cart,
              title: "My Cart",
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Select a Machine"),
                      content: Text(
                          "Please select a machine before proceeding to the cart."),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            // setState(() {
                            //   _currentIndex = 3;
                            // });
                            Navigator.of(context).pop();
                          },
                          child: Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            listTile(
              iconData: Icons.shop_outlined,
              title: "My Orders",
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Select a Machine"),
                      content: Text(
                          "Please select a machine before proceeding to the Order."),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            // setState(() {
                            //   _currentIndex = 3;
                            // });
                            Navigator.of(context).pop();
                          },
                          child: Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            listTile(
              iconData: Icons.person_outlined,
              title: "My Profile",
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
            // listTile(
            //     iconData: Icons.notifications_outlined, title: "Notifications"),
            // listTile(iconData: Icons.star_outline, title: "Rating & Review"),
            // listTile(iconData: Icons.format_quote_outlined, title: "FAQs"),
            SizedBox(
              height: 25,
            ),
            Container(
              height: 350,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Contact Support",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20, // Change the font size according to your preference
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "Call us:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15, // Change the font size according to your preference
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("+923352580282"),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(
                          "Mail us:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15, // Change the font size according to your preference
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "vendvibe@gmail.com",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UserData {
  final String userName;
  final String userEmail;
  final String userImage;

  UserData({
    required this.userName,
    required this.userEmail,
    required this.userImage,
  });
}

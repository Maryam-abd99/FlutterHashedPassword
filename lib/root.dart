// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:app/screens/home.dart';
import 'package:app/screens/profile_view.dart';
import 'package:app/screens/trips.dart';
import 'package:flutter/material.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF46923c),
        title: Text(
          _selectedIndex == 0
          ? "Home"
          : _selectedIndex == 1
          ? "Scan QR"
          : "Profile",
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      drawer: _selectedIndex == 0
      ? Drawer(
        shadowColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF46923c)
              ),
              child: Text(""),
            ),
            ListTile(
              title: Text("Trips"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Trips(),
                  )
                );
              },
            ),
            ListTile(
              title: Text("Booked trips"),
              onTap: () {},
            ),
            ListTile(
              title: Text("FAQ"),
            ),
            ListTile(
              title: Text("About us"),
            ),
          ],
        ),
      )
      : null,
      body: _selectedIndex == 0 ? Home() : _selectedIndex == 1 ? SizedBox() : ProfileView(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff46923c),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black87,
        selectedFontSize: 14,
        selectedLabelStyle: const TextStyle(
          letterSpacing: 0.3,
          fontWeight: FontWeight.bold,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white,),
            label: "Home",
            tooltip: "Go to home"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_rounded, color: Colors.white,),
            label: "Scan",
            tooltip: "Scan QR code"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white,),
            label: "Profile",
            tooltip: "View profile"
          ),
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
    );
  }
}
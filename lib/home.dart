import 'package:flutter/material.dart';
import 'package:money_manager_app/pages/catagory.dart';
import 'package:money_manager_app/pages/event.dart';
import 'package:money_manager_app/pages/homepage.dart';
import 'package:money_manager_app/pages/wallet.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeContent(),
    CategoryScreen(),
    Wallet(),
    EventPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,

        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.category_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.wallet_rounded), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: ""),
        ],
      ),
    );
  }
}
